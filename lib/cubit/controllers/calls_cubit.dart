import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/state/calls_state.dart';
import 'package:sync_communication_app/data/models/call_tile.dart';
import 'package:sync_communication_app/services/calls_service.dart';
import 'package:sync_communication_app/services/firebase_firestore_service.dart';

class CallsCubit extends Cubit<CallsState> {
  CallsCubit() : super(const CallsInitial());
  final FirebaseFirestoreService _firestoreService =
      FirebaseFirestoreService.instance;

  Future<void> getUserCalls(String userId) async {
    if (isClosed) return;
    emit(const CallsLoading());
    try {
      final callTiles = await CallsService.instance.getUserCalls(userId);
      final List<CallTile> tilesWithProfiles = [];

      for (final tile in callTiles) {
        final otherUser = await _firestoreService.getOtherUserOfChat(
          participants: [tile.senderId, tile.recieverId],
          currentUserId: userId,
        );
         if (isClosed) return;
        tilesWithProfiles.add(tile.copyWith(recieverName: otherUser.username));
      }

      if (isClosed) return;
      emit(CallsLoaded( tilesWithProfiles));
    } catch (e, stackTrace) {
      LoggerService.logError("CallsCubit.getUserCalls failed", e, stackTrace);
      if (isClosed) return;
      emit(CallsError(e.toString()));
    }
  }

  Future<void> addCall(CallTile callTile) async {
    try {
      await CallsService.instance.addCall(callTile);
    } catch (e, stackTrace) {
      LoggerService.logError("CallsCubit.addCall failed", e, stackTrace);
      if (isClosed) return;
      emit(CallsError(e.toString()));
    }
  }
}
