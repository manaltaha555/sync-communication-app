class PresenceData {
  final String uid;
  final bool isOnline;
  final int? lastSeen;

  PresenceData({required this.uid, required this.isOnline, this.lastSeen});

  factory PresenceData.fromJson(Map<String, dynamic> json) {
    return PresenceData(
      uid: json['uid'] as String,
      isOnline: json['isOnline'] as bool,
      lastSeen: json['lastSeen'] as int?,
    );
  }
}
