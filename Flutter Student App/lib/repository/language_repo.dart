import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:opencentric_lms/data/provider/client_api.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  LanguageRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> language() async {
    return await apiClient.getData(AppConstants.language);
  }
}
