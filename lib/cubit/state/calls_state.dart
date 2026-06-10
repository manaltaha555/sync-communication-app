import 'package:equatable/equatable.dart';
import 'package:sync_communication_app/data/models/call_tile.dart';

abstract class CallsState extends Equatable {
  const CallsState();

  @override
  List<Object?> get props => [];
}

class CallsInitial extends CallsState {
  const CallsInitial();
}

class CallsLoading extends CallsState {
  const CallsLoading();
}

class CallsLoaded extends CallsState {
  final List<CallTile> calls;

  const CallsLoaded(this.calls);

  @override
  List<Object?> get props => [calls];
}

class CallsError extends CallsState {
  final String message;

  const CallsError(this.message);

  @override
  List<Object?> get props => [message];
}