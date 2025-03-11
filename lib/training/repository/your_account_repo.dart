

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:opencentric_lms/data/provider/client_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';

class YourAccountRepo {
  final ApiClient apiClient;
  YourAccountRepo({required this.apiClient});

  Future<Response?> getProgressReport() async {
    String uri = '/lms/user-courses';
    return await apiClient.getData(uri);
  }

  Future<Response?> getCourseProgress(String courseId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uid = sharedPreferences.getString(AppConstants.uid) ?? "";
    var body = {
      'user_id': uid,
      'course_id': courseId,
    };
    return apiClient.getData(AppConstants.courseProgress, body: body);
  }

  Future<Response?> getCertificates() async {
    final SharedPreferences sharedPreferences = await SharedPreferences
        .getInstance();
    final uid = sharedPreferences.getString(AppConstants.uid);
    final getCertificate = '/lms-get-certificates-by-user/$uid';
    return await apiClient.getData(getCertificate);
  }
}