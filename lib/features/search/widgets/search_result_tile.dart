import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/cubit.dart';
import 'package:sync_communication_app/data/models/search_result_item.dart';
import 'package:sync_communication_app/widgets/user_avatar.dart';

class SearchResultTile extends StatelessWidget {
  final SearchResultItem item;
  final String currentUserId;

  const SearchResultTile({
    super.key,
    required this.item,
    required this.currentUserId,
  });

  void _openOrCreateChat(BuildContext context) async {
    String chatId;

    if (item.hasChat) {
      chatId = item.existingChat!.chatId;
    } else {
      chatId = await context.read<ChatListCubit>().createOrGetChat(
        currentUserId,
        item.user.uid,
      );
    }

    if (context.mounted) {
      Navigator.pushNamed(
        context,
        AppRoutes.chat,
        arguments: {"chatId": chatId, "otherUser": item.user},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openOrCreateChat(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: context.scheme.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: context.scheme.outline,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            // Avatar
            UserAvatar(
              isSearchTile: true,
              emoji: item.user.emoji,
              isOnline: item.user.online ?? false,
              padding: 10,
              // right: 6,
            ),
            const SizedBox(width: 12),

            // Name + last message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.user.username, style: context.textTheme.titleMedium),
                ],
              ),
            ),

            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: context.mainLinearGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                item.hasChat
                    ? Icons.chat_bubble_outline_rounded
                    : Icons.person_add_alt_1_outlined,
                size: 18,
                color: Colors.white
              ),
            ),
          ],
        ),
      ),
    );
  }
}
