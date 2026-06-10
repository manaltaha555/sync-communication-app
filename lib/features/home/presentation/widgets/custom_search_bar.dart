import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/cubit.dart';

class CustomSearchBar extends StatelessWidget {
  const CustomSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeCubit>().state.isDark;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRoutes.search);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        margin: EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: context.scheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: context.scheme.outline, width: 1),
          boxShadow: isDark? [ BoxShadow(
              color: context.scheme.shadow,
              blurRadius: 20, 
              offset: const Offset(0, -4),
            ),] : null
        ),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: context.scheme.onSurface,
              //or withValues(alpha: 0.7),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                "Search for new friends",
                style: context.textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
