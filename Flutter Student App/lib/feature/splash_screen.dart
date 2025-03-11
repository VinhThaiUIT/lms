import 'dart:async';
import 'dart:core';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/controller/auth_controller.dart';
import 'package:opencentric_lms/controller/splash_controller.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';
import 'package:opencentric_lms/feature/myCourseOffline/my_course_offline_screen.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';

import 'landing/offline_landing_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  bool isNotConnected = false;
  Future<void> _initializeConnectivity() async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    setState(() {
      for (var i = 0; i < result.length; i++) {
        if (result[i] == ConnectivityResult.wifi ||
            result[i] == ConnectivityResult.mobile) {
          isNotConnected = false;
          break;
        } else {
          isNotConnected = true;
        }
      }
    });

    //if (isNotConnected) {
    _route(isNotConnected);
    //}
  }

  @override
  void initState() {
    super.initState();
    _initializeConnectivity();
    Get.find<SplashController>().initSharedData();

    // bool firstTime = true;
    // _onConnectivityChanged = Connectivity()
    //     .onConnectivityChanged
    //     .listen((ConnectivityResult result) {
    //   if (!firstTime) {
    //     setState(() {
    //       isNotConnected = result != ConnectivityResult.wifi &&
    //           result != ConnectivityResult.mobile;
    //     });
    //     isNotConnected
    //         ? const SizedBox()
    //         : ScaffoldMessenger.of(context).hideCurrentSnackBar();
    //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       backgroundColor: isNotConnected ? Colors.red : Colors.green,
    //       duration: Duration(seconds: isNotConnected ? 6000 : 3),
    //       content: Text(
    //         isNotConnected ? 'no_connection' : 'connected',
    //         textAlign: TextAlign.center,
    //       ),
    //     ));
    //     if (!isNotConnected) {
    //       _route(isNotConnected);
    //     }
    //   }
    //   firstTime = false;
    // });

    // _route(isNotConnected);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _route(bool isNotConnected) async {
    if (kDebugMode) {
      print('>>>:$isNotConnected');
    }
    if (!isNotConnected) {
      Get.find<SplashController>().getConfigData().then((value) {
        Timer(const Duration(seconds: 1), () async {
          if (Get.find<AuthController>().isLoggedIn()) {
            Get.offAllNamed(RouteHelper.getMainRoute(RouteHelper.splash));
          } else {
            // if (!Get.find<SplashController>().isSplashSeen()) {
            //   //Get.find<SplashController>().saveSplashSeenValue(true);
            Get.offAllNamed(RouteHelper.getSignInRoute("fromSplash"));
            //Get.offNamed(RouteHelper.getOnBoardingScreen());
            // } else {
            //   Get.offNamed(RouteHelper.getMainRoute(RouteHelper.splash));
            // }
          }
        });
      });
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => const MainOfflineScreen(pageIndex: 0)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    Images.splash,
                    colorFilter:
                        const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                    width: MediaQuery.of(context).size.width / 1.5,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SplashCustomPainter extends CustomPainter {
  final BuildContext? context;

  SplashCustomPainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    Paint leftCorner = Paint();
    leftCorner.color = Theme.of(context!).primaryColor.withOpacity(.3);
    Path path = Path();
    path.lineTo(0, 170);
    //Added this line
    path.relativeQuadraticBezierTo(100, -20, 110, -170);
    canvas.drawPath(path, leftCorner);
    Paint paint = Paint();

    // Path number 3
    paint.color = Theme.of(context!).primaryColor.withOpacity(.3);
    path = Path();
    path.lineTo(size.width, size.height / 3);
    path.cubicTo(size.width * 1.8, size.height * 0.5, size.width / 2,
        size.height, size.width / .99, size.height);
    path.cubicTo(size.width, 10, size.width, size.height / 10, size.width,
        size.height / 3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SplashCustomPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(SplashCustomPainter oldDelegate) => false;
}
