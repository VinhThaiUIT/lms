import 'package:opencentric_lms/data/model/quiz/data.dart';

class QuizModel {
  late String message;
  late List<DataQuiz> data;

  QuizModel({required this.message, required this.data});

  QuizModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null
        ? (json['data'] as List).map((i) => DataQuiz.fromJson(i)).toList()
        : <DataQuiz>[];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['message'] = message;
    data['data'] = this.data.map((v) => v.toJson()).toList();
    return data;
  }
}
