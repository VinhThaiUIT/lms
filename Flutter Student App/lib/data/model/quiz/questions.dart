import 'option.dart';

enum QuestionType { defaultQuestion, mcq, shortQuestion }

class Questions {
  late String question;
  late QuestionType questionType;
  List<Option>? option;
  List<int>? correctAnswerIndex;

  Questions(
      {required this.question,
      required this.questionType,
      this.option,
      this.correctAnswerIndex});

  Questions.fromJson(Map<String, dynamic> json) {
    question = json['question_name'];
    //questionType = json['question_type'];
    switch (json['question_type']) {
      case 'short_question':
        questionType = QuestionType.shortQuestion;
        break;
      case 'mcq':
        questionType = QuestionType.mcq;
        break;
      case 'default':
        questionType = QuestionType.defaultQuestion;
        break;
      default:
        questionType = QuestionType.defaultQuestion;
        break;
    }

    if (json['choices_name'] != null) {
      option = <Option>[];
      correctAnswerIndex = <int>[];
      final list = json['choices_name'] as List;
      for (var i = 0; i < list.length; i++) {
        option!.add(Option.fromJson(list[i]));
        if (json['correct_answer_index'] != null) {
          correctAnswerIndex = <int>[];
          final list = json['correct_answer_index'] as List;
          for (var i = 0; i < list.length; i++) {
            correctAnswerIndex!.add(list[i]);
          }
        } else if (list[i]['field_correct'] == "1") {
          correctAnswerIndex!.add(i);
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['question_name'] = question;
    switch (questionType) {
      case QuestionType.shortQuestion:
        data['question_type'] = 'short_question';
        break;
      case QuestionType.mcq:
        data['question_type'] = 'mcq';
        break;
      case QuestionType.defaultQuestion:
        data['question_type'] = 'default';
        break;
      default:
        data['question_type'] = 'default';
        break;
    }
    if (option != null) {
      data['choices_name'] = option!.map((v) => v.toJson()).toList();
    }
    data['correct_answer_index'] = correctAnswerIndex;
    return data;
  }
}
