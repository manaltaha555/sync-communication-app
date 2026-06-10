// cubit/chat_list/chat_list_cubit.dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sync_communication_app/cubit/state/chat_list_state.dart';
import 'package:sync_communication_app/data/models/chat_tile_model.dart';
import 'package:sync_communication_app/data/models/presence_data.dart';
import 'package:sync_communication_app/data/models/search_result_item.dart';
import 'package:sync_communication_app/services/active_service.dart';
import 'package:sync_communication_app/services/chats_service.dart';
import 'package:sync_communication_app/services/firebase_firestore_service.dart';

class ChatListCubit extends Cubit<ChatListState> {
  ChatListCubit() : super(ChatListInitial());

  final ChatsService _chatService = ChatsService.instance;
  final ActiveService _activeService = ActiveService.instance;

  final FirebaseFirestoreService _firestoreService =
      FirebaseFirestoreService.instance;

  StreamSubscription? _chatsSub;

  // Holds active presence subscriptions per uid — cancelled and rebuilt
  // whenever the chat list changes (user starts a new chat)
  final Map<String, StreamSubscription> _presenceSubs = {};
  // Latest known presence per uid
  final Map<String, PresenceData> _presenceCache = {};
  // Latest known chat tiles (without presence)
  List<ChatTileModel> _latestTiles = [];

  Future<void> getUserChats(String userId) async {
    emit(ChatListLoading());
    // await Future.delayed(Duration(seconds: 10));

    _chatsSub?.cancel();

    _chatsSub = _chatService.getUserChats(userId).listen((chatTiles) async {
      try {
        // Step 1: fetch Firestore profiles for other users
        final List<ChatTileModel> tilesWithProfiles = [];

        for (final tile in chatTiles) {
          final otherUser = await _firestoreService.getOtherUserOfChat(
            participants: tile.chat.participants,
            currentUserId: userId,
          );
          tilesWithProfiles.add(
            ChatTileModel(chat: tile.chat, otherUser: otherUser),
          );
        }

        _latestTiles = tilesWithProfiles
            .take(30)
            .toList(); // Step 2: sync presence subscriptions to match current chat partners
        final currentPartnerIds = _latestTiles
            .map((t) => t.otherUser.uid)
            .where((uid) => uid.isNotEmpty)
            .toSet();

        // Cancel subs for users no longer in chat list
        final removed = _presenceSubs.keys
            .where((uid) => !currentPartnerIds.contains(uid))
            .toList();
        for (final uid in removed) {
          await _presenceSubs[uid]?.cancel();
          _presenceSubs.remove(uid);
          _presenceCache.remove(uid);
        }
        //! one subscription per chat partner  (better than do one subscription for all presence data - more data)
        for (final uid in currentPartnerIds) {
          if (_presenceSubs.containsKey(uid)) {
            continue; // already watching, skip
          }
          // open a live RTDB stream for this new uid
          _presenceSubs[uid] = _activeService.watchUserPresence(uid).listen((
            presence,
          ) {
            _presenceCache[uid] =
                presence; // update cache when their status changes
            _emitMerged(); // rebuild and emit the full list
          });
        }

        // Step 3: emit immediately with whatever presence we already have
        _emitMerged();
      } catch (e) {
        emit(ChatListError(e.toString()));
      }
    }, onError: (e) => emit(ChatListError(e.toString())));
  }

  void _emitMerged() {
    final merged = _latestTiles.map((tile) {
      final presence = _presenceCache[tile.otherUser.uid];
      if (presence == null) return tile;

      return tile.copyWith(
        otherUser: tile.otherUser.copyWith(
          online: presence.isOnline,
          lastSeen: presence.lastSeen != null
              ? DateTime.fromMillisecondsSinceEpoch(presence.lastSeen!)
              : null,
        ),
      );
    }).toList();

    emit(ChatListLoaded(merged));
  }

  Future<void> cleanSearch() async {
    emit(SearchLoaded([]));
  }

  Future<void> searchUsers({
    required String query,
    required String currentUserId,
  }) async {
    emit(SearchLoading());
    try {
      // ① fetch matched users
      final users = await _firestoreService.searchForUsers(
        query: query.trim(),
        currentUserId: currentUserId,
      );

      // ② + ③ for each user: compute chatId → check doc existence
      final results = await Future.wait<SearchResultItem>(
        users.map((user) async {
          final doc = await _chatService.getChatIfExists(
            currentUserId,
            user.uid,
          );

          return SearchResultItem(user: user, existingChat: doc);
        }),
      );

      emit(SearchLoaded(results));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<String> createOrGetChat(String user1Id, String user2Id) async {
    return _chatService.createOrGetChat(user1Id, user2Id);
  }

  @override
  Future<void> close() {
    _chatsSub?.cancel();
    return super.close();
  }
}
