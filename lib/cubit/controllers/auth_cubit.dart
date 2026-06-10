import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sync_communication_app/cubit/state/auth_state.dart';
import 'package:sync_communication_app/services/firebase_auth_service.dart';
import 'package:sync_communication_app/services/firebase_firestore_service.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  final _authService = FirebaseAuthService.instance;
  final _firestoreService = FirebaseFirestoreService.instance;

  Future<void> login({required String email, required String password}) async {
    emit(AuthLoading());
    try {
      final credential = await _authService.login(
        email: email,
        password: password,
      );
      //*read user from firestore and emit authsuccess
      final userModel = await _firestoreService.getUserById(
        credential.user!.uid,
      );
      if (userModel == null) {
        emit(AuthError("User data not found"));
        return;
      }

      emit(AuthSuccess(userModel));
    } on SocketException {
      emit(AuthError("No internet connection"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final credential = await _authService.signInWithGoogle();
      final userModel = await _firestoreService.getUserById(
        credential.user!.uid,
      );
      if (userModel == null) {
        //? create new user
        final newUser = await _firestoreService.createNewUser(
          uid: credential.user!.uid,
          username: credential.user!.displayName ?? "Unknown",
          email: credential.user!.email ?? "",
        );
        emit(AuthSuccess(newUser));
      } else {
        emit(AuthSuccess(userModel));
      }
    } on SocketException {
      emit(AuthError("No internet connection"));
    } catch (e) {
      if (e.toString().contains('Google sign in was canceled')) {
        emit(AuthInitial());
        return;
      }
      emit(AuthError(e.toString()));
    }
  }

  Future<void> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    emit(AuthLoading());
    try {
      final credential = await _authService.signup(
        email: email,
        password: password,
        username: username,
      );
      final userModel = await _firestoreService.createNewUser(
        email: credential.user!.email!,
        uid: credential.user!.uid,
        username: username,
      );

      emit(AuthSuccess(userModel));
    } on SocketException {
      emit(AuthError("No internet connection"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    emit(AuthLoading());
    await Future.delayed(Duration(milliseconds: 300));
    try {
      await _authService.logout();
      
      emit(AuthLogout());
    } on SocketException {
      emit(AuthError("No internet connection"));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
