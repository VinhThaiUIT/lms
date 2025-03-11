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
import 'package:opencentric_lms/training/training_course_screen.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:opencentric_lms/utils/styles.dart';

import 'offline_landing_screen.dart';

class MainScreen extends StatefulWidget {
  final int pageIndex;
  const MainScreen({super.key, required this.pageIndex});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _doubleBackToExitPressedOnce = false;
  PageController? _pageController;
  int _currentIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    _currentIndex = widget.pageIndex;
    _pageController = PageController(initialPage: widget.pageIndex);
    _screens = [
      HomeScreen(callback: () {
        setState(() {
          _pageController!.jumpToPage(2);
          _currentIndex = 2;
        });
      }),
      const ExploreScreen(),
      // const MyCourseScreen(),
      // training
      TrainingCourseScreen(callback: () => _setPage(0),),

      //
      const ProfileScreen(),
    ];
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          _setPage(0);
          return false;
        } else {
          if (_doubleBackToExitPressedOnce) {
            return true;
          }
          _doubleBackToExitPressedOnce = true;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('back_press_again_to_exit'.tr,
                style: const TextStyle(color: Colors.white)),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.amber,
            duration: const Duration(seconds: 2),
            margin: const EdgeInsets.all(Dimensions.paddingSizeSmall),
          ));
          // Reset the flag after 2 seconds
          Future.delayed(const Duration(seconds: 2), () {
            _doubleBackToExitPressedOnce = false;
          });

          return false;
        }
      },
      child: Scaffold(
        body: StreamBuilder<bool>(
            stream: NetworkService().networkStatusStream,
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data == false) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => MainOfflineScreen(pageIndex: 0)));
                });
                return const Center(
                  child: Text('You are no connected to the internet'),
                );
              } else {
                return PageView.builder(
                  controller: _pageController,
                  onPageChanged: _setPage,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return _screens[index];
                  },
                );
              }
            }),
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
              label: 'home'.tr,
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
              label: 'explore'.tr,
              backgroundColor: Theme.of(context).cardColor,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Images.myCourse,
                colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(.5),
                    BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                Images.myCourse,
                colorFilter: ColorFilter.mode(
                    Get.isDarkMode
                        ? Colors.green
                        : Theme.of(context).primaryColor,
                    BlendMode.srcIn),
              ),
              label: 'my_course'.tr,
              backgroundColor: Theme.of(context).cardColor,
            ),
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                Images.more,
                colorFilter: ColorFilter.mode(
                    Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(.5),
                    BlendMode.srcIn),
              ),
              activeIcon: SvgPicture.asset(
                Images.more,
                colorFilter: ColorFilter.mode(
                    Get.isDarkMode
                        ? Colors.green
                        : Theme.of(context).primaryColor,
                    BlendMode.srcIn),
              ),
              label: 'more'.tr,
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
