import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';

class ProfileTile extends StatelessWidget {
  const ProfileTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: context.scheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: context.scheme.onPrimaryContainer, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(label, style: context.textTheme.titleMedium)),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: context.scheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}
