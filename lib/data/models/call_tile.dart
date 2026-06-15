enum CallType { video, voice }

class CallTile {
  final String? callId;
  final CallType callType;
  final String recieverId;
  final String senderId;
  final DateTime timestamp;
  final String? recieverName;

  CallTile({
    this.callId,
    required this.callType,
    required this.recieverId,
    required this.senderId,
    required this.timestamp,
    this.recieverName,
  });

  factory CallTile.fromMap(Map<String, dynamic> map, String callId) {
    return CallTile(
      callId: callId,
      callType: map['callType'] == 'video' ? CallType.video : CallType.voice,
      senderId: map['participants'][0] as String,
      recieverId: map['participants'][1] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
    );
  }

  Map<String, dynamic> toMap(String docRefId) {
    return {
      'callId': docRefId,
      'callType': callType == CallType.video ? 'video' : 'voice',
      'participants': [senderId, recieverId],
      'timestamp': timestamp.toIso8601String(),
    };
  }

  CallTile copyWith({
    String? callId,
    CallType? callType,
    String? recieverId,
    String? senderId,
    DateTime? timestamp,
    String? recieverName,
  }) {
    return CallTile(
      callId: callId ?? this.callId,
      callType: callType ?? this.callType,
      recieverId: recieverId ?? this.recieverId,
      senderId: senderId ?? this.senderId,
      timestamp: timestamp ?? this.timestamp,
      recieverName: recieverName ?? this.recieverName,
    );
  }
}
