import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/widgets/custom_painter_border.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    this.emoji,
    this.isOnline = false,
    this.padding = 8,
    this.isSearchTile = false,
    this.fontSize = 20
  });
  final String? emoji;
  final bool isOnline;
  final double padding;
  final bool isSearchTile;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(
          painter: GradientBorderPainter(),
          child: Container(
            // height: 50, width: 50,
            alignment: Alignment.center,
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: isSearchTile ? context.scheme.surface : null,
              shape: isSearchTile ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: isSearchTile
                  ? BorderRadius.all(Radius.circular(16))
                  : null,
            ),
            child: Text(emoji ?? "🧑", style: TextStyle(fontSize: fontSize)),
          ),
        ),
        if (isOnline)
          Positioned(
            bottom:  2,
            right: 2,
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.scheme.tertiary,
                // border: Border.all(
                //   color: context.scheme.surface,
                //   width: 2,
                // ),
              ),
            ),
          ),
      ],
    );
  }
}
