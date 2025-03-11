import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:opencentric_lms/config.dart';
import 'package:opencentric_lms/data/model/common/lms_my_course.dart';
import 'package:opencentric_lms/data/model/common/my_course_offline.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/subjects.dart';

import 'user_controller.dart';

class MyCourseOfflineController extends GetxController implements GetxService {
  MyCourseOfflineController();

  final downloadStream = ReplaySubject<List<MyCourseOffline>>();
  final loadingStream = ReplaySubject<bool>();
  final List<MyCourseOffline> _myCourseOfflineList = [];
  List<MyCourseOffline> get myCourseOfflineList => _myCourseOfflineList;
  bool _isMyCourseDataLoading = false;
  bool get isMyCourseLoading => _isMyCourseDataLoading;

  Future<void> getMyCourseList() async {
    _isMyCourseDataLoading = true;
    loadingStream.add(true);
    final uid = Get.find<UserController>().uid;
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String listCourseFolderPath = '${appDocDir.path}/$uid/courses/';
    // Get list folder of course
    final Directory listCourseDir = Directory(listCourseFolderPath);
    if (await listCourseDir.exists()) {
      final List<FileSystemEntity> entities = listCourseDir.listSync();
      for (var i = 0; i < entities.length; i++) {
        final courseFolderPath = entities[i].path;
        final jsonFile = File('$courseFolderPath/jsonCourse.json');
        final data = await jsonFile.readAsString();
        final jsonCourse = json.decode(data);
        LMSMyCourseModel course = LMSMyCourseModel.fromJson(jsonCourse);
        MyCourseOffline item = MyCourseOffline(
          id: course.lmsUserCourseId,
          thumbnail: Config.baseUrl + (course.fieldImage ?? ''),
          title: course.courseName,
          course: course,
        );
        _myCourseOfflineList.add(item);
      }
    }
    downloadStream.add(_myCourseOfflineList);
    _isMyCourseDataLoading = false;
    loadingStream.add(false);
  }

  // Future<void> getMyCourseList() async {
  //   _isMyCourseDataLoading = true;
  //   loadingStream.add(true);
  //   // Get the directory path
  //   final Directory directory = await getApplicationDocumentsDirectory();
  //   final String folderPath = '${directory.path}/scorm';
  //   // Count the subfolders
  //   final Directory folder = Directory(folderPath);
  //   if (await folder.exists()) {
  //     final List<FileSystemEntity> entities = folder.listSync();
  //     for (FileSystemEntity entity in entities) {
  //       if (entity is Directory) {
  //         // Đọc tệp imsmanifest.xml

  //         final manifestPath = '${entity.path}/imsmanifest.xml';
  //         final manifestFile = File(manifestPath);
  //         final document = XmlDocument.parse(manifestFile.readAsStringSync());
  //         // Tìm tệp SCO (scormType="sco")

  //         XmlElement scoItem = document.findAllElements('resource').firstWhere(
  //               (element) =>
  //                   element.getAttribute('adlcp:scormType') == 'sco' &&
  //                   element.getAttribute('href') != null,
  //             );
  //         //Tìm id

  //         final idString = scoItem.getAttribute('identifier');
  //         final url =
  //             '${entity.path.split('/').last}/${scoItem.getAttribute('href')}';
  //         //Tìm thumbnail
  //         // Tìm tệp asset adlcp:scormType="asset"
  //         print(url);
  //         final assetItem = document.findAllElements('resource').firstWhere(
  //               (element) =>
  //                   element.getAttribute('adlcp:scormType') == 'asset' &&
  //                   element.getAttribute('href') != null,
  //             );
  //         final thumbnailString =
  //             '${entity.path}/${assetItem.getAttribute('href')}';
  //         //Tìm title
  //         final XmlElement descriptionElement =
  //             document.findAllElements('description').first;
  //         final XmlElement stringElement =
  //             descriptionElement.findElements('string').first;
  //         final String descriptionText = stringElement.innerText;
  //         MyCourseOffline item = MyCourseOffline(
  //             id: idString,
  //             thumbnail: thumbnailString,
  //             title: descriptionText,
  //             url: url);
  //         _myCourseOfflineList.add(item);
  //       }
  //     }
  //   }
  //   downloadStream.add(_myCourseOfflineList);
  //   _isMyCourseDataLoading = false;
  //   loadingStream.add(false);
  // }
}
