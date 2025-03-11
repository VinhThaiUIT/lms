import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/config.dart';
import 'package:opencentric_lms/data/model/common/section.dart';
import 'package:opencentric_lms/data/model/course_detail/course_detail.dart';
import 'package:opencentric_lms/data/model/quiz/quiz_model.dart';
import 'package:opencentric_lms/repository/course_detail_repo.dart';
import 'package:share_plus/share_plus.dart';
import '../components/custom_snackbar.dart';
import '../data/model/common/course.dart';
import '../data/model/common/lesson.dart';
import '../data/model/user_review/review.dart';
import '../data/model/user_review/user_review.dart';
import '../feature/classRoom/widget/audio_player.dart';
import 'video_player_controller.dart';

class CourseDetailController extends GetxController implements GetxService {
  final CourseDetailsRepository courseDetailsRepository;
  CourseDetailController({required this.courseDetailsRepository});
  CourseDetail? _courseDetail;
  CourseDetail? get courseDetail => _courseDetail;
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
  bool? isHavePermissionCourse;
  bool? isHavePermissionLesson;

  // quiz lesson module
  List<QuizModel?>? _listQuizLessonModule;
  List<QuizModel?>? get listQuizLessonModule => _listQuizLessonModule;


  Course? course;
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

  updateRating(double value) {
    _rating = value;
    update();
  }

  _hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  void share(String path) {
    print(("${Config.baseUrl}${path.substring(1)}"));
    Share.share("${Config.baseUrl}${path.substring(1)}");
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
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => PopScope(
          canPop: false,
          child: MyAudioPlayer(
            lesson: lesson,
            courseID: courseDetail!.data.id!,
            sectionID: sectionID,
          )),
    );
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

  Future<void> getLesson(Course course) async {
    this.course = course;
    isLoadingLesson = true;
    course.listSections = [
      Section(
        id: 0,
        lessons: [],
        title: course.courseName,
      )
    ];
    update();
    final response = await courseDetailsRepository
        .getListLesson((course.id ?? 0).toString());
    // old path api
    // List list = response?.body["data"];
    // for (var i = 0; i < list.length; i++) {
    //   Lesson lesson = Lesson.fromJsonGetCourse(list[i]);
    //   course.listSections?[0].lessons?.add(lesson);
    // }
    // new path api
    if(response != null && response.statusCode == 200) {
      final data = response.body['data'];
      List<Lesson> lesson = List<Lesson>.from((data ).values.map((e) {
        return Lesson.fromJsonGetCourse(e);
      }));
      course.listSections?[0].lessons?.addAll(lesson);
    }
    final resCourseProgress = await courseDetailsRepository
        .getCourseProgress((course.id ?? 0).toString());
    if (resCourseProgress?.body['data'] != null) {
      if (resCourseProgress?.body['data']['lessons'] != null) {
        final mapRes =
            resCourseProgress?.body['data']['lessons'] as Map<String, dynamic>;
        mapRes.forEach((key, value) {
          course.listSections?[0].lessons
              ?.where((e) => e.id == int.parse(key))
              .forEach((element) {
            element.isCompleted = value == 'Fail' ? false : true;
          });
        });
      }
    }

    isLoadingLesson = false;
    isHavePermissionLesson = true;
    update();
  }

  lmsUpdateStatusLesson(String lessonId, String courseId) async {
    final res =
        await courseDetailsRepository.lmsUpdateStatusLesson(lessonId: lessonId);
    getLesson(course!);
  }
}
