import 'package:opencentric_lms/data/model/common/section.dart';

class CourseModel {
  bool? success;
  String? message;
  ServiceContent? content;

  CourseModel({this.success, this.message, this.content});

  CourseModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    content =
        json['data'] != null ? ServiceContent.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    data['message'] = message;
    if (content != null) {
      data['data'] = content!.toJson();
    }
    return data;
  }
}

class ServiceContent {
  List<Course>? courses;

  ServiceContent({this.courses});

  ServiceContent.fromJson(Map<String, dynamic> json) {
    if (json['courses'] != null) {
      courses = <Course>[];
      json['courses'].forEach((v) {
        courses!.add(Course.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (courses != null) {
      data['courses'] = courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Course {
  int? id;
  String? thumbnail;
  String? title;
  int? totalLessons;
  int? totalEnrolls;
  bool? isFree;
  String? totalRating;
  String? price;
  bool? isDiscounted;
  String? discountType;
  String? discountedPrice;
  String? fieldResult;
  String? fieldLanguage;
  String? fieldLevel;
  String? courseName;
  String? fieldImage;
  String? fieldCategory;
  String? fieldTotalQuizPass;
  String? fieldUserCertificate;
  String? created;
  String? lmsUserCourseId;
  String? fieldLearnerNumber;
  String? fieldTotalLessons;
  String? fieldTotalHours;
  String? fieldAge;
  String? fieldShortDescription;
  String? fieldRequirements;
  String? fieldWhatYouLearn;
  String? url;
  List<String>? fieldLessons;
  List<Section>? listSections;

  Course(
      {this.id,
      this.thumbnail,
      this.title,
      this.totalLessons,
      this.totalEnrolls,
      this.isFree,
      this.totalRating,
      this.price,
      this.isDiscounted,
      this.discountType,
      this.discountedPrice,
      this.fieldResult,
      this.fieldLanguage,
      this.fieldLevel,
      this.courseName,
      this.fieldImage,
      this.fieldCategory,
      this.fieldTotalQuizPass,
      this.fieldUserCertificate,
      this.created,
      this.lmsUserCourseId,
      this.fieldLearnerNumber,
      this.fieldTotalLessons,
      this.fieldTotalHours,
      this.fieldAge,
      this.fieldShortDescription,
      this.fieldRequirements,
      this.fieldWhatYouLearn,
      this.url,
      this.fieldLessons,
      this.listSections,
      });

  Course.fromJson(Map<String, dynamic> json) {
    if (json['id'] is String) {
      id = int.tryParse(json['id']);
    } else {
      id = json['id'];
    }
    thumbnail = json['thumbnail'];
    title = json['title'];
    totalLessons = json['total_lessons'];
    totalEnrolls = json['total_enrolls'];
    isFree = json['is_free'];
    totalRating = json['total_rating'];
    price = json['price'];
    isDiscounted = json['is_discounted'];
    discountType = json['discount_type'];
    discountedPrice = json['discounted_price'];
    fieldResult = json['field_result'];
    fieldLanguage = json['field_language'];
    fieldLevel = json['field_level'];
    courseName = json['course_name'];
    fieldImage = json['field_image'];
    fieldCategory = json['field_category'];
    fieldResult = json['field_result'];
    fieldTotalQuizPass = json['field_total_quiz_pass'];
    fieldUserCertificate = json['field_user_certificate'];
    created = json['created'];
    lmsUserCourseId = json['lms_user_course_id'];
    fieldLearnerNumber = json['field_learner_number'];
    fieldTotalLessons = json['field_total_lessons'];
    fieldTotalHours = json['field_total_hours'];
    fieldAge = json['field_age'];
    fieldLevel = json['field_level'];
    fieldLanguage = json['field_language'];
    fieldShortDescription = json['field_short_description'];
    fieldRequirements = json['field_requirements'];
    fieldWhatYouLearn = json['field_what_you_learn'];
    fieldLessons = json['field_lessons'].cast<String>();
    listSections = json['list_sections'];
    url = json['url'];

    // training
  }

  factory Course.fromJsonCourseDetail(Map<String, dynamic> json) {
    int? parseId(dynamic value) {
      if (value is int) {
        return value;
      } else if (value is String) {
        return int.tryParse(value);
      }
      return null;
    }

    bool? parseBool(dynamic value) {
      if (value is bool) {
        return value;
      } else if (value is String) {
        return value.toLowerCase() == 'true';
      }
      return null;
    }

    return Course(
      id: (json['product_id'] != null &&
              (json['product_id'] as List).isNotEmpty)
          ? parseId(json['product_id'][0]['value'])
          : null,
      title: (json['title'] != null && (json['title'] as List).isNotEmpty)
          ? json['title'][0]['value']
          : null,
      courseName: (json['title'] != null && (json['title'] as List).isNotEmpty)
          ? json['title'][0]['value']
          : null,
      lmsUserCourseId: (json['field_course_preview'] != null &&
              (json['field_course_preview'] as List).isNotEmpty)
          ? json['field_course_preview'][0]['target_id'].toString()
          : null,
      isFree: (json['field_free'] != null &&
              (json['field_free'] as List).isNotEmpty)
          ? parseBool(json['field_free'][0]['value'])
          : null,
      fieldImage: (json['field_image'] != null &&
              (json['field_image'] as List).isNotEmpty)
          ? json['field_image'][0]['url']
          : null,
      fieldLearnerNumber: (json['field_learner_number'] != null &&
              (json['field_learner_number'] as List).isNotEmpty)
          ? json['field_learner_number'][0]['value'].toString()
          : null,
      fieldLessons: (json['field_lessons'] != null &&
              (json['field_lessons'] as List).isNotEmpty)
          ? (json['field_lessons'] as List)
              .map((lesson) => lesson['target_id'].toString())
              .toList()
          : null,
      fieldRequirements: (json['field_requirements'] != null &&
              (json['field_requirements'] as List).isNotEmpty)
          ? json['field_requirements'][0]['value']
          : null,
      fieldShortDescription: (json['field_short_description'] != null &&
              (json['field_short_description'] as List).isNotEmpty)
          ? json['field_short_description'][0]['value']
          : null,
      fieldTotalHours: (json['field_total_hours'] != null &&
              (json['field_total_hours'] as List).isNotEmpty)
          ? json['field_total_hours'][0]['value'].toString()
          : null,
      totalLessons: (json['field_total_lessons'] != null &&
              (json['field_total_lessons'] as List).isNotEmpty)
          ? parseId(json['field_total_lessons'][0]['value'])
          : null,
      fieldTotalQuizPass: (json['field_total_quizzes'] != null &&
              (json['field_total_quizzes'] as List).isNotEmpty)
          ? json['field_total_quizzes'][0]['value'].toString()
          : null,
      fieldWhatYouLearn: (json['field_what_you_learn'] != null &&
              (json['field_what_you_learn'] as List).isNotEmpty)
          ? json['field_what_you_learn'][0]['value']
          : null,
      url: (json['path'] != null && (json['path'] as List).isNotEmpty)
          ? json['path'][0]['alias']
          : null,

      // module : (json['field_module'] != null && (json['field_module'] as List).isNotEmpty)
      //         ? json['field_module']
      //         : null,

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['thumbnail'] = thumbnail;
    data['title'] = title;
    data['total_lessons'] = totalLessons;
    data['total_enrolls'] = totalEnrolls;
    data['is_free'] = isFree;
    data['total_rating'] = totalRating;
    data['price'] = price;
    data['is_discounted'] = isDiscounted;
    data['discount_type'] = discountType;
    data['discounted_price'] = discountedPrice;
    data['field_result'] = fieldResult;
    data['field_language'] = fieldLanguage;
    data['field_level'] = fieldLevel;
    data['course_name'] = courseName;
    data['field_image'] = fieldImage;
    data['field_category'] = fieldCategory;
    data['field_result'] = fieldResult;
    data['field_total_quiz_pass'] = fieldTotalQuizPass;
    data['field_user_certificate'] = fieldUserCertificate;
    data['created'] = created;
    data['lms_user_course_id'] = lmsUserCourseId;
    data['field_learner_number'] = fieldLearnerNumber;
    data['field_total_lessons'] = fieldTotalLessons;
    data['field_total_hours'] = fieldTotalHours;
    data['field_age'] = fieldAge;
    data['field_level'] = fieldLevel;
    data['field_language'] = fieldLanguage;
    data['field_short_description'] = fieldShortDescription;
    data['field_requirements'] = fieldRequirements;
    data['field_what_you_learn'] = fieldWhatYouLearn;
    data['field_lessons'] = fieldLessons;
    data['list_sections'] = listSections;
    data['url'] = url;
    // data['field_module'] = module;
    return data;
  }
}
