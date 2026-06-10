class MessageModel {
  final String? id;
  final String senderId;
  final String text;
  final DateTime createdAt;

  MessageModel({
    this.id,
    required this.senderId,
    required this.text,
    required this.createdAt,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json, String id) {
    return MessageModel(
      id: id,
      senderId: json['senderId'] ?? '',
      text: json['text'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'text': text,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}