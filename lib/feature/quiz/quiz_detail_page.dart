import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_button.dart';
import 'package:opencentric_lms/controller/quiz_controller.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';

import 'package:opencentric_lms/utils/styles.dart';

import '../../data/model/quiz/data.dart';
import '../../data/model/quiz/quiz.dart';

class QuizDetailScreen extends StatelessWidget {
  final DataQuiz? quiz;
  const QuizDetailScreen({this.quiz, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('quiz'.tr),
        titleSpacing: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              quiz?.quiz?.name ?? '',
              style: robotoRegular.copyWith(fontSize: 14),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "• ${"question_count".tr}: ${quiz?.questions.length}",
                style: robotoRegular.copyWith(
                  fontSize: 14,
                  color: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .color!
                      .withOpacity(0.6),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "• Time limit (minutes): ${quiz?.quiz?.duration}",
                style: robotoRegular.copyWith(
                  fontSize: 14,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.6),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "• Threshold (%): ${quiz?.quiz?.fieldThreshold}",
                style: robotoRegular.copyWith(
                  fontSize: 14,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.6),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "• Take quiz number: ${quiz?.quiz?.takeQuizNumber}",
                style: robotoRegular.copyWith(
                  fontSize: 14,
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.6),
                ),
              ),
            ),
            const Spacer(),
            CustomButton(
              buttonText: 'start_quiz'.tr,
              onPressed: () async {
                Get.find<QuizController>().duration =
                    int.tryParse(quiz?.quiz?.duration ?? "0") ?? 0;
                final value = await Get.find<QuizController>().startQuiz(
                    int.tryParse(quiz?.quiz?.duration ?? "0") ?? 0,
                    quiz?.quiz?.id ?? '');
                if (value) {
                  return Get.toNamed(RouteHelper.quizStartPage,
                      arguments: quiz);
                } else {
                  final givenAnswerList =
                      await Get.find<QuizController>().getListAnswer();
                  await Get.find<QuizController>().answerQuiz(
                      DateTime.now().millisecondsSinceEpoch,
                      DateTime.now().millisecondsSinceEpoch,
                      quiz?.quiz?.id ?? "",
                      givenAnswerList ?? [], () {
                    Get.offAndToNamed(RouteHelper.quizResultScreen,
                        arguments: givenAnswerList);
                  });
                }
              },
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
