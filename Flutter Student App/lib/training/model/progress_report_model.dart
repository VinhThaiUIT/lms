

class ProgressReportModel {
  String? id;
  String? name;
  String? courseProgress;
  String? category;
  String? totalQuizPass;
  String? created;
  String? certificatesTitle;
  String? certificates;
  String? result;

  ProgressReportModel({
    required this.id,
    required this.name,
    required this.courseProgress,
    required this.category,
    required this.totalQuizPass,
    required this.created,
    required this.certificatesTitle,
    required this.certificates,
    required this.result,
  });

  factory ProgressReportModel.fromJson(Map<String, dynamic> json) {
    return ProgressReportModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      courseProgress: json['course_progress'].toString(),

      category: 'Unknown',
      // category: (json['category'] != null ) 
      //   ? json['category']['title'].toString()
      //   : "Unknown",  

      totalQuizPass: json['total_quiz_pass'] as String?,
      created: json['created'] as String?,
      certificatesTitle: (json['certificates'] != null && json['certificates'].isNotEmpty )
          ? json['certificates'][0]['cert_title']
          : null,
      certificates: (json['certificates'] != null && json['certificates'].isNotEmpty )
          ? json['certificates'][0]['cert_link']
          : null,
      result: json['result'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{}; 
    data['id'] = id;
    return data;

  }


}