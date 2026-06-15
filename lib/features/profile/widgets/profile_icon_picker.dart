import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/features/profile/widgets/profile_picker_icon_sheet.dart';

class ProfileIconPicker extends StatelessWidget {
  const ProfileIconPicker({super.key, 
    required this.selectedIcon,
  });

  final String selectedIcon;

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => IconPickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Gradient ring ──
        Container(
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.mainLinearGradient,
            boxShadow: [
              BoxShadow(
                color: context.scheme.shadow,
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 52,
            backgroundColor:
                context.circleAvatarColor,
            child: Text(selectedIcon, style: const TextStyle(fontSize: 48)),
          ),
        ),
    
        // ── Edit button ──
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => _showPicker(context),
            child: Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: AppColors.mainLinearGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: context.scheme.shadow,
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Icon(
                Icons.emoji_emotions_rounded,
                size: 16,
                color: Colors.white
              ),
            ),
          ),
        ),
      ],
    );
  }
}


