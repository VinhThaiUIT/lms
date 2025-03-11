class QuizResult {
  String fieldScore;
  String fieldResult;
  List<QuestionAnswerResponse>? fieldQuestionsResponse;
  String? urlDownload;
  QuizResult({
    required this.fieldScore,
    required this.fieldResult,
    required this.fieldQuestionsResponse,
    required this.urlDownload,
  });

  QuizResult.fromJson(Map<String, dynamic> json)
      : fieldScore = json['field_score'][0]['value'],
        fieldResult = json['field_result'],
        fieldQuestionsResponse = json['field_questions_response'] != null
            ? (json['field_questions_response'] as Map<String, dynamic>)
                .entries
                .map((e) => QuestionAnswerResponse.fromJson(e.value))
                .toList()
            : [],
        urlDownload = json['field_user_certificate'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['field_score'] = fieldScore;
    data['field_result'] = fieldResult;
    data['field_questions_response'] = fieldQuestionsResponse;
    return data;
  }
}

class QuestionAnswerResponse {
  String id;
  String name;
  List<String> answer;
  String body;
  String correct;
  String score;

  QuestionAnswerResponse({
    required this.id,
    required this.name,
    required this.answer,
    required this.body,
    required this.correct,
    required this.score,
  });

  QuestionAnswerResponse.fromJson(Map<String, dynamic> json)
      : id = json['lms_question_response_id'][0]['value'],
        name = json['name'][0]['value'],
        answer = List<String>.from(json['field_answers']),
        body = json['field_body'][0]['value'],
        correct = json['field_correct'][0]['value'],
        score = json['field_score'][0]['value'];
}
