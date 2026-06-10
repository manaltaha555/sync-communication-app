import 'package:flutter/material.dart';

import '../core/core.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.onTap,
    required this.text,
    this.width,
  });
  final void Function()? onTap;
  final String text;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: width ?? MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: context.mainLinearGradient,
        ),
        child: Center(
          child: Text(
            text,
            style: context.textTheme.titleMedium!.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
