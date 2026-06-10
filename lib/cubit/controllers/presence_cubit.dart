import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sync_communication_app/core/utils/logger.dart';
import 'package:sync_communication_app/cubit/state/presence_state.dart';
import 'package:sync_communication_app/services/active_service.dart';

class PresenceCubit extends Cubit<PresenceState> {
  PresenceCubit() : super(PresenceInitial());

  final ActiveService _activeService = ActiveService.instance;

  Future<void> activate(String uid) async {
    LoggerService.logInfo("Activating presence for uid: $uid");
    await _activeService.goOnline(uid);
    emit(PresenceOnline(uid: uid));
  }

  Future<void> deactivate() async {
    final current = state;
    if (current is PresenceOnline) {
      LoggerService.logInfo("Deactivating presence for uid: ${current.uid}");
      await _activeService.goOffline(current.uid);
    }
    emit(PresenceInitial());
  }
Future<void> onPaused() async {
    final current = state;
    if (current is PresenceOnline) {
      await _activeService.goOffline(current.uid);
      emit(PresenceOffline(uid: current.uid));
    }
  }

  Future<void> onResumed() async {
    final current = state;
    if (current is PresenceOffline) {
      await _activeService.goOnline(current.uid);
      emit(PresenceOnline(uid: current.uid));
    }
  }
}