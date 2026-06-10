import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/cubit.dart';
import 'package:sync_communication_app/data/models/user_model.dart';
import 'package:sync_communication_app/widgets/user_avatar.dart';

class ActiveUserWidget extends StatelessWidget {
  const ActiveUserWidget({super.key, required this.activeUser});
  final UserModel activeUser;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final userId = context.read<UserCubit>().state.user?.uid;
        final chatId = getChatId(userId!, activeUser.uid);
        LoggerService.logInfo("chatId in activeWidget : $chatId");

        Navigator.pushNamed(
          context,
          AppRoutes.chat,
          arguments: {"chatId": chatId, "otherUser": activeUser},
        );
      },
      child: Column(
        children: [
          UserAvatar(
            emoji: activeUser.emoji,
            isOnline: activeUser.online ?? false,
            padding: 15,
            fontSize: 25,
            // right: 15,
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 60,
            child: Text(
              activeUser.username,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: context.textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}
