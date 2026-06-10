import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/cubit.dart';
import 'package:sync_communication_app/data/models/call_tile.dart';
import 'package:sync_communication_app/features/calls/call_dialog.dart';
import 'package:sync_communication_app/widgets/gradient_background.dart';
import 'package:sync_communication_app/widgets/skelton_tile.dart';

class CallsPage extends StatefulWidget {
  const CallsPage({super.key});

  @override
  State<CallsPage> createState() => _CallsPageState();
}

class _CallsPageState extends State<CallsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  late String userId;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      userId = context.read<UserCubit>().state.user!.uid;
      context.read<CallsCubit>().getUserCalls(userId);
    });
  }

  Future<void> _refresh() async {
    await context.read<CallsCubit>().getUserCalls(userId);
  }

  bool _isIncoming(CallTile call) {
    return call.senderId != userId;
  }

  String _formatTime(DateTime time) {
    return DateFormat('dd/MM/yyyy  hh:mm a').format(time);
  }

  IconData _callIcon(CallType type) {
    return type == CallType.video ? Icons.videocam_rounded : Icons.call_rounded;
  }

  Color _statusColor(bool isIncoming) {
    return isIncoming ? Colors.greenAccent : Colors.blueAccent;
  }

  IconData _statusIcon(bool isIncoming) {
    return isIncoming ? Icons.call_received_rounded : Icons.call_made_rounded;
  }

  void _showCallDialog(CallTile call) {
    final targetUserId = _isIncoming(call) ? call.senderId : call.recieverId;

    final targetUserName = call.recieverName ?? "Unknown User";

    showDialog(
      context: context,
      builder: (dialogContext) {
        return BlocProvider.value(
          value: context.read<CallsCubit>(),
          child: CallDialog(
            targetUserId: targetUserId,
            targetUsername: targetUserName,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GradientBackground(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: BlocBuilder<CallsCubit, CallsState>(
          builder: (context, state) {
            if (state is CallsLoading) {
              return Column(
                children: [
                  SizedBox(height: 100),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        return const SkeletonTile(isCallTile: true);
                      },
                    ),
                  ),
                ],
              );
            }

            if (state is CallsError) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      state.message,
                      style: context.textTheme.titleMedium!.copyWith(
                        color: context.scheme.secondary,
                      ),
                    ),
                  ),
                ],
              );
            }

            if (state is CallsLoaded) {
              final calls = state.calls;

              if (calls.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "No Calls Yet",
                        style: context.textTheme.titleMedium!.copyWith(
                          color: context.scheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                );
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 16,
                      left: 16,
                      top: 50,
                    ),
                    child: Text(
                      "Your Calls",
                      style: context.textTheme.titleLarge,
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: calls.length,
                      itemBuilder: (context, index) {
                        final call = calls[index];
                        final isIncoming = _isIncoming(call);

                        return GestureDetector(
                          onTap: () => _showCallDialog(call),
                          child: Container(
                            margin: const EdgeInsets.only(
                              right: 12,
                              left: 12,
                              bottom: 8,
                            ),
                            // padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: context.scheme.surface,
                              borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: context.scheme.outline, width: 1.5),

                              boxShadow: [
                                BoxShadow(
                                  color: context.scheme.shadow,
                                  blurRadius: 20,
                                  offset: const Offset(0, -4),
                                ),
                              ],
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              leading: Container(
                                width: 46,
                                height: 46,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: context.mainLinearGradient,
                                ),
                                child: Icon(
                                  _callIcon(call.callType),
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                call.recieverName ?? "Unknown User",
                                style: context.textTheme.titleMedium
                              ),
                              subtitle: Text(
                                _formatTime(call.timestamp),
                                style:context.textTheme.bodySmall,
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: _statusColor(
                                    isIncoming,
                                  ).withValues(alpha: 0.15),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      _statusIcon(isIncoming),
                                      size: 16,
                                      color: _statusColor(isIncoming),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      isIncoming ? "Incoming" : "Outgoing",
                                      style: TextStyle(
                                        color: _statusColor(isIncoming),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
