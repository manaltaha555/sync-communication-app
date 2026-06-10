import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sync_communication_app/core/core.dart';

class FirebaseAuthService {
  FirebaseAuthService._internal();

  static final FirebaseAuthService instance = FirebaseAuthService._internal();

  final _instance = FirebaseAuth.instance;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) throw "Something went wrong";
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-credential') {
        throw 'Email or password is incorrect';
      }
      if (e.code == 'user-not-found') throw "No user found for that email";
      if (e.code == 'wrong-password') {
        throw "Wrong password provided for that user";
      }
      throw "Something went wrong";
    }
  }

  Future<UserCredential> signup({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      final credential = await _instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) throw "Something went wrong";
      return credential;
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        LoggerService.logInfo("The password provided is too weak");
        throw 'The password provided is too weak';
      }
      if (e.code == 'email-already-in-use') {
        LoggerService.logInfo("Email already in use");
        throw "The account already exists for that email";
      }
      throw "Something went wrong";
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.signOut();

      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await _instance.signInWithCredential(credential);
      if (userCredential.user == null) throw "Something went wrong";
      return userCredential;

    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Something went wrong";
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        LoggerService.logInfo("Google sign in canceled by user");
        throw "Google sign in was canceled";
      }
      throw e.toString();
    } catch (e) {
      throw e.toString();
    }
  }

  Future<void> logout() async {
    try {
      // Sign out from Google only if user signed in with Google
      final isGoogleUser =
          _instance.currentUser?.providerData.any(
            (provider) => provider.providerId == 'google.com',
          ) ??
          false;

      if (isGoogleUser) {
        await GoogleSignIn.instance.signOut();
      }

      await _instance.signOut();
    } on FirebaseAuthException catch (e, stackTrace) {
      LoggerService.logError("Error during logout", e, stackTrace);
      throw e.message ?? "Something went wrong";
    } catch (e, stackTrace) {
      LoggerService.logError("Unexpected error during logout", e, stackTrace);
      throw e.toString();
    }
  }
}
