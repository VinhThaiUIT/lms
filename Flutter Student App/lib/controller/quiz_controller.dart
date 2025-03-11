import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/data/model/quiz/quiz_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/custom_snackbar.dart';
import '../components/loading_dialog.dart';
import '../core/helper/help_me.dart';
import '../data/model/quiz/data.dart';
import '../data/model/quiz/quiz_result.dart';
import '../feature/landing/offline_landing_screen.dart';
import '../feature/quiz/export_quizpage.dart';
import '../network_service.dart';
import '../repository/quiz_repository.dart';
import '../utils/app_constants.dart';

class QuizController extends GetxController implements GetxService {
  final QuizRepository quizRepo;
  QuizController({required this.quizRepo});

  bool _isDataLoading = false;
  bool get isDataLoading => _isDataLoading;
  QuizModel? _quizModel;
  QuizModel? get quizModel => _quizModel;

  QuizModel? _quizModelLesson;
  QuizModel? get quizModelLesson => _quizModelLesson;
  // training
  List<QuizModel>? _listQuizModelLesson;
  List<QuizModel>? get listQuizModelLesson => _listQuizModelLesson;

  int? startTime;
  int? duration;
  bool _isQuizLoading = true;
  bool get isQuizLoading => _isQuizLoading;
  bool _isDataResultLoading = false;
  bool get isDataResultLoading => _isDataResultLoading;
  DataQuiz? dataQuiz;

  QuizResult? quizResult;
  Future<void> getQuizDataByCourseId(String courseId) async {
    _isDataLoading = true;
    final response = await quizRepo.getQuizDataByCourseId(courseId);
    if (response != null && response.statusCode == 200) {
      // printLog("-------id:$quizId \n and response: ${response.body}");
      _quizModel = QuizModel.fromJson(response.body);
    }
    _isDataLoading = false;
    update();
  }

  Future<void> getQuizDataByLessonId(String lessonId) async {
    _isDataLoading = true;
    final response = await quizRepo.getQuizDataByLessonId(lessonId);
    if (response != null && response.statusCode == 200) {
      // printLog("-------id:$quizId \n and response: ${response.body}");
      _quizModelLesson = QuizModel.fromJson(response.body);
    } else {
      _quizModelLesson = null;
    }
    _isDataLoading = false;
    update();
  }

  Future<void> lmsGetQuizResult() async {
    // _isDataResultLoading = true;
    // update();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final uid = sharedPreferences.getString(AppConstants.uid);
    final response =
        await quizRepo.lmsGetQuizResult(uid ?? "", dataQuiz!.quiz!.id ?? "");
    if (response != null && response.statusCode == 200) {
      quizResult = QuizResult.fromJson(response.body["data"]);
    }
    return;
    // _isDataResultLoading = false;
    // update();
  }

  setListAnswer(List<GivenAnswer> listAnswer) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // listAnswer to json

