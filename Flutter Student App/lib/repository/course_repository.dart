import 'package:get/get_connect/http/src/response/response.dart';
import 'package:opencentric_lms/data/provider/client_api.dart';
import 'package:opencentric_lms/utils/app_constants.dart';

class CourseRepository {
  final ApiClient apiClient;
  CourseRepository(this.apiClient);

  Future<Response?> getCategoryBasedCourseList(String courseID) async {
    return apiClient.getData("${AppConstants.categoryCourses}/$courseID");
  }

  // Future<Response?> getListLesson({int limit = 10, int offset = 1}) async {
  //   return apiClient
  //       .getData(AppConstants.listLesson(limit.toString(), offset.toString()));
  // }
}
