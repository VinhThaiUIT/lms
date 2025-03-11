import 'questions.dart';
import 'quiz.dart';

class DataQuiz {
  Quiz? quiz;
  List<Questions> questions = [];

  DataQuiz({this.quiz, required this.questions});

  DataQuiz.fromJson(Map<String, dynamic> json) {
    if (json['quiz'] != null) {
      quiz = Quiz.fromJson(json['quiz']);
    } else {
      quiz = Quiz.fromJson(json);
    }

    if (json['field_questions'] != null) {
      questions = <Questions>[];
      json['field_questions'].forEach((v) {
        questions.add(Questions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (quiz != null) {
      data['quiz'] = quiz!.toJson();
    }
    data['field_questions'] = questions.map((v) => v.toJson()).toList();
    return data;
  }
}
