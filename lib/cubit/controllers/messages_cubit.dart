// cubit/messages/messages_cubit.dart
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sync_communication_app/cubit/state/messages_state.dart';
import 'package:sync_communication_app/data/models/message_model.dart';
import 'package:sync_communication_app/services/messages_service.dart';

class MessagesCubit extends Cubit<MessagesState> {
  MessagesCubit() : super(MessagesInitial());

  final MessagesService _messagesService = MessagesService.instance;
  StreamSubscription? _messagesSub;
  String? _currentChatId;

  Future<void> openChat(String chatId) async {
    _currentChatId = chatId;
    emit(MessagesLoading());
    _messagesSub?.cancel();

    _messagesSub = _messagesService.getMessages(chatId).listen((messages) {
      if (isClosed) return;
      emit(MessagesLoaded(messages));
    }, onError: (e) => emit(MessagesError(e.toString())));
  }

  Future<void> sendMessage({
    required String text,
    required String userId,
  }) async {
    if (_currentChatId == null) return;

    // Get current messages to keep them visible on error
    final currentMessages = switch (state) {
      MessagesLoaded s => s.messages,
      MessageSendError s => s.messages,
      _ => <MessageModel>[],
    };

    try {
      await _messagesService.sendMessage(
        chatId: _currentChatId!,
        message: MessageModel(
          createdAt: DateTime.now(),
          text: text,
          senderId: userId,
        ),
      );
    } catch (e) {
      emit(MessageSendError(messages: currentMessages, error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _messagesSub?.cancel();
    return super.close();
  }
}
