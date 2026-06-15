import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/cubit.dart';
import 'package:sync_communication_app/widgets/custom_painter_border.dart';

class CustomHeader extends SliverPersistentHeaderDelegate {
  const CustomHeader();

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
    // Animation only begins after the expanded text ("Welcome Back" + username)
    // has scrolled out of view. _animationDelay is the shrinkOffset at which
    // the transition starts; everything before it stays fully expanded.
    const double _animationDelay = 60.0;
    final animRange = (maxExtent - minExtent) - _animationDelay;
    final progress = ((shrinkOffset - _animationDelay) / animRange).clamp(
      0.0,
      1.0,
    );

    final avatarSize = lerpDouble(52, 40, progress)!;
    final fontSize = lerpDouble(28, 18, progress)!;

    final currentHeight =
        maxExtent - shrinkOffset.clamp(0.0, maxExtent - minExtent);

    final expandedAvatarCenter = currentHeight - 20 - avatarSize / 2;
    final collapsedAvatarCenter = (currentHeight + 15) / 2;
    final avatarTop =
        lerpDouble(expandedAvatarCenter, collapsedAvatarCenter, progress)! -
        avatarSize / 2;

    return BlocBuilder<UserCubit, UserState>(
      buildWhen: (prev, curr) =>
          prev.user?.username != curr.user?.username ||
          prev.user?.emoji != curr.user?.emoji,
      builder: (context, state) {
        final user = state.user;

        return _HeaderSurface(
          progress: progress,
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
                      user?.emoji ?? '🧑',
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
                  opacity: (1 - progress * 2).clamp(0.0, 1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Welcome Back', style: context.textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        user?.username ?? 'Unknown',
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
                  opacity: ((progress - 0.5) * 2).clamp(0.0, 1.0),
                  child: SizedBox(
                    height: avatarSize,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        user?.username ?? 'Unknown',
                        style: context.textTheme.titleMedium,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  bool shouldRebuild(covariant CustomHeader oldDelegate) => false;
}

/// Handles the background transition: transparent → frosted glass surface.
/// Uses [BackdropFilter] so the collapsed header looks polished instead of
/// a flat opaque block stamped over the list.
class _HeaderSurface extends StatelessWidget {
  const _HeaderSurface({required this.progress, required this.child});

  final double progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = context.scheme.brightness == Brightness.dark;

    // Blur increases as we collapse so content underneath is readable.
    final sigma = lerpDouble(0, 12, progress)!;

    // Surface tint: transparent when expanded, subtle when collapsed.
    final surfaceColor = Color.lerp(
      Colors.transparent,
      isDark
          ? context.scheme.surfaceContainerLow.withOpacity(0.85)
          : context.scheme.surfaceContainerLow.withOpacity(0.75),
      progress,
    )!;

    // A thin bottom divider fades in only when fully collapsed so there
    // is no jarring hard line while the user is mid-scroll.
    // final dividerOpacity = ((progress - 0.85) / 0.15).clamp(0.0, 1.0);

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: surfaceColor,
            // border: Border(
            //   bottom: BorderSide(
            //     color: context.scheme.outlineVariant.withOpacity(
            //       dividerOpacity * 0.4,
            //     ),
            //     width: 0.5,
            //   ),
            // ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: child,
          ),
        ),
      ),
    );
  }
}
