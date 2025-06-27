import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wedding_hall_app/config/helpers/extensions.dart';
import 'package:wedding_hall_app/features/home/halls/view/screens/top_halls_screen.dart';

import '../../../../../../generated/l10n.dart';
import '../../../../../config/routes/routes_path.dart';
import '../../../halls/view/screens/halls_screen.dart';
import '../../../home_screen/view/screen/home_screen.dart';
import '../../../profile/view/profile_screen.dart';
import '../../../reservation/view/screens/user_reservation_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  final PageStorageBucket _bucket = PageStorageBucket();

  PageController pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: currentIndex == 0,
      onPopInvokedWithResult: (bool didPop, resualt) {
        if (!didPop && currentIndex != 0) {
          setState(() {
            currentIndex = 0;
            pageController.jumpToPage(0);
          });
        }
      },
      child: Scaffold(
        bottomNavigationBar: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0.w, vertical: 12.h),
          child: GNav(
            gap: 8.w,
            haptic: true,
            activeColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
            duration: const Duration(milliseconds: 200),
            tabActiveBorder: Border.all(),
            color: Colors.grey,
            tabs: [
              GButton(icon: Icons.home, text: "Home"),
              GButton(icon: Icons.shop, text: "Halls"),
              GButton(icon: Icons.category, text: "Reservations"),
              GButton(icon: Icons.person, text: "Profile"),
            ],
            selectedIndex: currentIndex,
            onTabChange: _onBottomNavTapped,
          ),
        ),
        appBar: AppBar(title: Text(screensTitle[currentIndex])),
        body: PageStorage(
          bucket: _bucket,
          child: PageView(
            controller: pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              currentIndex = index;
              setState(() {});
            },
            children: paddingScreens(),
          ),
        ),
      ),
    );
  }

  List<Widget> screens = [
    const HomeScreen(key: PageStorageKey('home')),
    const HallsScreen(key: PageStorageKey('halls')),
    const UserReservationScreen(key: PageStorageKey('reservation')),
    const ProfileScreen(),
  ];

  List<String> screensTitle = [
    "Wedding App",
    "Halls",
    "Reservations",
    "Profile"
  ];

  List<Widget> paddingScreens() {
    List<Widget> returnedList = [];
    for (Widget screen in screens) {
      returnedList.add(
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0.w, vertical: 8.0.h),
          child: screen,
        ),
      );
    }
    return returnedList;
  }

  void _onBottomNavTapped(int index) {
    if (index != currentIndex) {
      currentIndex = index;
      pageController.jumpToPage(index);
    }
  }
}
