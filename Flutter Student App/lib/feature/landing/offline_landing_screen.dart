import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/feature/explore/explore_screen.dart';
import 'package:opencentric_lms/feature/home/home_screen.dart';
import 'package:opencentric_lms/feature/menu/menu_screen.dart';
import 'package:opencentric_lms/feature/myCourse/my_course_screen.dart';
import 'package:opencentric_lms/feature/myCourseOffline/my_course_offline_screen.dart';
import 'package:opencentric_lms/feature/profile/profile_screen.dart';
import 'package:opencentric_lms/network_service.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:opencentric_lms/utils/styles.dart';

import '../forum/forum_offline_screen.dart';

class MainOfflineScreen extends StatefulWidget {
  final int pageIndex;
  const MainOfflineScreen({super.key, required this.pageIndex});

  @override
  State<MainOfflineScreen> createState() => _MainOfflineScreenState();
}

class _MainOfflineScreenState extends State<MainOfflineScreen> {
  bool _doubleBackToExitPressedOnce = false;
  PageController? _pageController;
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    _currentIndex = widget.pageIndex;

    _pageController = PageController(initialPage: widget.pageIndex);

    _screens = [
      MyCourseOfflineScreen(),
      ForumOfflineScreen(),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: PageView.builder(
          controller: _pageController,
          onPageChanged: _setPage,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return _screens[index];
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: 12,
          selectedLabelStyle: robotoMedium.copyWith(
            fontSize: Dimensions.fontSizeSmall,
            color:
                Get.isDarkMode ? Colors.green : Theme.of(context).primaryColor,
          ),
          unselectedItemColor:
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(.5),
          selectedItemColor:
              Get.isDarkMode ? Colors.green : Theme.of(context).primaryColor,
          unselectedLabelStyle: robotoMedium.copyWith(
              fontSize: Dimensions.fontSizeSmall,
              color: Theme.of(context).textTheme.bodyLarge!.color),
          elevation: 5.0,
          showSelectedLabels: true,
          showUnselectedLabels: true,
          onTap: (index) => _setPage(index),
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Images.home,
                colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(.5),
                    BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                Images.home,
                colorFilter: ColorFilter.mode(
                    Get.isDarkMode
                        ? Colors.green
                        : Theme.of(context).primaryColor,
                    BlendMode.srcIn),
              ),
              label: 'Course'.tr,
              backgroundColor: Theme.of(context).cardColor,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Images.explore,
                colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(.5),
                    BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                Images.explore,
                colorFilter: ColorFilter.mode(
                    Get.isDarkMode
                        ? Colors.green
                        : Theme.of(context).primaryColor,
                    BlendMode.srcIn),
              ),
              label: 'Forum'.tr,
              backgroundColor: Theme.of(context).cardColor,
            ),
          ],
        ),
      ),
    );
  }

  void _setPage(int pageIndex) {
    if (pageIndex == 3) {
      Get.bottomSheet(const MenuScreen(),
          backgroundColor: Colors.transparent, isScrollControlled: true);
    } else {
      setState(() {
        _pageController!.jumpToPage(pageIndex);
        _currentIndex = pageIndex;
      });
    }
  }
}
