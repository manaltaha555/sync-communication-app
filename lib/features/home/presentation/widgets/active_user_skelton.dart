import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sync_communication_app/core/theme/app_theme_extension.dart';

class ActiveUserSkeleton extends StatelessWidget {
  const ActiveUserSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.baseColor,
      highlightColor: context.highlightColor,
      period: const Duration(milliseconds: 1200),
      child: Container(
        width: 70,
        margin: EdgeInsets.only(right: 10),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              height: 10,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),

            const SizedBox(height: 6),

            Container(
              height: 10,
              width: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
