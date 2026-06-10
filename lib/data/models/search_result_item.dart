import 'package:sync_communication_app/data/models/chat_model.dart';
import 'package:sync_communication_app/data/models/user_model.dart';

class SearchResultItem {
  final UserModel user;
  final ChatModel? existingChat; // null = no chat yet

  const SearchResultItem({required this.user, this.existingChat});

  bool get hasChat => existingChat != null;
}