import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/data/models/message_model.dart';

class MessagesService {
  MessagesService._();
  static final MessagesService instance = MessagesService._();

  final _firestore = FirebaseFirestore.instance;

  // 🔹 Send message
  Future<void> sendMessage({
    required String chatId,
    required MessageModel message,
  }) async {
    try {
      final messageRef = _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .doc();

      await messageRef.set(message.toJson());

      // update chat last message
      await _firestore.collection('chats').doc(chatId).update({
        'lastMessage': message.text,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e, stackTrace) {
      LoggerService.logError("Error sending message", e, stackTrace);
      throw "SomeThing went wrong";
    }
  }

  // 🔹 Get messages in chat (Chat screen)
  Stream<List<MessageModel>> getMessages(String chatId) {
    try {
      return _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('createdAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map((doc) => MessageModel.fromJson(doc.data(), doc.id))
                .toList();
          });
    } catch (e) {
      LoggerService.logError("Error getting messages", e, StackTrace.current);
      return Stream.error(e);
    }
  }
}
