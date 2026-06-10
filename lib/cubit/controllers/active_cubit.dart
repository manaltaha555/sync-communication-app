import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/state/active_state.dart';
import 'package:sync_communication_app/data/models/presence_data.dart';
import 'package:sync_communication_app/services/active_service.dart';
import 'package:sync_communication_app/services/chats_service.dart';
import 'package:sync_communication_app/services/firebase_firestore_service.dart';

class ActiveCubit extends Cubit<ActiveState> {
  final ActiveService _activeService = ActiveService.instance;
  final FirebaseFirestoreService _firestoreService =
      FirebaseFirestoreService.instance;

  final ChatsService _chatsService = ChatsService.instance;
  StreamSubscription? _onlineUidsSub;

  ActiveCubit() : super(ActiveInitial());


  void watchActiveUsers(String currentUid) {
    emit(ActiveUsersLoading());
    _onlineUidsSub?.cancel();

    _onlineUidsSub = _activeService.watchOnlineUids().listen((
      presenceList,
    ) async {
      // emit(ActiveUsersLoading());
    // await Future.delayed(Duration(seconds: 10));

      try {
        // Step 1: who does this user have chats with?
        final chatPartnerIds = await _chatsService.getChatPartnerIds(
          currentUid,
        );

        if (chatPartnerIds.isEmpty) {
          emit(ActiveUsersLoaded([]));
          return;
        }

        // Step 2: intersect — online AND has a chat with current user AND not self
        final relevantPresence = presenceList
            .where((p) => p.uid != currentUid && chatPartnerIds.contains(p.uid))
            .toList();

        if (relevantPresence.isEmpty) {
          emit(ActiveUsersLoaded([]));
          return;
        }

        // Step 3: batch-fetch Firestore profiles
        final uids = relevantPresence.map((p) => p.uid).toList();
        final users = await _firestoreService.getUsersByIds(uids);

        // Step 4: merge presence onto profiles
        final merged = users.map((user) {
          final presence = relevantPresence.firstWhere(
            (p) => p.uid == user.uid,
            orElse: () => PresenceData(uid: user.uid, isOnline: false),
          );

          return user.copyWith(
            online: presence.isOnline,
            lastSeen: presence.lastSeen != null
                ? DateTime.fromMillisecondsSinceEpoch(presence.lastSeen!)
                : null,
          );
        }).toList();

        emit(ActiveUsersLoaded(merged));
      } catch (e, stackTrace) {
        LoggerService.logError("Error watching active users", e, stackTrace);
        emit(ActiveUsersError("Failed to load active users"));
      }
    });
  }

  @override
  Future<void> close() async {
    await _onlineUidsSub?.cancel();
    await _activeService.dispose();
    return super.close();
  }
}
