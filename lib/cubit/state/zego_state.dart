import 'package:equatable/equatable.dart';
import 'package:sync_communication_app/data/models/call_tile.dart';

enum ZegoStatus { idle, initializing, ready, calling, reconnecting, error }

class ZegoState extends Equatable {
  final ZegoStatus status;
  final String? errorMessage;
  final CallType? callType;

  const ZegoState({
    this.callType = CallType.voice,
    this.status = ZegoStatus.idle,
    this.errorMessage,
  });

  ZegoState copyWith({
    ZegoStatus? status,
    String? errorMessage,
    CallType? callType,
  }) {
    return ZegoState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      callType: callType ?? this.callType,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}
