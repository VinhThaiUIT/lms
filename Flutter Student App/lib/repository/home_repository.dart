import 'package:get/get.dart';
import 'package:opencentric_lms/controller/splash_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/provider/client_api.dart';
import '../utils/app_constants.dart';

class HomeRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  HomeRepository({required this.apiClient, required this.sharedPreferences});

  Future<Response?> getHomeData() async {
    return apiClient.getData(AppConstants.homeScreen);
  }

  Future<Response?> getLatestCourse(int page) async {
    final appConfig = Get.find<SplashController>()
        .configModel
        .data!
        .appConfig
        .defaultCurrency;
    return apiClient
        .getData("${AppConstants.latestCourse}?page=$page&currency=$appConfig");
  }

  Future<Response?> getCourseNotPurchase(String uid) async {
    return apiClient.getData(AppConstants.lmsCourse);
  }

  String getUserUid() {
    return sharedPreferences.getString(AppConstants.uid) ?? "";
  }
}
