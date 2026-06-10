import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive_ce_flutter/hive_ce_flutter.dart';
import 'package:sync_communication_app/data/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';

class InitializeApp {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
    );
    await Hive.initFlutter();
    await Firebase.initializeApp();
    Hive.registerAdapter(UserModelAdapter());
    await Hive.openBox<UserModel>('user');
    await Hive.openBox('settings');
    await GoogleSignIn.instance.initialize(
      serverClientId:
          "760448700169-6kms24akg9oubkret4rvfm7analg7qna.apps.googleusercontent.com",
    );
  }
}
