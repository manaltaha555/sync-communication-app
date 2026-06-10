import 'package:flutter/material.dart';
import 'package:sync_communication_app/app_initializer.dart';
import 'package:sync_communication_app/features/main%20navigation/presentation/pages/main_navigation.dart';
import 'package:sync_communication_app/splash_screen.dart';
import 'core/core.dart';
import 'cubit/cubit.dart';

void main() async {
  await InitializeApp.initialize();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PresenceCubit()),
        BlocProvider(
 create: (context) => ThemeCubit()..loadFromBox(),          //* the initial value should be the value of the local database and if there isn't then it will be  the default value of the device
        ),
        BlocProvider(create: (context) => UserCubit()),
        BlocProvider(create: (context) => ZegoCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final presenceCubit = context.read<PresenceCubit>();

    switch (state) {
      case AppLifecycleState.resumed:
        presenceCubit.onResumed();
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        presenceCubit.onPaused();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    context.read<PresenceCubit>().deactivate();
    super.dispose();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ThemeCubit, ThemeState>(
      listener: (context, state) {
        MainNavigationController.instance.navigateTo(
          0,
        ); // reset to home on theme change
      },
      builder: (context, state) {
        return MaterialApp(
          title: 'Sync',
          navigatorKey: AppKey.navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: state.isDark
              ? AppDarkTheme.darkTheme
              : AppLightTheme.lightheme,
          home: const SplashScreen(),
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: AppRoutes.splash,
        );
      },
    );
  }
}
