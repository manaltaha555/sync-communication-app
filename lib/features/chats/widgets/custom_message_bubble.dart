import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sync_communication_app/core/core.dart';

class CustomMessageBubble extends StatelessWidget {
  const CustomMessageBubble({
    super.key,
    required this.message,
    required this.isSender,
    required this.time,
  });

  final String message;
  final bool isSender;
  final DateTime time;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,

      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),

        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),

        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

        decoration: BoxDecoration(
          gradient: isSender
              ? context.mainLinearGradient
              : context.bubbleGradient,

          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(22),
            topRight: const Radius.circular(22),

            bottomLeft: Radius.circular(isSender ? 22 : 6),

            bottomRight: Radius.circular(isSender ? 6 : 22),
          ),

          border: Border.all(
            color: context.scheme.onSurface.withValues(alpha: 0.08),
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message,
              style: context.textTheme.bodyLarge!.copyWith(
                color: isSender
                    ? Colors.white
                    : context.textTheme.bodyLarge?.color,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              DateFormat('hh:mm a').format(time),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isSender
                    ? Colors.white
                    : context.scheme.onSurface.withValues(alpha: 0.65),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
