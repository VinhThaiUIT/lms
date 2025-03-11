import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/data/model/common/section.dart';
import 'package:opencentric_lms/data/model/course_detail/course_detail.dart';
import 'package:opencentric_lms/repository/course_detail_repo.dart';
import 'package:path_provider/path_provider.dart';
import '../data/model/common/course.dart';
import '../data/model/common/lesson.dart';
import '../data/model/common/zoom_class_data.dart';
import '../data/model/user_review/review.dart';
import 'user_controller.dart';

class CourseDetailOfflineController extends GetxController
    implements GetxService {
  final CourseDetailsRepository courseDetailsRepository;
  CourseDetailOfflineController({required this.courseDetailsRepository});
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

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  Future<void> getLesson(Course course) async {
    isLoadingLesson = true;
    course.listSections = [
      Section(
        id: 0,
        lessons: [],
        title: "List lesson",
      )
    ];
    update();
    final uid = Get.find<UserController>().uid;
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String listLessonFolderPath =
        '${appDocDir.path}/$uid/courses/${course.lmsUserCourseId}/lessons/';
    final Directory listLessonDir = Directory(listLessonFolderPath);
    if (await listLessonDir.exists()) {
      final List<FileSystemEntity> entities = listLessonDir.listSync();
      for (var i = 0; i < entities.length; i++) {
        // get end path
        final lastPath = entities[i].path.split('/').last;
        if (int.tryParse(lastPath) is int) {
          final lessonFolderPath = entities[i].path;
          final jsonFile = File('$lessonFolderPath/jsonLesson.json');
          final data = await jsonFile.readAsString();
          final jsonCourse = json.decode(data);
          Lesson lesson = Lesson.fromJsonGetCourse(jsonCourse);
          String urlVideo = "";
          if (jsonCourse['field_video_url'] != null &&
              jsonCourse['field_video_url'].isNotEmpty) {
            urlVideo = jsonCourse['field_video_url'][0]["value"] ?? "";
            final file = File('$lessonFolderPath/video.mp4');
            if (await file.exists()) {
              urlVideo = file.path;
            }
          }
          lesson.urlVideo = urlVideo;
          lesson.lessonFolderPath = lessonFolderPath;
          course.listSections?[0].lessons?.add(lesson);
        }
      }
    }

    isLoadingLesson = false;
    update();
  }
}
