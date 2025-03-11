import 'dart:convert';

import 'package:opencentric_lms/data/model/quiz/quiz.dart';

import 'zoom_class_data.dart';

class Lesson {
  late int id;
  late String title;
  late String description;
  late String type;
  String? duration;
  late bool isFree;
  late String thumbnail;
  late dynamic link;
  late String lessonFolderPath;
  late List<LessonScorm> listScorm;
  late String urlScorm;
  late String urlVideoYoutube;
  late String urlVideo;
  late String urlVideoH5p;
  late ZoomClassData? zoomClassData;
  late bool isCompleted = false;
  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.duration,
    required this.isFree,
    required this.thumbnail,
    required this.link,
    required this.lessonFolderPath,
    required this.listScorm,
    required this.urlScorm,
    required this.urlVideoYoutube,
    required this.urlVideo,
    required this.urlVideoH5p,
    required this.zoomClassData,
    required this.isCompleted,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    var listScormFromJson = json['list_scorm'] as List;
    List<LessonScorm> listScormList =
        listScormFromJson.map((i) => LessonScorm.fromJson(i)).toList();

    return Lesson(
      id: json['id'] as int,
      title: json['title'] as String,
      description:
          json['description'] != null ? json['description'] as String : '',
      type: json['type'] as String,
      duration: json['duration'] as String?,
      isFree: json['is_free'] as bool,
      thumbnail: json['thumbnail'] as String,
      link: json['link'] as String,
      lessonFolderPath: json['lessonFolderPath'] as String,
      listScorm: listScormList,
      urlScorm: json['field_scorm'][0]['url_app_play_scorme'] ?? "",
      urlVideoYoutube: json['field_embedded_video'][0]['value'] ?? "",
      urlVideo: json['field_video_url'][0]['value'] ?? "",
      zoomClassData: json['field_zoom_class_data'][0]['value'] ?? "",
      urlVideoH5p: json['field_h5p_content'][0]['h5p_url'] ?? "",
      isCompleted: false,
    );
  }

  factory Lesson.fromJsonGetCourse(Map<String, dynamic> json) {
    final id = int.tryParse(json['lms_lesson_id'][0]["value"] ?? "0") ?? 0;
    final name = json['name'][0]["value"] ?? 0;
    final fieldFree = json['field_free'][0]["value"] ?? "0";
    String urlScorm = "";
    if (json['field_scorm'] != null && json['field_scorm'].isNotEmpty) {
      urlScorm = json['field_scorm'][0]["url_app_play_scorme"] ?? "";
    }
    String urlVideoYoutube = "";
    if (json['field_embedded_video'] != null &&
        json['field_embedded_video'].isNotEmpty) {
      urlVideoYoutube = json['field_embedded_video'][0]["value"] ?? "";
    }
    String urlVideo = "";
    if (json['field_video_url'] != null && json['field_video_url'].isNotEmpty) {
      urlVideo = json['field_video_url'][0]["value"] ?? "";
    }
    final List listScorm = json['field_scorm'];
    ZoomClassData? zoomClassData;
    if (json['field_zoom_class_data'] != null &&
        json['field_zoom_class_data'].isNotEmpty) {
      zoomClassData = ZoomClassData.fromJson(
          jsonDecode(json['field_zoom_class_data'][0]["value"]));
    }
    final listH5p = json['field_h5p_content'];
    String urlVideoH5p = "";
    if (listH5p != null && listH5p.isNotEmpty) {
      urlVideoH5p = listH5p[0]["h5p_url"] ?? "";
    }
    return Lesson(
      id: id,
      title: name,
      description: "",
      type: "",
      isFree: fieldFree == "1" ? true : false,
      thumbnail: "",
      link: "",
      lessonFolderPath: "",
      urlScorm: urlScorm,
      urlVideoYoutube: urlVideoYoutube,
      listScorm: listScorm.map((e) => LessonScorm.fromJson(e)).toList(),
      zoomClassData: zoomClassData,
      urlVideo: urlVideo,
      urlVideoH5p: urlVideoH5p,
      isCompleted: false,
    );
  }

  Map<String, Object?> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'type': type,
        'duration': duration,
        'is_free': isFree,
        'thumbnail': thumbnail,
        'link': link,
        'lessonFolderPath': lessonFolderPath,
        'list_scorm': listScorm.map((e) => e.toJson()).toList(),
      };
}

class LessonScorm {
  int? targetId;
  // bool? display;
  String? description;
  String? targetType;
  String? targetUuid;
  String? url;

  LessonScorm(
      {this.targetId,
      // this.display,
      this.description,
      this.targetType,
      this.targetUuid,
      this.url});

  LessonScorm.fromJson(Map<String, dynamic> json) {
    if (json['target_id'] is String) {
      targetId = int.tryParse(json['target_id']);
    } else {
      targetId = json['target_id'];
    }
    // display = json['display'];
    description = json['description'];
    targetType = json['target_type'];
    targetUuid = json['target_uuid'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['target_id'] = targetId;
    // data['display'] = display;
    data['description'] = description;
    data['target_type'] = targetType;
    data['target_uuid'] = targetUuid;
    data['url'] = url;
    return data;
  }
}
