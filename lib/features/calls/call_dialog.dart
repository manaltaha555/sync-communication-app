import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/cubit.dart';
import 'package:sync_communication_app/data/models/call_tile.dart';

class CallDialog extends StatelessWidget {
  const CallDialog({
    super.key,
    required this.targetUserId,
    required this.targetUsername,
  });

  final String targetUsername;
  final String targetUserId;

  @override
  Widget build(BuildContext context) {
    final zegoCubit = context.read<ZegoCubit>();
    final callsCubit = context.read<CallsCubit>();
    final userId = context.read<UserCubit>().state.user?.uid;

    return AlertDialog(
      constraints: const BoxConstraints(
        maxHeight: 240,
        maxWidth: double.infinity,
        minWidth: double.infinity,
      ),
      backgroundColor: context.circleAvatarColor,
      title: Text("Call $targetUsername", style: context.textTheme.titleMedium),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Choose call type",
            style: context.textTheme.labelMedium!.copyWith(
              color: context.scheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 10),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.call_rounded, color: context.scheme.primary),
            title: Text(
              "Voice Call",
              style: context.textTheme.labelSmall!.copyWith(
                color: context.scheme.primary,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();

              zegoCubit.startVoiceCall(
                targetUserId: targetUserId,
                targetUserName: targetUsername,
              );
              callsCubit.addCall(
                CallTile(
                  callType: CallType.voice,
                  recieverId: targetUserId,
                  senderId: userId ?? "",
                  timestamp: DateTime.now(),
                ),
              );
            },
          ),

          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              Icons.videocam_rounded,
              color: context.scheme.primary,
            ),
            title: Text(
              "Video Call",
              style: context.textTheme.labelSmall!.copyWith(
                color: context.scheme.primary,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();

              zegoCubit.startVideoCall(
                targetUserId: targetUserId,
                targetUserName: targetUsername,
              );
              callsCubit.addCall(
                CallTile(
                  callType: CallType.video,
                  recieverId: targetUserId,
                  senderId: userId ?? "",
                  timestamp: DateTime.now(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
