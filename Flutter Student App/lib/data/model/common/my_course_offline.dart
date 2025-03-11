import 'package:opencentric_lms/data/model/common/lms_my_course.dart';

class MyCourseOffline {
  String? id;
  String? thumbnail;
  String? title;
  String? url;
  LMSMyCourseModel? course;

  MyCourseOffline({
    this.id,
    this.thumbnail,
    this.title,
    this.url,
    this.course,
  });

  factory MyCourseOffline.fromJson(Map<String, Object?> json) =>
      MyCourseOffline(
        id: json['id'] as String?,
        thumbnail: json['thumbnail'] as String?,
        title: json['title'] as String?,
        url: json['url'] as String?,
        course: json['course'] as LMSMyCourseModel?,
      );

  Map<String, Object?> toJson() => {
        'id': id,
        'thumbnail': thumbnail,
        'title': title,
        'url': url,
        'course': course,
      };
}
