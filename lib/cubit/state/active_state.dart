import 'package:equatable/equatable.dart';
import 'package:sync_communication_app/data/models/user_model.dart';

abstract class ActiveState extends Equatable {
  const ActiveState();

  @override
  List<Object?> get props => [];
}

class ActiveInitial extends ActiveState {
  const ActiveInitial();
}

class ActiveUsersLoading extends ActiveState {
  const ActiveUsersLoading();
}

class ActiveUsersLoaded extends ActiveState {
  final List<UserModel> users;

  const ActiveUsersLoaded(this.users);

  @override
  List<Object?> get props => [users];
}

class ActiveUsersError extends ActiveState {
  final String message;

  const ActiveUsersError(this.message);

  @override
  List<Object?> get props => [message];
}