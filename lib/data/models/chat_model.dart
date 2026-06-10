class ChatModel {
  final String chatId;
  final List<String> participants;
  final String lastMessage;
  final DateTime updatedAt;

  ChatModel({
    required this.chatId,
    required this.participants,
    required this.lastMessage,
    required this.updatedAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json, String id) {
    return ChatModel(
      chatId: id,
      participants: List<String>.from(json['participants'] ?? []),
      lastMessage: json['lastMessage'] ?? '',
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participants': participants,
      'lastMessage': lastMessage,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }
}