import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/config.dart';
import 'package:opencentric_lms/controller/auth_controller.dart';
import 'package:opencentric_lms/controller/localization_controller.dart';
import 'package:opencentric_lms/controller/splash_controller.dart';
import 'package:opencentric_lms/controller/theme_controller.dart';
import 'package:opencentric_lms/controller/user_controller.dart';
import 'package:opencentric_lms/data/model/response/language_model.dart';
import 'package:opencentric_lms/data/provider/client_api.dart';
import 'package:opencentric_lms/repository/auth_repo.dart';
import 'package:opencentric_lms/repository/splash_repo.dart';
import 'package:opencentric_lms/repository/user_repo.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, Map<String, String>>> init() async {
  //those binding are used before called GetMaterial app
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.lazyPut(() => sharedPreferences);
  Get.lazyPut(() =>
      ApiClient(appBaseUrl: Config.baseUrl, sharedPreferences: Get.find()));
  Get.lazyPut(() => SplashController(
      splashRepo:
          SplashRepo(apiClient: Get.find(), sharedPreferences: Get.find())));
  Get.lazyPut(() => LocalizationController(
      sharedPreferences: Get.find(), apiClient: Get.find()));
  Get.lazyPut(() => ThemeController(sharedPreferences: Get.find()));
  Get.lazyPut(() => AuthController(
      authRepo:
          AuthRepo(sharedPreferences: Get.find(), apiClient: Get.find())));
  Get.lazyPut(() => UserController(
          userRepo: UserRepo(
        sharedPreferences: Get.find(),
        apiClient: Get.find(),
      )));

  // Retrieving localized data
  Map<String, Map<String, String>> languages = {};
  for (LanguageModel languageModel in AppConstants.languages) {
    String jsonStringValues = await rootBundle
        .loadString('assets/languages/${languageModel.languageCode}.json');
    Map<String, dynamic> mappedJson = jsonDecode(jsonStringValues);
    Map<String, String> json = {};
    mappedJson.forEach((key, value) {
      json[key] = value.toString();
    });
    languages['${languageModel.languageCode}_${languageModel.countryCode}'] =
        json;
  }
  return languages;
}
