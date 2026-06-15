// State
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sync_communication_app/core/utils/logger.dart';
import 'package:sync_communication_app/cubit/state/user_state.dart';
import 'package:sync_communication_app/data/models/user_model.dart';
import 'package:sync_communication_app/services/firebase_firestore_service.dart';
import 'package:sync_communication_app/services/user_service.dart';

// Cubit
class UserCubit extends Cubit<UserState> {
  UserCubit() : super(const UserState());

  final _firestoreService = FirebaseFirestoreService.instance;
  final _userService = UserService.instance;

  Future<void> loadUser() async {
        if (isClosed) return;

    emit(state.copyWith(status: UserStatus.loading));
    final user = await _userService.getUser();
        if (isClosed) return;

    emit(
      state.copyWith(
        user: user,
        status: UserStatus.success,
        operation: UserOperation.getUser,
      ),
    );
  }

  Future<void> saveUser(UserModel userModel) async {
    await _userService.saveUser(userModel);
        if (isClosed) return;

    emit(
      state.copyWith(
        user: userModel,
        status: UserStatus.success,
        operation: UserOperation.getUser,
      ),
    );
  }

  Future<void> updateUsername(String username) async {
    final uid = state.user?.uid;
    if (uid == null) return;
    if (isClosed) return;

    emit(
      state.copyWith(
        status: UserStatus.loading,
        operation: UserOperation.updateProfile,
      ),
    );
    try {
      final updated = await _firestoreService.updateUser(
        uid: uid,
        username: username,
      );
      await _userService.saveUser(updated);
          if (isClosed) return;

      emit(
        state.copyWith(
          user: updated,
          status: UserStatus.success,
          operation: UserOperation.updateProfile,
        ),
      );
    } catch (e) {
          if (isClosed) return;

      emit(
        state.copyWith(
          status: UserStatus.failure,
          errorMessage: e.toString(),
          operation: UserOperation.updateProfile,
        ),
      );
    }
  }

  Future<void> updateEmoji(String emoji) async {
    final uid = state.user?.uid;
    if (uid == null) return;
    if (isClosed) return;

    emit(
      state.copyWith(
        status: UserStatus.loading,
        operation: UserOperation.uploadEmoji,
      ),
    );
    LoggerService.logInfo("loading");
    try {
      final updated = await _firestoreService.updateUser(
        uid: uid,
        emoji: emoji,
      );
      LoggerService.logInfo("firebase updated");
      await _userService.saveUser(updated);
      LoggerService.logInfo("hive updated");
          if (isClosed) return;

      emit(
        state.copyWith(
          user: updated,
          status: UserStatus.success,
          operation: UserOperation.uploadEmoji,
        ),
      );
    } catch (e) {
          if (isClosed) return;

      emit(
        state.copyWith(status: UserStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  void clearUser() {
    _userService.clearUser();
    if (isClosed) return;
    emit(const UserState());
  }
}
