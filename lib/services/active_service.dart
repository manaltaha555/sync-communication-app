import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/data/models/presence_data.dart';

// Lightweight model just for presence data from RTDB

class ActiveService {
  ActiveService._internal();

  static final ActiveService instance = ActiveService._internal();

  final FirebaseDatabase _db = FirebaseDatabase.instance;

  StreamSubscription<DatabaseEvent>? _connectionSub;

  // RTDB only holds presence now — uid, isOnline, lastSeen
  DatabaseReference _presenceRef(String uid) => _db.ref('presence/$uid');

  DatabaseReference get _connectedRef => _db.ref('.info/connected');

  Future<void> goOnline(String uid) async {
    try {
      final ref = _presenceRef(uid);

      await _connectionSub?.cancel();

      _connectionSub = _connectedRef.onValue.listen((event) async {
        final isConnected = event.snapshot.value as bool? ?? false;

        if (!isConnected) return;

        // Server executes this automatically when connection drops
        await ref.onDisconnect().update({
          'isOnline': false,
          'lastSeen': ServerValue.timestamp,
        });

        await ref.update({'isOnline': true, 'lastSeen': ServerValue.timestamp});
      });
    } catch (e, stackTrace) {
      LoggerService.logError("Error going online", e, stackTrace);
    }
  }

  Future<void> goOffline(String uid) async {
    try {
      await _connectionSub?.cancel();

      final ref = _presenceRef(uid);

      await ref.onDisconnect().cancel();

      await ref.update({'isOnline': false, 'lastSeen': ServerValue.timestamp});
    } catch (e, stackTrace) {
      LoggerService.logError("Error going offline", e, stackTrace);
    }
  }

  // Returns only UIDs that are currently online — no profile data here
  Stream<List<PresenceData>> watchOnlineUids() {
    return _db
        .ref('presence')
        .orderByChild('isOnline')
        .equalTo(true)
        .onValue
        .map((event) {
          final data = event.snapshot.value as Map<Object?, Object?>?;
          if (data == null) return [];
          return data.entries.map((e) {
            final map = Map<String, dynamic>.from(e.value as Map); // ← and here
            return PresenceData(
              uid: e.key as String,
              isOnline: map['isOnline'] as bool? ?? false,
              lastSeen: map['lastSeen'] as int?,
            );
          }).toList();
        });
  }

  Stream<PresenceData> watchUserPresence(String uid) {
    return _db.ref('presence/$uid').onValue.map((event) {
      final raw = event.snapshot.value;
      if (raw == null) {
        return PresenceData(
          uid: uid,
          isOnline: false,
          lastSeen: DateTime.now().millisecondsSinceEpoch,
        );
      }

      final map = Map<String, dynamic>.from(raw as Map);
      return PresenceData(
        uid: uid,
        isOnline: map['isOnline'] as bool? ?? false,
        lastSeen: map['lastSeen'] as int?,
      );
    });
  }

  Future<void> dispose() async {
    await _connectionSub?.cancel();
  }
}
