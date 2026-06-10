import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';

class SearchInputTextField extends StatelessWidget {
  const SearchInputTextField({
    super.key,
    required this.controller,
    required this.onChanged,
  });
  final TextEditingController controller;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: context.textTheme.labelSmall,
      decoration: InputDecoration(
        hintText: "Search for chats or new friends",
        hintStyle: context.textTheme.labelSmall,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(
                  Icons.clear,
                  color: context.scheme.onSurfaceVariant,
                ),
                onPressed: () => controller.clear(),
              )
            : null,
        prefixIcon: Icon(
          Icons.search,
          color: context.scheme.onSurfaceVariant,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: context.scheme.outline,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(
            color: context.scheme.outline,
            width: 1,
          ),
        ),
        filled: true,
      // fillColor:AppDarkColors.cardBackground,
      ),
    );
  }
}
        // color: isDark
        //     ? Colors.white.withValues(alpha: 0.05)
        //     : Colors.white.withValues(alpha: 0.85),
        // borderRadius: BorderRadius.circular(20),
        // border: Border.all(
        //   color: isDark
        //       ? Colors.white.withValues(alpha: 0.08)
        //       : Colors.black.withValues(alpha: 0.06),
        // ),
