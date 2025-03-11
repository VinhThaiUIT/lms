import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/provider/client_api.dart';
import '../feature/quiz/export_quizpage.dart';
import '../utils/app_constants.dart';

class QuizRepository {
  final ApiClient apiClient;
  QuizRepository({required this.apiClient});

  Future<Response?> getQuizDataByCourseId(String courseId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uid = sharedPreferences.getString(AppConstants.uid);
    return apiClient.getData(AppConstants.getListQuizByCourseId, body: {
      "course_id": courseId,
      "user_id": uid,
    });
  }

  Future<Response?> getQuizDataByLessonId(String lessonId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uid = sharedPreferences.getString(AppConstants.uid);
    return apiClient.getData(AppConstants.getListQuizByLessonId, body: {
      "lesson_id": lessonId,
      "user_id": uid,
    });
  }

  Future<Response?> answerQuiz(int startTime, int endTime, String quizId,
      String user, List<GivenAnswer> listAnswer) async {
    Map<String, dynamic> formValues = {};
    for (int i = 0; i < listAnswer.length; i++) {
      GivenAnswer answer = listAnswer[i];
      String key = "answers_select_$i";

      // if list select answer is == -1 return 0 else return the index of the answer
      Map<String, dynamic> answerMap = {};
      if (answer.selectedIndexes.length < 4) {
        answerMap["0"] = 0;
        answerMap["1"] = 0;
        answerMap["2"] = 0;
        answerMap["3"] = 0;
      }
      for (int j = 0; j < answer.selectedIndexes.length; j++) {
        answerMap[answer.selectedIndexes[j].toString()] =
            answer.selectedIndexes[j] == -1
                ? 0
                : answer.selectedIndexes[j].toString();
      }
      formValues[key] = answerMap;
    }
    var body = {
      "data_json": {
        "start_time": startTime,
        "end_time": endTime,
        "quiz_id": quizId,
        "user_id": user,
        "form_values": formValues
      }
    };
    print(body.toString());
    return apiClient.postData(AppConstants.answerQuiz, body);
  }

  Future<Response?> lmsGetQuizResult(String user, String quizId) async {
    var body = {
      "user_id": user,
      "quiz_id": quizId,
    };
    return apiClient.getData(AppConstants.lmsGetQuizResult, body: body);
  }
}
