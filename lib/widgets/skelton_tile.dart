import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sync_communication_app/core/core.dart';

class SkeletonTile extends StatelessWidget {
  const SkeletonTile({super.key, this.isCallTile = false});

  final bool isCallTile;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: context.baseColor,
      highlightColor: context.highlightColor,
      period: const Duration(milliseconds: 1200),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Container(
                    height: 11,
                    width: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
            if (isCallTile)
              Container(
                height: 15,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
