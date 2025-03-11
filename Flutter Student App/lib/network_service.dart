import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_snackbar.dart';
import 'package:opencentric_lms/controller/quiz_controller.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import 'controller/forum_controller.dart';
import 'core/helper/route_helper.dart';

class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;

  NetworkService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _networkStatusController =
      StreamController<bool>.broadcast();

  Stream<bool> get networkStatusStream => _networkStatusController.stream;

  void initialize() {
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      bool isConnected = false;
      for (var i = 0; i < result.length; i++) {
        if (result[i] == ConnectivityResult.none &&
            Get.currentRoute == "/quizStartPage") {
          return;
        }
        if (result[i] == ConnectivityResult.wifi ||
            result[i] == ConnectivityResult.mobile) {
          SharedPreferences.getInstance().then((value) async {
            // Check forum Offline
            final createForum =
                value.getString(AppConstants.createForumOffline);
            if (createForum != null) {
              Map<String, dynamic> createForumMap = json.decode(createForum);
              await Get.find<ForumController>().createForum(
                createForumMap['subject'] ?? "",
                createForumMap['forumId'] ?? "",
                createForumMap['body'] ?? "",
              );
              value.remove(AppConstants.createForumOffline);
              customSnackBar('Create forum success', isError: false);
            }
            // Check comment Offline
            final createComment =
                value.getString(AppConstants.createCommentOffline);
            if (createComment != null) {
              Map<String, dynamic> createCommentMap =
                  json.decode(createComment);
              await Get.find<ForumController>().createComment(
                createCommentMap['subject'] ?? "",
                createCommentMap['forumId'] ?? "",
                createCommentMap['body'] ?? "",
                createCommentMap['topic'] ?? "",
              );
              value.remove(AppConstants.createCommentOffline);
              customSnackBar('Create comment success', isError: false);
            }

            Future.delayed(const Duration(seconds: 2), () async {
              // Check quiz offline
              final isSendQuiz = value.getBool("isSendQuiz");
              if (isSendQuiz != null) {
                final quizId = value.getString("quizId");
                final givenAnswerList =
                    await Get.find<QuizController>().getListAnswer();
                await Get.find<QuizController>().answerQuiz(
                  DateTime.now().millisecondsSinceEpoch,
                  DateTime.now().millisecondsSinceEpoch,
                  quizId ?? "",
                  givenAnswerList ?? [],
                  () {
                    value.remove("isSendQuiz");
                    customSnackBar('your answer is sent', isError: false);
                    Get.toNamed(RouteHelper.quizResultScreen,
                        arguments: givenAnswerList);
                  },
                );
              }
            });
          });

          isConnected = true;
          break;
        }
      }
      _networkStatusController.add(isConnected);
    });
  }

  Future<bool> checkInternetConnection() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    for (var i = 0; i < connectivityResult.length; i++) {
      if (connectivityResult[i] == ConnectivityResult.wifi ||
          connectivityResult[i] == ConnectivityResult.mobile) {
        return true;
      }
    }
    return false;
  }

  void dispose() {
    _networkStatusController.close();
  }
}
