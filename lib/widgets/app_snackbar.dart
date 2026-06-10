// widgets/app_snack_bar.dart

import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';

class AppSnackBar {
  static void show(String message, {Color? color}) {
    final context = AppKey.navigatorKey.currentContext;
    if (context == null) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(color: context.scheme.onInverseSurface),
        ),
        backgroundColor: (color ?? context.scheme.inverseSurface).withValues(alpha: 0.85),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
