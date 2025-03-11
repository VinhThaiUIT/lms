import 'dart:convert';
import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/controller/user_controller.dart';
import 'package:opencentric_lms/repository/my_course_repository.dart';
import 'package:opencentric_lms/training/controller/your_account_controller.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;

import '../data/model/common/lesson.dart';
import '../data/model/common/lms_my_course.dart';

class MyCourseController extends GetxController implements GetxService {
  final MyCourseRepository repository;
  MyCourseController({required this.repository});

  final List<LMSMyCourseModel> _myCourseList = [];
  List<LMSMyCourseModel> get myCourseList => _myCourseList;
  bool _isMyCourseDataLoading = false;
  bool get isMyCourseLoading => _isMyCourseDataLoading;
  final bool _isMyCourseLoadingMore = false;
  bool get isMyCourseLoadingMore => _isMyCourseLoadingMore;

  String _status = "";
  String get statusDownload => _status;

  Map<String, double> progressCourse = {};

  Future<void> getProgressCourse(myCourse) async{
    final listProgress = Get.find<YourAccountController>().listCourseReport;
    if(listProgress.isEmpty) {
      Get.find<YourAccountController>().getProgressReport();
    }
    // for(int i=0; i<listProgress.length; i++){
    //   if
    //   // final listLesson = repository.getListLesson(listProgress?[i].id);
    // }


  }


  Future<void> getMyCourseList() async {
    _isMyCourseDataLoading = true;
    // update();
    final user = Get.find<UserController>().userData;

    if (user != null) {
      if (user.roles == AppConstants.teacher) {
        // teacher
        final response =
            await repository.getTeacherCourseList(user.uid.toString());
        if (response != null && response.statusCode == 200) {
          List list = response.body["data"];
          List<LMSMyCourseModel> listCourse = List.generate(list.length,
              (index) => LMSMyCourseModel.fromJsonTeacherCourse(list[index]));

          _myCourseList.clear();
          _myCourseList.addAll(listCourse);
        }
      } else {
        // student
        final response = await repository.getMyCourseList();
        if (response != null && response.statusCode == 200) {
          print(response.body);
          List list = response.body;
          List<LMSMyCourseModel> listCourse = List.generate(
              list.length, (index) => LMSMyCourseModel.fromJson(list[index]));



          _myCourseList.clear();
          _myCourseList.addAll(listCourse);

        }
      }
      update();
      _isMyCourseDataLoading = false;
    } else {
      final response = await repository.getTeacherCourseList(4.toString());
      if (response != null && response.statusCode == 200) {
        List list = response.body["data"];
        List<LMSMyCourseModel> listCourse = List.generate(list.length,
            (index) => LMSMyCourseModel.fromJsonTeacherCourse(list[index]));

        _myCourseList.clear();
        _myCourseList.addAll(listCourse);
      }
      update();
      _isMyCourseDataLoading = false;
    }
    update();
  }


  Future<void> paginatePurchaseCourse() async {}

  Future<void> downloadAndExtractZip(
      LMSMyCourseModel course, Function setStatus) async {
    try {
      final uid = Get.find<UserController>().uid;
      // Create course folder on local storage
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final String courseFolderPath =
          '${appDocDir.path}/$uid/courses/${course.lmsUserCourseId}';
      final Directory courseDir = Directory(courseFolderPath);
      if (!courseDir.existsSync()) {
        courseDir.createSync(recursive: true);
      }
      // store json file in local storage
      final jsonCourse = course.toJson();
      final jsonFile = File('$courseFolderPath/jsonCourse.json');
      await jsonFile.writeAsString(json.encode(jsonCourse));

      final response =
          await repository.getListLesson((course.id ?? 0).toString());
      List list = response?.body["data"];

      for (var i = 0; i < list.length; i++) {
        final res = list[i];
        Lesson lesson = Lesson.fromJsonGetCourse(list[i]);
        final String lessonFolderPath =
            '$courseFolderPath/lessons/${lesson.id}';
        final Directory lessonDir = Directory(lessonFolderPath);
        if (!lessonDir.existsSync()) {
          lessonDir.createSync(recursive: true);
        }
        // Download lesson file from api

        final jsonFile = File('$lessonFolderPath/jsonLesson.json');
        await jsonFile.writeAsString(json.encode(res));
        final List listVideo = res["field_video_url"];
        for (var i = 0; i < listVideo.length; i++) {
          final urlVideo = listVideo[i]['value'];
          final http.Response response = await http.get(Uri.parse(urlVideo));
          if (response.statusCode == 200) {
            final file = File('$lessonFolderPath/video.mp4');
            await file.writeAsBytes(response.bodyBytes);
            debugPrint('Downloaded video_$i.mp4 to $lessonFolderPath');
          } else {
            debugPrint(
                'Failed to download video from ${listVideo[i]['value']}');
          }
        }
        final List listUrlScorm = res["field_scorm"];
        for (var i = 0; i < listUrlScorm.length; i++) {
          final urlScorm = listUrlScorm[i]['url'];
          if (listUrlScorm.isNotEmpty) {
            final http.Response response = await http.get(Uri.parse(urlScorm));

            if (response.statusCode == 200) {
              // Get the directory path
              final Directory appDocDir =
                  await getApplicationDocumentsDirectory();
              final name = p.basenameWithoutExtension(urlScorm);
              final String zipFilePath = '${appDocDir.path}/$name.zip';
              final File zipFile = File(zipFilePath);

              // Write the downloaded .zip file to the file system
              // Write the file to the file system

              // final ByteData data = await rootBundle.load(response.body);

              await zipFile.writeAsBytes(response.bodyBytes);
              setStatus('Extracting...');
              _status = 'Extracting...';

              // Extract the .zip file
              final bytes = zipFile.readAsBytesSync();
              final archive = ZipDecoder().decodeBytes(bytes);

              for (final file in archive) {
                final filename = '$lessonFolderPath/${file.name}';
                if (file.isFile) {
                  final data = file.content as List<int>;
                  File(filename)
                    ..createSync(recursive: true)
                    ..writeAsBytesSync(data);
                } else {
                  await Directory(filename).create(recursive: true);
                }
              }

              // Delete the .zip file
              await zipFile.delete();
            }
          }
        }
      }
      setStatus('Done');
      _status = 'Done';
    } catch (e) {
      _status = 'Failed to download';
      setStatus('Failed to download');
    }
  }
}
