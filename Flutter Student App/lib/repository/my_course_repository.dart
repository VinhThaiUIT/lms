import 'package:get/get_connect/http/src/response/response.dart';
import 'package:opencentric_lms/data/provider/client_api.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCourseRepository {
  final ApiClient apiClient;

  MyCourseRepository({required this.apiClient});

  Future<Response?> getMyCourseList() async {
    return await apiClient.getData(AppConstants.myCourse);
  }

  Future<Response?> getTeacherCourseList(String teacherUid) async {
    return await apiClient.getData(AppConstants.teacherCourse(teacherUid));
  }

  Future<Response?> getLesson(String id) async {
    return apiClient.getData(AppConstants.lesson(id));
  }

  Future<Response?> getListLesson(String courseId) async {
    return apiClient.getData(AppConstants.listLesson(courseId));
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
}
