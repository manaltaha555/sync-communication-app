import 'package:equatable/equatable.dart';
import 'package:sync_communication_app/data/models/chat_tile_model.dart';
import 'package:sync_communication_app/data/models/search_result_item.dart';

abstract class ChatListState extends Equatable {
  const ChatListState();

  @override
  List<Object?> get props => [];
}

class ChatListInitial extends ChatListState {
  const ChatListInitial();
}

class ChatListLoading extends ChatListState {
  const ChatListLoading();
}

class ChatListLoaded extends ChatListState {
  final List<ChatTileModel> chats;

  const ChatListLoaded(this.chats);

  @override
  List<Object?> get props => [chats];
}

class ChatListError extends ChatListState {
  final String message;

  const ChatListError(this.message);

  @override
  List<Object?> get props => [message];
}

// --- Search states ---

class SearchLoading extends ChatListState {
  const SearchLoading();
}

class SearchLoaded extends ChatListState {
  final List<SearchResultItem> results;

  const SearchLoaded(this.results);

  @override
  List<Object?> get props => [results];
}

class SearchError extends ChatListState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}