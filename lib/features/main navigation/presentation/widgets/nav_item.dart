import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/cubit.dart';

class NavItem extends StatefulWidget {
  final bool isActive;
  final VoidCallback onTap;
  final IconData icon;

  const NavItem({
    super.key,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<NavItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curved;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      value: widget.isActive ? 1.0 : 0.0, // start without animating
    );
    _curved = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didUpdateWidget(NavItem old) {
    super.didUpdateWidget(old);
    if (widget.isActive != old.isActive) {
      widget.isActive ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.read<ThemeCubit>().state.isDark;

    final inactiveDecoration = BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      color: Colors.transparent,
    );

    final activeDecoration = isDark
        ? BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: context.scheme.primary.withValues(alpha: .12),
            border: Border.all(
              color: context.scheme.primary.withValues(alpha: .20),
            ),
          )
        : BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: context.mainLinearGradient,
            boxShadow: [
              BoxShadow(
                color: context.scheme.primary.withValues(alpha: .15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          );

    final activeIconColor =
        isDark ? context.scheme.primary : Colors.white;
    final inactiveIconColor = context.scheme.onSurfaceVariant;

    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.translucent,
      child: AnimatedBuilder(
        animation: _curved,
        builder: (context, _) {
          final t = _curved.value;
          return Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            decoration: BoxDecoration.lerp(
                  inactiveDecoration,
                  activeDecoration,
                  t,
                ) ??
                const BoxDecoration(),
            child: Icon(
              widget.icon,
              size: 24,
              color: Color.lerp(inactiveIconColor, activeIconColor, t),
            ),
          );
        },
      ),
    );
  }
}