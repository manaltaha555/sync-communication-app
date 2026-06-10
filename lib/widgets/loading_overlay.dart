import 'package:flutter/material.dart';

class LoadingOverlay {
  LoadingOverlay._internal();
  static final LoadingOverlay instance = LoadingOverlay._internal();

  void showLoadingOverlay(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Loading",
      barrierColor: Color(0xCC0F0C29).withValues(alpha: 0.2),
      pageBuilder: (_, _, _) {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void hideLoadingOverlay(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
