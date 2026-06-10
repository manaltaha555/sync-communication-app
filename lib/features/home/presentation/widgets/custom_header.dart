import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/data/models/user_model.dart';
import 'package:sync_communication_app/widgets/custom_painter_border.dart';

class CustomHeader extends SliverPersistentHeaderDelegate {
  final UserModel? user;

  CustomHeader({required this.user});

  @override
  double get maxExtent => 150;

  @override
  double get minExtent => 70;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final avatarSize = lerpDouble(52, 40, progress)!;
    final fontSize = lerpDouble(28, 18, progress)!;
    final headerColor = Color.lerp(
      Colors.transparent,
      context.scheme.surfaceContainerLow,
      progress,
    )!;

    // current header height
    final currentHeight = maxExtent - shrinkOffset.clamp(0.0, maxExtent - minExtent);

    // avatar vertical center position
    final expandedAvatarCenter = currentHeight - 20 - avatarSize / 2;
    final collapsedAvatarCenter = (currentHeight + 15) / 2;
    final avatarTop = lerpDouble(expandedAvatarCenter, collapsedAvatarCenter, progress)! - avatarSize / 2;

    return DecoratedBox(
      decoration: BoxDecoration(color: headerColor),
      child: Stack(
        children: [
          // ── Avatar ──
          Positioned(
            top: avatarTop,
            left: 0,
            child: CustomPaint(
              painter: GradientBorderPainter(),
              child: Container(
                width: avatarSize,
                height: avatarSize,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                ),
                child: Text(
                  user?.emoji ?? "🧑",
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ),
          ),

          // ── Expanded: "Welcome Back" + username ──
          Positioned(
            top: avatarTop,
            left: avatarSize + 15,
            child: Opacity(
              opacity: (1 - progress).clamp(0.0, 1.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Welcome Back",
                    style: context.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.username ?? "Unknown",
                    style: context.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),

          // ── Collapsed: username next to avatar ──
          Positioned(
            top: avatarTop,
            left: avatarSize + 26,
            child: Opacity(
              opacity: progress.clamp(0.0, 1.0),
              child: SizedBox(
                height: avatarSize,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    user?.username ?? "Unknown",
                    style: context.textTheme.titleMedium,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant CustomHeader oldDelegate) {
    return oldDelegate.user != user;
  }
}