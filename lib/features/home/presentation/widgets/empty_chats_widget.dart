import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:sync_communication_app/core/core.dart';

class EmptyChatsWidget extends StatelessWidget {
  const EmptyChatsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ShaderMask(
          shaderCallback: (bounds) =>
              context.mainLinearGradient.createShader(bounds),
          child: const Icon(Iconsax.messages, size: 64),
        ),
        SizedBox(height: 8),
        Text(
          'Search for someone to chat with',
          style: context.textTheme.headlineMedium!.copyWith(
            color: context.scheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}
