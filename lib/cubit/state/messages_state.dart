import 'package:equatable/equatable.dart';
import 'package:sync_communication_app/data/models/message_model.dart';

abstract class MessagesState extends Equatable {
  const MessagesState();

  @override
  List<Object?> get props => [];
}

class MessagesInitial extends MessagesState {
  const MessagesInitial();
}

class MessagesLoading extends MessagesState {
  const MessagesLoading();
}

class MessagesLoaded extends MessagesState {
  final List<MessageModel> messages;

  const MessagesLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

class MessageSendError extends MessagesState {
  final List<MessageModel> messages;
  final String error;

  const MessageSendError({
    required this.messages,
    required this.error,
  });

  @override
  List<Object?> get props => [messages, error];
}

class MessagesError extends MessagesState {
  final String message;

  const MessagesError(this.message);

  @override
  List<Object?> get props => [message];
}