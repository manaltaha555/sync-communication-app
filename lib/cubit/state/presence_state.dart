import 'package:equatable/equatable.dart';

abstract class PresenceState extends Equatable {
  const PresenceState();

  @override
  List<Object?> get props => [];
}

class PresenceInitial extends PresenceState {
  const PresenceInitial();
}

class PresenceOnline extends PresenceState {
  final String uid;

  const PresenceOnline({required this.uid});

  @override
  List<Object?> get props => [uid];
}

class PresenceOffline extends PresenceState {
  final String uid;

  const PresenceOffline({required this.uid});

  @override
  List<Object?> get props => [uid];
}