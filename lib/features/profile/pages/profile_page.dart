import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/cubit.dart';
import 'package:sync_communication_app/features/profile/widgets/logout_dialog.dart';
import 'package:sync_communication_app/features/profile/widgets/profile_icon_picker.dart';
import 'package:sync_communication_app/features/profile/widgets/profile_tile.dart';
import 'package:sync_communication_app/features/profile/widgets/section_card.dart';
import 'package:sync_communication_app/widgets/app_snackbar.dart';
import 'package:sync_communication_app/widgets/gradient_button.dart';
import 'package:sync_communication_app/widgets/gradient_switch.dart';
import 'package:sync_communication_app/widgets/loading_overlay.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final TextEditingController _usernameController;
  bool _isEditingUsername = false;
  String? errorMessage = "";

  @override
  void initState() {
    super.initState();
    final user = context.read<UserCubit>().state.user;
    _usernameController = TextEditingController(
      text: user?.username ?? 'Unknown',
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  void _saveUsername() {
    final trimmed = _usernameController.text.trim();

    if (trimmed.isEmpty) {
      setState(() => errorMessage = 'Username cannot be empty');
      return;
    }

    setState(() {
      _isEditingUsername = false;
      errorMessage = null;
    });

    context.read<UserCubit>().updateUsername(trimmed);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state.isUpdatingProfile && state.isLoading) {
          LoadingOverlay.instance.showLoadingOverlay(context);
        } else if (state.isSuccess && state.isUpdatingProfile) {
          LoadingOverlay.instance.hideLoadingOverlay(context);
          AppSnackBar.show('Username updated!');
        } else if (state.isFailure && state.isUpdatingProfile) {
          LoadingOverlay.instance.hideLoadingOverlay(context);
          AppSnackBar.show(state.errorMessage ?? 'Failed to update username');
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // const SizedBox(height: 16),

            // ── Avatar / Icon picker ──
            BlocSelector<UserCubit, UserState, String>(
              selector: (state) => state.user?.emoji ?? '🧑',
              builder: (context, emoji) =>
                  ProfileIconPicker(selectedIcon: emoji),
            ),

            const SizedBox(height: 64),

            // ── Username card ──
            SectionCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username', style: context.textTheme.labelMedium),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _isEditingUsername
                            ? TextFormField(
                                controller: _usernameController,
                                autofocus: true,
                                style: context.textTheme.titleMedium,
                                decoration: InputDecoration(
                                  isDense: true,
                                  errorText: errorMessage,
                                  contentPadding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                  filled: true,
                                  // fillColor: isDark
                                  //     ? Colors.white.withValues(alpha: 0.06)
                                  //     : Colors.black.withValues(alpha: 0.04),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                              )
                            : BlocSelector<UserCubit, UserState, String>(
                                selector: (state) =>
                                    state.user?.username ?? 'Unknown',
                                builder: (context, username) => Text(
                                  username,
                                  style: context.textTheme.titleMedium,
                                ),
                              ),
                      ),
                      const SizedBox(width: 8),
                      _isEditingUsername
                          ? Row(
                              children: [
                                IconButton(
                                  onPressed: () => setState(
                                    () => _isEditingUsername = false,
                                  ),
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: context.scheme.secondary,
                                    size: 20,
                                  ),
                                ),
                                IconButton(
                                  onPressed: _saveUsername,
                                  icon: Icon(
                                    Icons.check_rounded,
                                    color: context.scheme.tertiary,
                                    size: 20,
                                  ),
                                ),
                              ],
                            )
                          : IconButton(
                              onPressed: () =>
                                  setState(() => _isEditingUsername = true),
                              icon: Icon(
                                Icons.edit_rounded,
                                color: context.scheme.primary,
                                size: 20,
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Theme toggle card ──
            SectionCard(
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      context.isDark
                          ? Icons.dark_mode_rounded
                          : Icons.light_mode_rounded,
                      color: context.scheme.onPrimaryContainer,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Appearance', style: context.textTheme.titleMedium),
                        Text(
                          context.isDark ? 'Dark mode' : 'Light mode',
                          style: context.textTheme.labelSmall,
                        ),
                      ],
                    ),
                  ),
                  GradientSwitch(
                    value: context.isDark,
                    onChanged: (_) => context.read<ThemeCubit>().toggleTheme(),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Extra settings card ──
            SectionCard(
              child: Column(
                children: [
                  ProfileTile(
                    icon: Icons.notifications_rounded,
                    label: 'Notifications',
                    onTap: () {},
                  ),
                  Divider(
                    height: 1,
                    color: context.scheme.onSurface.withValues(alpha: 0.08),
                  ),
                  ProfileTile(
                    icon: Icons.lock_rounded,
                    label: 'Privacy',
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // const SizedBox(height: 32),

            // ── Logout button ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: GradientButton(
                onTap: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => BlocProvider(
                      create: (context) => AuthCubit(),
                      child: LogoutDialog(),
                    ),
                  );
                },
                text: "Logout",
              ),
            ),
            // const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
