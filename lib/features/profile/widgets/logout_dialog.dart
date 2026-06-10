import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/cubit.dart';
import 'package:sync_communication_app/widgets/app_snackbar.dart';
import 'package:sync_communication_app/widgets/loading_overlay.dart';

class LogoutDialog extends StatelessWidget {
  const LogoutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          LoadingOverlay.instance.showLoadingOverlay(context);
        }
        if (state is AuthError) {
          LoadingOverlay.instance.hideLoadingOverlay(context);
          Navigator.of(context).pop();
          AppSnackBar.show(state.message);
        }
        if (state is AuthLogout) {
            LoggerService.logInfo("PresenceCubit state at logout: ${context.read<PresenceCubit>().state}");
          context.read<PresenceCubit>().deactivate();
          context.read<UserCubit>().clearUser();
          context.read<ZegoCubit>().unInitCall();
          LoadingOverlay.instance.hideLoadingOverlay(context);
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.getStarted,
            (route) => false,
          );
        }
      },
      child: AlertDialog(
        backgroundColor: context.circleAvatarColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Logout', style: context.textTheme.titleMedium),
        content: Text(
          'Are you sure you want to logout?',
          style: context.textTheme.headlineSmall,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: context.handleColor),
            ),
          ),
          TextButton(
            onPressed: () async{
              context.read<AuthCubit>().logout();
            },
            child: Text(
              'Logout',
              style: context.textTheme.bodyMedium!.copyWith(
                color: context.scheme.secondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
