import 'package:sync_communication_app/core/core.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ZegoService {
  ZegoService._();

  static final ZegoService instance = ZegoService._();

  Future<void> init({required String userId, required String userName}) async {
    try {
      await FirebaseMessaging.instance.requestPermission();
      ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(
        AppKey.navigatorKey,
      );

      ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI([
        ZegoUIKitSignalingPlugin(),
      ]);

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
