import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sync_communication_app/core/utils/logger.dart';
import 'package:sync_communication_app/data/models/user_model.dart';

class FirebaseFirestoreService {
  FirebaseFirestoreService._internal();

  static final FirebaseFirestoreService instance =
      FirebaseFirestoreService._internal();

  final _instance = FirebaseFirestore.instance;

  Future<UserModel> createNewUser({
    required String uid,
    required String username,
    required String email,
  }) async {
    try {
      await _instance.collection('users').doc(uid).set({
        'uid': uid,
        'username': username,
        'email': email,
        'emoji': '🚀',
      });
      return UserModel(uid: uid, username: username, email: email, emoji: '🚀');
    } catch (e, stackTrace) {
      LoggerService.logError(
        "Error creating new user in Firestore",
        e,
        stackTrace,
      );
      throw "Something went wrong";
    }
  }

  Future<UserModel> updateUser({
    required String uid,
    String? username,
    String? emoji,
  }) async {
    try {
      // Only update fields that were actually provided
      final Map<String, dynamic> data = {};
      if (username != null) data['username'] = username;
      if (emoji != null) data['emoji'] = emoji;

      await _instance.collection('users').doc(uid).update(data);

      // Fetch the updated doc so we return the full, accurate model
      final doc = await _instance.collection('users').doc(uid).get();
      return UserModel.fromJson(doc.data()!);
    } catch (e, stackTrace) {
      LoggerService.logError("Error updating user in Firestore", e, stackTrace);
      throw "Something went wrong";
    }
  }

  Future<UserModel?> getUserById(String uid) async {
    final doc = await _instance.collection('users').doc(uid).get();
    if (!doc.exists) return null;
    return UserModel.fromJson(doc.data()!);
  }

  // Batch-fetch multiple profiles in a single Firestore read
  // Called by the Cubit after getting the online UIDs list from RTDB
  Future<List<UserModel>> getUsersByIds(List<String> uids) async {
    if (uids.isEmpty) return [];

    try {
      final snapshot = await _instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: uids)
          .get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .toList();
    } catch (e, stackTrace) {
      LoggerService.logError("Error batch fetching users", e, stackTrace);
      return [];
    }
  }

  Future<UserModel> getOtherUserOfChat({
    required List<String> participants,
    required String currentUserId,
  }) async {
    final otherUserId = participants.firstWhere((id) => id != currentUserId);
    final doc = await _instance.collection('users').doc(otherUserId).get();
    return UserModel.fromJson(doc.data()!);
  }

  Future<List<UserModel>> searchForUsers({
    required String query,
    required String currentUserId,
  }) async {
    try {
      final lower = query.toLowerCase().trim();
      final snapshot = await _instance.collection('users').get();

      return snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data()))
          .where((u) => u.uid != currentUserId)
          .where((u) => u.username.toLowerCase().contains(lower))
          .toList();
    } catch (e, stackTrace) {
      LoggerService.logError("Error searching users", e, stackTrace);
      throw "Something went wrong";
    }
  }
}
