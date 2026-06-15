import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/cubit.dart';
import 'package:sync_communication_app/data/models/user_model.dart';
import 'package:sync_communication_app/widgets/app_snackbar.dart';
import 'package:sync_communication_app/widgets/gradient_button.dart';
import 'package:sync_communication_app/widgets/loading_overlay.dart';

class IconPickerSheet extends StatefulWidget {
  IconPickerSheet({super.key});

  final List<String> icons = [
    '🧑',
    '👽',
    '👻',
    '🧑‍💻',
    '🧑‍🎨',
    '🕵🏽‍♀️',
    '🥼',
    '💪🏽',
    '🦊',
    '🐺',
    '🐱',
    '🐸',
    '🐼',
    '🦋',
    '🤑',
    '😜',
    '🥰',
    '😴',
    '🤭',
    '😎',
    '🤔',
    '🤡',
    '🔥',
    '✨',
    '🌙',
    '🌊',
    '🎮',
    '🎵',
    '✈️',
    '🚀'
  ];

  @override
  State<IconPickerSheet> createState() => _IconPickerSheetState();
}

class _IconPickerSheetState extends State<IconPickerSheet> {
  late String selectedEmoji;
  late UserModel? user;
  @override
  void initState() {
    super.initState();
    user = context.read<UserCubit>().state.user;
    selectedEmoji = user != null ? user!.emoji ?? "🧑" : "🧑";
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        if (state.isUploadingEmoji && state.isLoading) {
          LoadingOverlay.instance.showLoadingOverlay(context);
        }
        if (state.isFailure && state.isUploadingEmoji) {
          LoadingOverlay.instance.hideLoadingOverlay(context);
          AppSnackBar.show(state.errorMessage ?? 'Failed to update profile');
        } else if (state.isSuccess && state.isUploadingEmoji) {
          LoadingOverlay.instance.hideLoadingOverlay(context);
          Navigator.pop(context);
          AppSnackBar.show('Profile updated!');
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: context.scheme.scrim,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          border: Border.all(color: context.cellBorder),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Handle ──
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.handleColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            const SizedBox(height: 20),

            // ── Title row ──
            Text('Choose your icon', style: context.textTheme.headlineMedium),

            const SizedBox(height: 20),

            // ── Live preview ──
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: context.mainLinearGradient,
                boxShadow: [context.profilePickerShadow],
              ),
              child: Center(
                child: Text(
                  selectedEmoji,
                  style: const TextStyle(fontSize: 38),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Emoji grid ──
            GridView.builder(
              shrinkWrap: true,
              // physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.icons.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final emoji = widget.icons[index];
                final isSelected = emoji == selectedEmoji;

                return GestureDetector(
                  onTap: () => setState(() => selectedEmoji = emoji),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      gradient: isSelected ? context.mainLinearGradient : null,
                      color: isSelected ? null : context.cellBg,
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : context.cellBorder,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: TextStyle(fontSize: isSelected ? 26 : 24),
                      ),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            GradientButton(
              onTap: () {
                context.read<UserCubit>().updateEmoji(selectedEmoji);
              },
              text: 'Select  $selectedEmoji',
            ),
          ],
        ),
      ),
    );
  }
}
