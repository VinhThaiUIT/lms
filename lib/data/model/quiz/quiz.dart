class Quiz {
  String? fieldStatusQuiz;
  String? id;
  int? sectionId;
  String? name;
  String? slug;
  String? duration;
  int? totalMarks;
  int? passMarks;
  int? certificateIncluded;
  int? status;
  String? fieldBody;
  String? takeQuizNumber;
  String? fieldThreshold;
  String? createdAt;
  String? updatedAt;

  Quiz({
    this.fieldStatusQuiz,
    this.id,
    this.sectionId,
    this.name,
    this.slug,
    this.duration,
    this.totalMarks,
    this.passMarks,
    this.certificateIncluded,
    this.status,
    this.fieldBody,
    this.takeQuizNumber,
    this.createdAt,
    this.updatedAt,
  });

  Quiz.fromJson(Map<String, dynamic> json) {
    fieldStatusQuiz = json['field_status_quiz'];
    id = json['lms_quiz_id'][0]['value'];
    sectionId = json['section_id'];
    name = json['name'][0]['value'];
    slug = json['slug'];
    duration = json['field_time_limit'][0]['value'];
    totalMarks = json['total_marks'];
    passMarks = json['pass_marks'];
    certificateIncluded = json['certificate_included'];
    fieldBody = json['field_body'][0]['value'];
    takeQuizNumber = json['field_take_quiz_number'][0]['value'];
    fieldThreshold = json['field_threshold'][0]['value'];
    // status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field_status_quiz'] = fieldStatusQuiz;
    data['lms_quiz_id'] = [
      {'value': id}
    ];
    data['section_id'] = sectionId;
    data['name'] = [
      {'value': name}
    ];
    data['slug'] = slug;
    data['field_time_limit'] = [
      {'value': duration}
    ];
    data['total_marks'] = totalMarks;
    data['pass_marks'] = passMarks;
    data['certificate_included'] = certificateIncluded;
    data['field_body'] = [
      {'value': fieldBody}
    ];
    data['field_take_quiz_number'] = [
      {'value': takeQuizNumber}
    ];
    data['field_threshold'] = [
      {'value': fieldThreshold}
    ];
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
