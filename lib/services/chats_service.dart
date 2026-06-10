import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/data/models/chat_model.dart';
import 'package:sync_communication_app/data/models/chat_tile_model.dart';
import 'package:sync_communication_app/data/models/user_model.dart';

class ChatsService {
  ChatsService._();
  static final ChatsService instance = ChatsService._();

  final _firestore = FirebaseFirestore.instance;

  //? when searching for a user, if there is already a chat between them, open it, if not create new one
  Future<String> createOrGetChat(String user1Id, String user2Id) async {
    try {
      final chatsRef = _firestore.collection('chats');

      final query = await chatsRef
          .where('participants', arrayContains: user1Id)
          .get();
      //? list of chat models (chatId + participants + lastMessage + updatedAt)

      for (var doc in query.docs) {
        List participants = doc['participants'];
        if (participants.contains(user2Id)) {
          return doc.id; // chat already exists
        }
      }
      final chatId = getChatId(user1Id, user2Id);

      final newChat = chatsRef.doc(chatId);

      await newChat.set({
        'participants': [user1Id, user2Id],
        'lastMessage': '',
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      return newChat.id; //? create chat if not existed
    } catch (e, stackTrace) {
      LoggerService.logError("Error creating or getting chat", e, stackTrace);
      throw "SomeThing went wrong";
    }
  }

  // 🔹 Get all chats for user (Home screen)
  Stream<List<ChatTileModel>> getUserChats(String userId) {
    try {
      return _firestore
          .collection('chats')
          .where('participants', arrayContains: userId)
          .orderBy('updatedAt', descending: true)
          .snapshots()
          .map((snapshot) {
            return snapshot.docs
                .map(
                  (doc) => ChatTileModel(
                    chat: ChatModel.fromJson(doc.data(), doc.id),
                    otherUser:
                        UserModel.empty(), // Replace with actual other user data
                  ),
                )
                .toList();
          });
    } catch (e, stackTrace) {
      LoggerService.logError("Error getting user chats", e, stackTrace);
      return Stream.error(e);
    }
  }

  Future<ChatModel?> getChatIfExists(String user1Id, String user2Id) async {
    try {
      final chatId = getChatId(user1Id, user2Id);
      final doc = await _firestore.collection('chats').doc(chatId).get();

      if (!doc.exists) return null;
      return ChatModel.fromJson(doc.data()!, chatId);
    } catch (e, stackTrace) {
      LoggerService.logError("Error checking chat existence", e, stackTrace);
      throw "Something went wrong";
    }
  }

  // Returns the list of UIDs [participant, user] the current user has ever chatted with
  // Returns the set of UIDs the current user has ever chatted with
  Future<Set<String>> getChatPartnerIds(String currentUid) async {
    try {
      final snapshot = await _firestore
          .collection('chats')
          .where('participants', arrayContains: currentUid)
          .get();

      return snapshot.docs.map((doc) {
        final participants = List<String>.from(doc['participants']);
        return participants.firstWhere((id) => id != currentUid);
      }).toSet();
    } catch (e, stackTrace) {
      LoggerService.logError("Error getting chat partner ids", e, stackTrace);
      return {};
    }
  }
}
