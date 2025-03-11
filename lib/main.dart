import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:opencentric_lms/network_service.dart';
import 'package:opencentric_lms/training/form_custom.dart';
import 'package:opencentric_lms/training/training_course_screen.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:opencentric_lms/utils/messages.dart';
import 'controller/localization_controller.dart';
import 'controller/splash_controller.dart';
import 'controller/theme_controller.dart';
import 'core/helper/route_helper.dart';
import 'core/initial_binding/initial_binding.dart';
import 'core/theme/dark_theme.dart';
import 'core/theme/light_theme.dart';
import 'core/helper/language_di.dart' as di;

HttpServer? server;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  await GetStorage.init();
  await dotenv.load(fileName: ".env");
  HttpOverrides.global = MyHttpOverrides();
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  WidgetsFlutterBinding.ensureInitialized();

  // await Firebase.initializeApp();
  Map<String, Map<String, String>> languages = await di.init();
  String? bookingID;
  // try {
  //   final RemoteMessage? remoteMessage =
  //       await FirebaseMessaging.instance.getInitialMessage();
  //   if (remoteMessage != null) {
  //     bookingID = remoteMessage.data['booking_id'];
  //   }
  //   await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
  //   FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  // } catch (e) {
  //   //
  // }
  NetworkService().initialize();

  Stripe.publishableKey = '${dotenv.env['STRIPE_PUBLIC_KEY']}';
  Stripe.merchantIdentifier = 'any string works';
  await Stripe.instance.applySettings();
  runApp(MyApp(languages: languages, bookingID: bookingID));
}



class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;
  final String? bookingID;
  const MyApp({super.key, @required this.languages, @required this.bookingID});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return GetMaterialApp(
            navigatorObservers: [routeObserver],
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            navigatorKey: Get.key,
            scrollBehavior: const MaterialScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch},
            ),
            initialBinding: InitialBinding(),
            theme: themeController.darkTheme ? dark : light,
            locale: localizeController.locale,
            translations: Messages(languages: widget.languages),
            fallbackLocale: Locale(AppConstants.languages[0].languageCode!,
                AppConstants.languages[0].countryCode),
            initialRoute: RouteHelper.getSplashRoute(),
            getPages: RouteHelper.routes,
            defaultTransition: Transition.topLevel,
            transitionDuration: const Duration(milliseconds: 500),
          );
        });
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
