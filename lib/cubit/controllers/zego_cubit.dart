import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sync_communication_app/cubit/state/zego_state.dart';
import 'package:sync_communication_app/data/models/call_tile.dart';
import 'package:sync_communication_app/services/zego_service.dart';
import 'package:sync_communication_app/core/core.dart';

class ZegoCubit extends Cubit<ZegoState> {
  ZegoCubit() : super(const ZegoState());

  @override
  Future<void> close() async {
    await ZegoService.instance.unInit();
    return super.close();
  }

  Future<void> initCall({
    required String userId,
    required String userName,
  }) async {
    emit(state.copyWith(status: ZegoStatus.initializing));
    try {
      await ZegoService.instance.init(userId: userId, userName: userName);
      emit(state.copyWith(status: ZegoStatus.ready));
    } catch (e, stackTrace) {
      LoggerService.logError('ZegoCubit.initCall failed', e, stackTrace);
      emit(
        state.copyWith(status: ZegoStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> unInitCall() async {
    try {
      await ZegoService.instance.unInit();
      emit(const ZegoState()); // reset to idle
    } catch (e, stackTrace) {
      LoggerService.logError('ZegoCubit.unInitCall failed', e, stackTrace);
    }
  }

  Future<void> startVideoCall({
    required String targetUserId,
    required String targetUserName,
  }) async {
    if (state.status != ZegoStatus.ready) return;
    try {
      emit(state.copyWith(status: ZegoStatus.calling,  callType: CallType.video));
      LoggerService.logInfo(
        "Starting video call with targetUserId: $targetUserId, targetUserName: $targetUserName, state is ${state.status}",
      );
      await ZegoService.instance.startVideoCall(
        targetUserId: targetUserId,
        targetUserName: targetUserName,
      );
      emit(state.copyWith(status: ZegoStatus.ready));
      //   ZegoService.instance.listenToConnectionState(
      //   onStateChanged: (isConnected) {
      //     if (isClosed) return;
      //     emit(state.copyWith(
      //       status: isConnected ? ZegoStatus.ready : ZegoStatus.reconnecting,
      //     ));
      //   },
      // );
    } catch (e, stackTrace) {
      LoggerService.logError('ZegoCubit.startVideoCall failed', e, stackTrace);
      emit(
        state.copyWith(status: ZegoStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> startVoiceCall({
    required String targetUserId,
    required String targetUserName,
  }) async {
    try {
      LoggerService.logInfo('startVoiceCall called, state: ${state.status}');
      if (state.status != ZegoStatus.ready) return;
      emit(
        state.copyWith(status: ZegoStatus.calling,  callType: CallType.voice),
      );
      LoggerService.logInfo(
        "Starting voice call with targetUserId: $targetUserId, targetUserName: $targetUserName, state is ${state.status}",
      );
      await ZegoService.instance.startVoiceCall(
        targetUserId: targetUserId,
        targetUserName: targetUserName,
      );
      emit(state.copyWith(status: ZegoStatus.ready));
      //   ZegoService.instance.listenToConnectionState(
      //   onStateChanged: (isConnected) {
      //     if (isClosed) return;
      //     emit(state.copyWith(
      //       status: isConnected ? ZegoStatus.ready : ZegoStatus.reconnecting,
      //     ));
      //   },
      // );
    } catch (e, stackTrace) {
      LoggerService.logError('ZegoCubit.startVoiceCall failed', e, stackTrace);
      emit(
        state.copyWith(status: ZegoStatus.error, errorMessage: e.toString()),
      );
    }
  }
}
