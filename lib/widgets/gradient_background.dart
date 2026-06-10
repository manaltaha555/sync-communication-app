import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/cubit.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    super.key,
    required this.child,
    this.appBar,
    this.resizeToAvoidBottomInset = true,
    this.bottomNavigationBar,
  });

  final Widget child;
  final PreferredSizeWidget? appBar;
  final bool? resizeToAvoidBottomInset;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeCubit>().state.isDark;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: appBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      bottomNavigationBar: bottomNavigationBar,
      extendBody: true,
      body: isDark
          ? Stack(
              children: [
                // base
                Container(color: const Color(0xff070B14)),

                // top blob
                Positioned(top: -120, left: -80, child: _buildDarkBlob()),

                // bottom blob
                Positioned(
                  bottom: -200,
                  right: -100,
                  child: _buildDarkBlob(size: 320),
                ),

                // middle blob
                Positioned(
                  top: 260,
                  right: -60,
                  child: _buildDarkBlob(size: 160),
                ),

                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
                    child: Container(color: Colors.transparent),
                  ),
                ),

                Positioned.fill(
                  child: Container(
                    color: Colors.black.withValues(alpha: 0.3),
                    child: child,
                  ),
                ),
              ],
            )
          // ───────────────────────── LIGHT THEME ─────────────────────────
          : Stack(
              children: [
                // base background
                Container(color: scheme.surface),

                // random soft blobs (static)
                Positioned(
                  top: 60,
                  left: -30,
                  child: _buildLightBlob(size: 110),
                ),

                Positioned(
                  top: 140,
                  right: -40,
                  child: _buildLightBlob(size: 140),
                ),

                Positioned(
                  top: 320,
                  left: 40,
                  child: _buildLightBlob(size: 90),
                ),

                Positioned(
                  bottom: 160,
                  right: 30,
                  child: _buildLightBlob(size: 120),
                ),

                Positioned(
                  bottom: 40,
                  left: 40,
                  child: _buildLightBlob(size: 80),
                ),

                Positioned(
                  top: 500,
                  right: 80,
                  child: _buildLightBlob(size: 60),
                ),

                // content
                Positioned.fill(child: Container(child: child)),
              ],
            ),
    );
  }

  // ───────────────── DARK BLOB ─────────────────
  Widget _buildDarkBlob({double size = 280}) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 120, sigmaY: 120),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.7),
              AppColors.secondary.withValues(alpha: 0.5),
            ],
          ),
        ),
      ),
    );
  }

  // ───────────────── LIGHT BLOB ─────────────────
  Widget _buildLightBlob({double size = 100}) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              AppColors.primary.withValues(alpha: 0.6),
              AppColors.primary.withValues(alpha: 0.5),

              AppColors.secondary.withValues(alpha: 0.6),
                            AppColors.secondary.withValues(alpha: 0.5),

              Colors.transparent,
            ],
          ),
        ),
      ),
    );
  }
}
