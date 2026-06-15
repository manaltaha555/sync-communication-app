import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/cubit.dart';
import 'package:sync_communication_app/data/models/chat_tile_model.dart';
import 'package:intl/intl.dart';
import 'package:sync_communication_app/widgets/user_avatar.dart';

class ChatTileWidget extends StatelessWidget {
  const ChatTileWidget({super.key, required this.chatTile});
  final ChatTileModel chatTile;

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeCubit>().state.isDark;
    return GestureDetector(
      onTap: () {
        LoggerService.logInfo(
          "chatIdi chatTileWidget : ${chatTile.chat.chatId}",
        );
        Navigator.pushNamed(
          context,
          AppRoutes.chat,
          arguments: {
            "chatId": chatTile.chat.chatId,
            "otherUser": chatTile.otherUser,
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: context.scheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.scheme.outline, width: 1.5),
          boxShadow: isDark? [
            BoxShadow(
              color: context.scheme.shadow,
              blurRadius: 20, 
              offset: const Offset(0, -4),
            ),
          ] : null
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            UserAvatar(
              emoji: chatTile.otherUser.emoji,
              isOnline: chatTile.otherUser.online ?? false,
              padding: 10,
              // right: 8,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        chatTile.otherUser.username,
                        maxLines: 1,
                        overflow: TextOverflow.clip,
                        textAlign: TextAlign.center,
                        style: context.textTheme.titleMedium,
                      ),

                      Text(
                        DateFormat('hh:mm a').format(
                          chatTile.chat.updatedAt,
                        ), // Format the DateTime to show only time
                        style: context.textTheme.bodySmall,
                      ),
                    ],
                  ),
                  Text(
                    chatTile.chat.lastMessage,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodyMedium!.copyWith(
                      color: context.scheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
