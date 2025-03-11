import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/config.dart';
import 'package:opencentric_lms/controller/user_controller.dart';
import 'package:opencentric_lms/data/model/common/section.dart';
import 'package:opencentric_lms/repository/course_detail_repo.dart';

import 'package:share_plus/share_plus.dart';
import '../components/custom_snackbar.dart';
import '../data/model/common/course.dart';
import '../data/model/common/lesson.dart';
import '../data/model/user_review/review.dart';
import '../data/model/user_review/user_review.dart';
import 'video_player_controller.dart';

class CourseDetailNotPurchaseController extends GetxController
    implements GetxService {
  final CourseDetailsRepository courseDetailsRepository;
  CourseDetailNotPurchaseController({required this.courseDetailsRepository});
  Course? _course;
  Course? get course => _course;
  bool isLoading = false;
  bool isLoadingLesson = true;
  ScrollController scrollController = ScrollController();
  bool isBottomNavVisible = true;

  int pageNumber = 1;
  List<Review> reviews = [];
  bool isLoadingReviewsMore = false;
  bool hasMoreReviewData = true;

  //for video player
  String? selectedVideoUrl;
  bool playNewVideo = false;

  //rating
  final reviewTextController = TextEditingController();
  double _rating = 0.0;
  bool isReviewPosting = false;
  bool isBought = false;
  bool? isHavePermissionCourse;
  bool? isHavePermissionLesson;
  bool? isStartCourse;
  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(() {
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        //scroll down
        if (isBottomNavVisible) {
          isBottomNavVisible = false;
          update();
        }
      }
      if (scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        //scrolling up
        if (!isBottomNavVisible) {
          isBottomNavVisible = true;
          update();
        }
      }
    });
  }

  Future<void> checkStartCourse(String courseId) async {
    final res = await CourseDetailsRepository(apiClient: Get.find())
        .lmsUserCourseCheck(courseId);
    if (res?.body["data"] is List) {
      isStartCourse = false;
    } else {
      isStartCourse = true;
    }
    update();
  }

  Future<void> checkCoursePermission(String courseId) async {
    final res = await CourseDetailsRepository(apiClient: Get.find())
        .lmsCheckPermission(courseId: courseId);

    isHavePermissionCourse = res?.body["result"] ?? false;
    update();
  }

  Future<void> checkLessonPermission(String lessonId) async {
    final res = await CourseDetailsRepository(apiClient: Get.find())
        .lmsCheckPermission(lessonId: lessonId);

    isHavePermissionLesson = res?.body["result"] ?? false;
    update();
  }

  Future<void> checkQuizPermission(String quizId) async {
    final res = await CourseDetailsRepository(apiClient: Get.find())
        .lmsCheckPermission(quizId: quizId);
    update();
  }

  updateRating(double value) {
    _rating = value;
    update();
  }

  _hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  void lmsCheckCoursePayment(String productId) async {
    final response = await CourseDetailsRepository(apiClient: Get.find())
        .lmsCheckCoursePayment(productId: productId);
    isBought = response?.body["course_permission"] ?? false;
    update();
  }

  Future<void> startCourse(String productId) async {
    await CourseDetailsRepository(apiClient: Get.find()).startCourse(productId);

    update();
  }

  void share() {
    Share.share(Config.baseUrl.replaceAll('api', 'course'));
  }

  void updateVideoUrl(bool fromCourseDetails, String url, int id,
      String lessonId, String sectionId) async {
    selectedVideoUrl = url;
    playNewVideo = true;
    Get.put(MyVideoPlayerController()).playVideo(url);
    update();
  }

  void stopVideoPlayer() async {
    selectedVideoUrl = null;
    await Get.put(MyVideoPlayerController()).stopPlayer();
    update();
  }

  void openAudioPlayerDialog(Lesson lesson, String sectionID) {
    if (lesson.link.isEmpty) {
      customSnackBar('audio_file_error'.tr, isError: true);
      return;
    }
    stopVideoPlayer();
  }

  @override
  void dispose() {
    selectedVideoUrl = null;
    scrollController.dispose();
    super.dispose();
  }

  bool isSelect = false;
  curriculumButton() {
    isSelect = !isSelect;
    update();
  }

  Future<void> getReviews(int id) async {
    reviews = [];
    final response = await CourseDetailsRepository(apiClient: Get.find())
        .getReviews(id, pageNumber);
    if (response != null && response.statusCode == 200) {
      if (response.body['success'] == true) {
        UserReview review = UserReview.fromJson(response.body);
        reviews.addAll(review.data!.reviews!);
        if (review.data!.reviews!.isNotEmpty) {
          pageNumber++;
        } else {
          hasMoreReviewData = false;
        }
      }
    }
    update();
  }

  Future<void> postReview({required int id}) async {
    _hideKeyboard();
    isReviewPosting = true;
    update();
    String review = reviewTextController.text.isNotEmpty
        ? reviewTextController.text.toString()
        : "";

    final response = await courseDetailsRepository.postReview(
        id: id, review: review, rating: _rating);
    if (response != null) {
      reviewTextController.clear();
      Get.back();
      if (response.statusCode == 200) {
        customSnackBar(response.body['message'], isError: false);
      } else {
        customSnackBar(response.body['message'], isError: true);
      }
    }
    pageNumber = 0;
    getReviews(id);
    isReviewPosting = !isReviewPosting;
    update();
  }

  Future<void> paginateReviews(int id) async {
    isLoadingReviewsMore == true;
    update();
    await getReviews(id);
    isLoadingReviewsMore == false;
    update();
  }

  Future<void> getCourseDetail(String courseId) async {
    isLoading = true;
    update();

    // Make both API calls simultaneously
    final responses = await Future.wait([
      courseDetailsRepository.getListLesson(courseId),
      courseDetailsRepository.getCourseDetail(courseId),
    ]);

    // Process the responses
    final listResponse = responses[0];
    final detailResponse = responses[1];

    // List list = listResponse?.body["data"];
    // List<Lesson> lessons = [];

    // for (var i = 0; i < list.length; i++) {
    //   Lesson lesson = Lesson.fromJsonGetCourse(list[i]);
    //   lessons.add(lesson);
    // }
    final data = listResponse?.body["data"];
    if (kDebugMode) {
      print(data);
    }

    List<Lesson> lessons = List<Lesson>.from((data ).values.map((e) {
      return Lesson.fromJsonGetCourse(e);
    }));

    _course = Course.fromJsonCourseDetail(detailResponse?.body);

    getLesson(_course!, lessons);

    isLoading = false;
    update();
  }

  Future<void> addCourse(String courseId) async {
    isLoading = true;
    update();
    final uid = Get.find<UserController>().uid;
    final res = await courseDetailsRepository.addCourse(courseId, uid);
    if (res?.statusCode == 200) {
      customSnackBar('Add course successfully'.tr, isError: false);
    } else {
      customSnackBar('Have error on add course'.tr, isError: true);
    }
    isLoading = false;
    update();
  }

  Future<void> getLesson(Course course, List<Lesson> listLesson) async {
    isLoadingLesson = true;
    course.listSections = [
      Section(
        id: 0,
        lessons: [],
        title: course.courseName,
      )
    ];
    course.listSections?[0].lessons?.addAll(listLesson);
    update();

    isLoadingLesson = false;
    update();
  }
}
