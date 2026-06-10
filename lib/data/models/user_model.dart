// import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_ce/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String username;

  @HiveField(1)
  final String? email;

  @HiveField(2)
  final String uid;

  @HiveField(3)
  final String? emoji;

  @HiveField(4)
  final bool? online;

  @HiveField(5)
  final DateTime? lastSeen;

  UserModel({
    required this.username,
    this.email,
    required this.uid,
    this.emoji,
    this.lastSeen,
    this.online,
  });

  // /// ?   Firebase -> Model  when login
  // factory UserModel.fromFirestore(User user, String? username,String? emoji) {
  //   return UserModel(
  //     username: username ?? "",
  //     email: user.email ?? "",
  //     uid: user.uid,
  //     emoji: emoji,

  //   );
  // }

  //? when search for users or get other user of chat
  factory UserModel.fromJson(Map<dynamic, dynamic> map) {
    return UserModel(
      username: map['username'] ?? "",
      email: map['email'] ?? "",
      uid: map['uid'] ?? "",
      emoji: map['emoji'],
      lastSeen: map['lastSeen'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastSeen'])
          : null,
      online: map['online'] as bool?,
    );
  }

  factory UserModel.empty() {
    return UserModel(
      username: '',
      email: null,
      uid: '',
      emoji: null,
      lastSeen: null,
      online: null,
    );
  }

  /// Model -> Map
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'uid': uid,
      'emoji': emoji,
      'lastSeen': lastSeen?.millisecondsSinceEpoch,
      'online': online,
    };
  }

  UserModel copyWith({
    String? username,
    String? email,
    String? uid,
    String? emoji,
    DateTime? lastSeen,
    bool? online,
  }) {
    return UserModel(
      username: username ?? this.username,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      emoji: emoji ?? this.emoji,
      lastSeen: lastSeen ?? this.lastSeen,
      online: online ?? this.online,
    );
  }
}