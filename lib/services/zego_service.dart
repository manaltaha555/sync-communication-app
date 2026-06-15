import 'package:firebase_core/firebase_core.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI([
    ZegoUIKitSignalingPlugin(),
  ]);
  LoggerService.logInfo("background message");
}

class ZegoService {
  ZegoService._();

  static final ZegoService instance = ZegoService._();

  Future<void> init({required String userId, required String userName}) async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission();
      LoggerService.logInfo(
        "Notification Permission: ${settings.authorizationStatus}",
      );

      final token = await FirebaseMessaging.instance.getToken();
      LoggerService.logInfo("FCM Token: $token");

      final overlayGranted = await Permission.systemAlertWindow.isGranted;
      LoggerService.logInfo(
        "Overlay Permission (before request): $overlayGranted",
      );

      if (!overlayGranted) {
        await Permission.systemAlertWindow
            .request(); // opens settings, returns immediately
        LoggerService.logInfo(
          "Overlay Permission requested — user sent to settings",
        );
      }

      await ZegoUIKitPrebuiltCallInvitationService().init(
        appID: 1019513980,
        appSign:
            "f50f98106e95972011902c4ef8b9f3665710b25d14b97dda6c20f826468a4042",
        userID: userId,
        userName: userName,
        plugins: [ZegoUIKitSignalingPlugin()],
        requireConfig: (data) {
          if (data.type == ZegoCallInvitationType.videoCall) {
            return ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall();
          }
          return ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();
        },
      );

      LoggerService.logInfo("ZegoService initialized for user: $userId");
    } catch (e, stackTrace) {
      LoggerService.logError('ZegoService.init failed', e, stackTrace);
      rethrow;
    }
  }

  Future<void> unInit() async {
    try {
      await ZegoUIKitPrebuiltCallInvitationService().uninit();
    } catch (e, stackTrace) {
      LoggerService.logError('ZegoService.unInit failed', e, stackTrace);
      rethrow;
    }
  }

  // void listenToConnectionState({required Function(bool isConnected) onStateChanged}) {
  //   ZegoUIKit().getSignalingPlugin().getConnectionStateStream().listen((state) {
  //     final isConnected = state == ZegoSignalingPluginConnectionState.connected;
  //     onStateChanged(isConnected);
  //   });
  // }
  Future<void> startVideoCall({
    required String targetUserId,
    required String targetUserName,
  }) async {
    try {
      final result = await ZegoUIKitPrebuiltCallInvitationService().send(
        invitees: [ZegoCallUser(targetUserId, targetUserName)],
        isVideoCall: true,
      );
      LoggerService.logInfo('send() result: $result');
    } catch (e, stackTrace) {
      LoggerService.logError(
        'ZegoService.startVideoCall failed',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  Future<void> startVoiceCall({
    required String targetUserId,
    required String targetUserName,
  }) async {
    try {
      LoggerService.logInfo('sending call');

      final result = await ZegoUIKitPrebuiltCallInvitationService().send(
        invitees: [ZegoCallUser(targetUserId, targetUserName)],
        isVideoCall: false,
      );
      LoggerService.logInfo('send() result: $result');
    } catch (e, stackTrace) {
      LoggerService.logError(
        'ZegoService.startVoiceCall failed ',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
