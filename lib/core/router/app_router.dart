import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/router/app_routes.dart';
import 'package:sync_communication_app/cubit/cubit.dart';
import 'package:sync_communication_app/data/models/user_model.dart';
import 'package:sync_communication_app/features/authentication/presentation/get_started.dart';
import 'package:sync_communication_app/features/authentication/presentation/login_page.dart';
import 'package:sync_communication_app/features/authentication/presentation/signup_page.dart';
import 'package:sync_communication_app/features/chats/pages/chat_screen.dart';
import 'package:sync_communication_app/features/main%20navigation/presentation/pages/main_navigation.dart';
import 'package:sync_communication_app/features/search/pages/search_page.dart';
import 'package:sync_communication_app/splash_screen.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return slideTransition(const SplashScreen());

      case AppRoutes.getStarted:
        return slideTransition(const GetStarted());

      case AppRoutes.login:
        return slideTransition(
          BlocProvider(create: (context) => AuthCubit(), child: LoginPage()),
        );

      case AppRoutes.signup:
        return slideTransition(
          BlocProvider(create: (context) => AuthCubit(), child: SignupPage()),
        );

      case AppRoutes.mainNavigation:
        return slideTransition(
          MultiBlocProvider(
            providers: [BlocProvider(create: (context) => BottomNavBarCubit())],
            child: MainNavigation(),
          ),
        );
      case AppRoutes.chat:
        final args = settings.arguments as Map<String, dynamic>;
        return slideTransition(
          MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => MessagesCubit()),
              BlocProvider(create: (context) => CallsCubit()),
            ],
            child: ChatScreen(
              chatId: args['chatId'] as String,
              otherUser: args['otherUser'] as UserModel,
            ),
          ),
        );
      case AppRoutes.search:
        return slideTransition(
          BlocProvider(
            create: (context) => ChatListCubit(),
            child: SearchPage(),
          ),
        );

      default:
        return MaterialPageRoute(builder: (_) => const Scaffold());
    }
  }

  static PageRouteBuilder slideTransition(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      reverseTransitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, animation, secondaryAnimation) => page,
      transitionsBuilder: (_, animation, secondaryAnimation, child) {
        final tween = Tween<Offset>(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