    // save list answer to local storage
    sharedPreferences.setStringList(
        "listAnswer", listAnswer.map((e) => json.encode(e.toJson())).toList());
    update();
  }

  Future<List<GivenAnswer>?> getListAnswer() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // get list answer from local storage
    final listAnswerLocal = sharedPreferences.getStringList("listAnswer");
    if (dataQuiz == null) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final jsonStringDataQuiz = sharedPreferences.getString("dataQuiz");
      if (jsonStringDataQuiz != null) {
        dataQuiz = DataQuiz.fromJson(json.decode(jsonStringDataQuiz));
      }
    }
    if (listAnswerLocal != null) {
      // convert list answer from json to object
      final listAnswer = listAnswerLocal
          .map((e) => GivenAnswer.fromJson(json.decode(e)))
          .toList();
      for (var i = 0; i < listAnswer.length; i++) {
        listAnswer[i] = GivenAnswer(
          isCorrect: listAnswer[i].isCorrect,
          question: dataQuiz!.questions[i],
          selectedIndexes: listAnswer[i].selectedIndexes,
          shortQuestionAns: listAnswer[i].shortQuestionAns,
        );
      }
      return listAnswer;
    }
    return null;
  }

  updateResultLoadingTrue() {
    _isDataResultLoading = true;
  }

  updateResultLoadingFalse() {
    _isDataResultLoading = false;
    update();
  }

  updateLoadingTrue() {
    _isQuizLoading = true;
  }

  updateLoadingFalse() {
    _isQuizLoading = false;
    update();
  }

  // Start Quiz Answer and store object and start time to local storage for future use
  Future<bool> startQuiz(int timeMinutesLimit, String quizId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    startTime = await checkQuizStarted(quizId);
    if (startTime == null) {
      false;
    } else {
      // check time now and start time if the difference is greater than the time limit then return false
      final currentTime = DateTime.now().millisecondsSinceEpoch;
      final difference = currentTime - startTime!;
      if (difference > timeMinutesLimit * 60 * 1000) {
        // get list answer from local storage
        final listAnswerLocal = sharedPreferences.getStringList("listAnswer");

        if (listAnswerLocal != null) {
          // convert list answer from json to object
          final listAnswer = listAnswerLocal
              .map((e) => GivenAnswer.fromJson(json.decode(e)))
              .toList();
          answerQuiz(
            startTime!,
            currentTime,
            quizId,
            listAnswer,
            () {},
          );
        }
        // show dialog to talk to the user time to answer the quiz is over and your answer is submitted
        customSnackBar(
            'Time to answer the quiz is over and your answer is submitted',
            isError: false);
        sharedPreferences.remove("listAnswer");
        sharedPreferences.remove("quizId");
        sharedPreferences.remove("quizStartTime");
        sharedPreferences.remove("durationQuiz");
        return false;
      }
    }
    sharedPreferences.setString("quizId", quizId);
    sharedPreferences.setString("quizStartTime", startTime.toString());
    sharedPreferences.setString("durationQuiz", duration.toString());
    update();
    return true;
  }

  // Check if the quiz is already started or not and return the start time
  Future<int?> checkQuizStarted(String quizId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    // Check if right quiz is started or not and return the start time
    final quizId = sharedPreferences.getString("quizId");
    if (quizId == null) {
      return DateTime.now().millisecondsSinceEpoch;
    } else if (quizId != quizId) {
      return null;
    } else {
      final startTimeString = sharedPreferences.getString("quizStartTime");
      if (startTimeString != null) {
        startTime = int.parse(startTimeString);
        return startTime;
      } else {
        return null;
      }
    }
  }

  Future<void> answerQuiz(
    int startTime,
    int endTime,
    String quizId,
    List<GivenAnswer> listAnswer,
    Function onSuccess,
  ) async {
    try {
      final isConnected = await NetworkService().checkInternetConnection();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      if (isConnected) {
        _isDataLoading = true;
        update();

        LoadingDialog.show(Get.context!);

        final uid = sharedPreferences.getString(AppConstants.uid);
        final response = await quizRepo.answerQuiz(
            startTime, endTime, quizId, uid ?? "", listAnswer);
        if (response != null && response.statusCode == 200) {
          // remove list answer from local storage
          sharedPreferences.remove("listAnswer");
          sharedPreferences.remove("quizId");
          sharedPreferences.remove("quizStartTime");
          sharedPreferences.remove("durationQuiz");
        }
        LoadingDialog.hide(Get.context!);
        _isDataLoading = false;
        update();
        onSuccess();
      } else {
        sharedPreferences.setBool("isSendQuiz", true);
        customSnackBar('Your answer is save and when online it will be sent',
            isError: false);
        Get.offAll(() => const MainOfflineScreen(pageIndex: 0));
      }
    } catch (e) {
      LoadingDialog.hide(Get.context!);
      _isDataLoading = false;
      update();
    }
  }
}
