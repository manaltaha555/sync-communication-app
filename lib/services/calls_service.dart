import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/data/models/call_tile.dart';

class CallsService {
  CallsService._();
  static final CallsService instance = CallsService._();

  final _firestore = FirebaseFirestore.instance;

  Future<void> addCall(CallTile callTile) async {
    try {
      await _firestore.collection('calls').add(callTile.toMap());
    } catch (e, stackTrace) {
      LoggerService.logError("Error adding call to Firestore", e, stackTrace);
      throw "Something went wrong";
    }
  }

  Future<List<CallTile>> getUserCalls(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection('calls')
          .where('participants', arrayContains: userId)
          .orderBy('timestamp', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => CallTile.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e, stackTrace) {
      LoggerService.logError(
        "Error fetching calls from Firestore",
        e,
        stackTrace,
      );
      throw "Something went wrong";
    }
  }
}
