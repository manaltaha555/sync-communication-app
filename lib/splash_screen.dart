import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'core/core.dart';
import 'cubit/cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _bootstrap();
    });
  }

  Future<void> _bootstrap() async {
    final userCubit = context.read<UserCubit>();
    final presenceCubit = context.read<PresenceCubit>();
    final zegoCubit = context.read<ZegoCubit>();

    // 1. Load user from Hive — this is the source of truth
    await userCubit.loadUser();

    final user = userCubit.state.user;
    final isLoggedIn = userCubit.state.isLoggedIn;

    // 2. If already logged in, activate presence + init calling
    if (isLoggedIn) {
      await presenceCubit.activate(user?.uid ?? '');
      await zegoCubit.initCall(
        userId: user!.uid,
        userName: user.username,
      );
    }

    // 3. Minimum splash visibility (UX)
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    LoggerService.logInfo(isLoggedIn ? 'User loaded: ${user?.uid}' : 'No user found');

    Navigator.pushReplacementNamed(
      context,
      isLoggedIn ? AppRoutes.mainNavigation : AppRoutes.getStarted,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: context.mainLinearGradient,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Shimmer.fromColors(
              baseColor: Colors.white54 ,
              highlightColor: Colors.white ,
              child: const Text(
                'Sync',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 56,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 200),

            SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: context.scheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}