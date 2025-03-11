import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/controller/auth_controller.dart';
import 'package:opencentric_lms/core/helper/help_me.dart';
import 'package:opencentric_lms/data/model/classroom/classroom/classroom.dart';
import 'package:opencentric_lms/feature/classRoom/widget/audio_player.dart';
import 'package:opencentric_lms/repository/classroom_repo.dart';
import 'package:opencentric_lms/repository/course_progress_repository.dart';
import '../data/model/common/lesson.dart';
import '../data/model/common/section.dart';
import 'video_player_controller.dart';

class ClassroomController extends GetxController implements GetxService {
  bool isLoading = false;
  Classroom? _classRoomData;
  Classroom? get classroomData => _classRoomData;
  final List<Section> _sectionList = [];
  List<Section> get sectionList => _sectionList;

  String? selectedVideoUrl;
  bool playNewVideo = false;

  void updateVideoUrl({
    required String url,
    required int courseID,
    required String lessonId,
    required String sectionId,
  }) async {
    selectedVideoUrl = url;
    playNewVideo = true;
    Get.put(MyVideoPlayerController()).playVideo(url);
    update();
  }

  void stopVideoPlayer() async {
    await Get.put(MyVideoPlayerController()).stopPlayer();
    update();
  }

  void openAudioPlayerDialog(Lesson lesson, int courseID, String sectionID) {
    stopVideoPlayer();
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => PopScope(
          canPop: false,
          child: MyAudioPlayer(
            lesson: lesson,
            courseID: courseID,
            sectionID: sectionID,
          )),
    );
  }

  @override
  void dispose() {
    selectedVideoUrl = null;
    super.dispose();
  }

  Future<void> getCourseSectionData({required int courseID}) async {
    printLog(";-------section id: $courseID");
    isLoading = true;
    selectedVideoUrl = null;
    update();
    final response =
        await ClassroomRepo(Get.find()).getClassroomData(courseID: courseID);
    if (response != null && response.statusCode == 200) {
      Classroom data = Classroom.fromJson(response.body);
      _classRoomData = data;
      _sectionList.clear();
      _sectionList.addAll(data.data!.sections!.map((e) => e));
    }
    isLoading = false;
    update();
  }

  Future<void> saveCourseProgress(int id, String lessonID, String sectionID,
      String totalSpentTime, String totalDuration) async {
    // print("Check: $lessonID, $sectionID, $totalSpentTime, $totalDuration");
    if (Get.find<AuthController>().isLoggedIn()) {
      final response = await CourseProgressRepository(Get.find()).saveProgress(
          id: id,
          lessonID: lessonID,
          sectionID: sectionID,
          totalSpentTime: totalSpentTime,
          totalDuration: totalDuration);
      if (response != null) {
        // customSnackBar(response.body['message'],
        //     isError: response.statusCode != 200);
      }
      Get.find<MyVideoPlayerController>().saveProgressCalled = true;
      update();
    }
  }
}
