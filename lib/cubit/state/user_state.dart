import 'package:sync_communication_app/data/models/user_model.dart';

enum UserStatus {
  initial,
  loading,
  success,
  failure,
}

enum UserOperation {
  none,
  getUser,
  updateProfile,
  uploadEmoji,
  logout,
}

class UserState {
  const UserState({
    this.user,
    this.status = UserStatus.initial,
    this.operation = UserOperation.none,
    this.errorMessage,
  });

  final UserModel? user;
  final UserStatus status;
  final UserOperation operation;
  final String? errorMessage;

  bool get isLoading => status == UserStatus.loading;
  bool get isSuccess => status == UserStatus.success;
  bool get isFailure => status == UserStatus.failure;
  bool get isInitial => status == UserStatus.initial;
  bool get isUpdatingProfile => operation == UserOperation.updateProfile;
  bool get isUploadingEmoji => operation == UserOperation.uploadEmoji;
  
  bool get isLoggedIn => user != null;

  UserState copyWith({
    UserModel? user,
    UserStatus? status,
    UserOperation? operation,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return UserState(
      user: user ?? this.user,
      status: status ?? this.status,
      operation: operation ?? this.operation,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}