import 'package:sync_communication_app/data/models/chat_model.dart';
import 'package:sync_communication_app/data/models/user_model.dart';

class ChatTileModel {
  final ChatModel chat;
  final UserModel otherUser;

  ChatTileModel({required this.chat, required this.otherUser});
  ChatTileModel copyWith({UserModel? otherUser, ChatModel? chat}) {
    return ChatTileModel(
      chat: chat ?? this.chat,
      otherUser: otherUser ?? this.otherUser,
    );
  }
}
