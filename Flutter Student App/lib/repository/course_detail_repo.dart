import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/provider/client_api.dart';
import '../utils/app_constants.dart';

class CourseDetailsRepository {
  final ApiClient apiClient;
  CourseDetailsRepository({required this.apiClient});

  Future<Response?> getReviews(int id, int pageNumber) async {
    return apiClient
        .getData("${AppConstants.reviews}?id=$id&type=course&page=$pageNumber");
  }

  Future<Response?> getLesson(String id) async {
    return apiClient.getData(AppConstants.lesson(id));
  }

  // Future<Response?> getListLesson(String courseId) async {
  //   return apiClient.getData(AppConstants.listLesson(courseId));
  // }
  Future<Response?> getListLesson(String courseId) async {
    return apiClient.getData(AppConstants.listLessonModule(courseId));
  }

  Future<Response?> getCourseDetail(String courseId) async {
    return apiClient.getData(AppConstants.courseDetail(courseId));
  }

  Future<Response?> addCourse(String courseId, String userId) async {
    var body = {
      "course_id": courseId,
      "user_id": userId,
    };
    return await apiClient.postData(
      AppConstants.addCourse,
      body,
    );
  }

  Future<Response?> postReview(
      {required int id, required String review, required double rating}) async {
    var body = {
      'id': id,
      'type': 'course',
      'rating': '$rating',
      'comment': review
    };
    return apiClient.postData(AppConstants.writeReviews, body);
  }

  Future<Response?> lmsCheckCoursePayment({required String productId}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uid = sharedPreferences.getString(AppConstants.uid) ?? "";
    var body = {'user_id': uid, 'product_id': productId};
    return apiClient.getData(AppConstants.lmsCheckCoursePayment, body: body);
  }

  Future<Response?> lmsCheckPermission(
      {String? courseId, String? lessonId, String? quizId}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uid = sharedPreferences.getString(AppConstants.uid) ?? "";
    var body = {'user_id': uid};
    if (courseId != null) {
      body['course_id'] = courseId;
      body['type'] = 'check_course_permission';
    }
    if (lessonId != null) {
      body['lesson_id'] = lessonId;
      body['type'] = 'check_lesson_permission';
    }
    if (quizId != null) {
      body['quiz_id'] = quizId;
      body['type'] = 'check_quiz_permission';
    }
    return apiClient.postData(AppConstants.lmsCheckPermission, body);
  }

  Future<Response?> lmsUserCourseCheck(String courseId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uid = sharedPreferences.getString(AppConstants.uid) ?? "";
    var body = {
      'user_id': uid,
      'course_id': courseId,
    };

    return apiClient.postData(AppConstants.lmsUserCourseCheck, body);
  }

  Future<Response?> startCourse(String productId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uid = sharedPreferences.getString(AppConstants.uid) ?? "";
    var body = {"product_id": productId, "user_id": uid};
    return apiClient.postData(AppConstants.lmsStartCourse, body);
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

  Future<Response?> lmsUpdateStatusLesson({required String lessonId}) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uid = sharedPreferences.getString(AppConstants.uid) ?? "";
    var body = {
      'user_id': uid,
      'lesson_id': lessonId,
    };
    return apiClient.postData(AppConstants.lmsUpdateStatusLesson, body);
  }
}
