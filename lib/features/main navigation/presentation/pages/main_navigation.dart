import 'package:flutter/material.dart';
import 'package:sync_communication_app/core/core.dart';
import 'package:sync_communication_app/cubit/cubit.dart';
import 'package:sync_communication_app/features/calls/calls_page.dart';
import 'package:sync_communication_app/features/home/presentation/pages/home_page.dart';
import 'package:sync_communication_app/features/main%20navigation/presentation/widgets/nav_item.dart';
import 'package:sync_communication_app/features/profile/pages/profile_page.dart';
import 'package:sync_communication_app/widgets/gradient_background.dart';

class MainNavigationController {
  static final MainNavigationController instance = MainNavigationController._();

  MainNavigationController._();

  late PageController _pageController;
  late BottomNavBarCubit _cubit;

  void init({
    required PageController pageController,
    required BottomNavBarCubit cubit,
  }) {
    _pageController = pageController;
    _cubit = cubit;
  }

  void navigateTo(int index) {
    _cubit.updateIndex(index);

    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, this.initIndex});

  final int? initIndex;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation>
    with WidgetsBindingObserver {
  late final PageController pageController;

  @override
  void initState() {
    super.initState();

    pageController = PageController(
      initialPage: context.read<BottomNavBarCubit>().state,
    );

    MainNavigationController.instance.init(
      pageController: pageController,
      cubit: context.read<BottomNavBarCubit>(),
    );
  }

  @override
  void dispose() {
    pageController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pageList = [
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => ActiveCubit()),
          BlocProvider(create: (context) => ChatListCubit()),
        ],
        child: const HomePage(),
      ),
      BlocProvider(create: (context) => CallsCubit(), child: CallsPage()),
      ProfilePage(),
    ];

    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        return GradientBackground(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: BlocBuilder<BottomNavBarCubit, int>(
            builder: (context, navState) {
              final double systemBottomPadding = MediaQuery.of(
                context,
              ).viewPadding.bottom;
              final width = MediaQuery.of(context).size.width;
              return Padding(
                padding: EdgeInsets.only(
                  left: width * 0.2,
                  right: width * 0.2,
                  top: 12,
                  bottom: systemBottomPadding > 0
                      ? systemBottomPadding + 12
                      : 12,
                ),
                child: Container(
                  // width: MediaQuery.of(context).size.width * 0.5,
                  // padding: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),

                    gradient: context.navBarGradient,
                    border: Border.all(
                      color: context.scheme.outline,
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      NavItem(
                        icon: Icons.home_rounded,
                        isActive: navState == 0,
                        onTap: () =>
                            MainNavigationController.instance.navigateTo(0),
                      ),
                      NavItem(
                        icon: Icons.call_rounded,
                        isActive: navState == 1,
                        onTap: () =>
                            MainNavigationController.instance.navigateTo(1),
                      ),
                      NavItem(
                        icon: Icons.person_outline_rounded,
                        isActive: navState == 2,
                        onTap: () =>
                            MainNavigationController.instance.navigateTo(2),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          child: PageView.builder(
            controller: pageController,
            itemCount: pageList.length,
            onPageChanged: (index) {
              context.read<BottomNavBarCubit>().updateIndex(index);
            },
            itemBuilder: (context, index) => pageList[index],
          ),
        );
      },
    );
  }
}
