import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/loading_indicator.dart';
import 'package:opencentric_lms/config.dart';
import 'package:opencentric_lms/feature/forum/pdf_viewer_screen.dart';
import 'package:opencentric_lms/feature/quiz/widget/time_line.dart';

import '../../components/custom_app_bar.dart';
import '../../components/custom_button.dart';
import '../../controller/quiz_controller.dart';
import '../../core/helper/route_helper.dart';
import '../../data/model/quiz/questions.dart';
import '../../data/model/quiz/quiz.dart';
import '../../data/model/quiz/quiz_result.dart';
import '../../utils/dimensions.dart';
import '../../utils/images.dart';
import '../../utils/styles.dart';
import 'quiz_start_page.dart';
import 'widget/labeled_checkbox.dart';
import 'widget/labeled_radio_button.dart';
import 'widget/short_question_widget.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class QuizResultScreen extends StatefulWidget {
  const QuizResultScreen({super.key});

  @override
  State<QuizResultScreen> createState() => _QuizResultScreenState();
}

class _QuizResultScreenState extends State<QuizResultScreen> {
  List<GivenAnswer> givenAnswerList = [];
  List<Questions> questionsList = [];
  List<bool> ansList = [];
  QuizResult? quizResult;

  @override
  void initState() {
    super.initState();
    Get.find<QuizController>().updateResultLoadingTrue();
    givenAnswerList.clear();
    questionsList.clear();
    ansList.clear();
    if (Get.arguments != null) {
      givenAnswerList = Get.arguments as List<GivenAnswer>;
    }
    for (var ans in givenAnswerList) {
      questionsList.add(ans.question);
      //printLog("----selected index: ${ans.selectedIndexes}");
    }
    Get.find<QuizController>().lmsGetQuizResult().then((value) {
      quizResult = Get.find<QuizController>().quizResult;
      final listCorrect = quizResult?.fieldQuestionsResponse ?? [];
      for (int i = 0; i < listCorrect.length; i++) {
        if (listCorrect[i].answer.isNotEmpty) {
          final answer = listCorrect[i].answer.first;
          final index = givenAnswerList[i]
              .question
              .option
              ?.indexWhere((e) => e.id == answer);
          if (index != null && index != -1) {
            givenAnswerList[i].selectedIndexes = [index];
            final indexRight = givenAnswerList[i].question.correctAnswerIndex;
            if (index == indexRight?.first) {
              ansList.add(true);
            } else {
              ansList.add(false);
            }
          }
        } else {
          ansList.add(false);
        }

        //printLog("----selected index: ${ans.selectedIndexes}");
      }
      Get.find<QuizController>().updateResultLoadingFalse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(Get.size.width, Get.statusBarHeight),
          child: GetBuilder<QuizController>(builder: (controller) {
            return controller.isDataResultLoading == true
                ? AppBar()
                : appBar(
                    context,
                    controller.dataQuiz!.quiz!,
                  );
          })),
      body: GetBuilder<QuizController>(builder: (controller) {
        return controller.isDataResultLoading == true
            ? const LoadingIndicator()
            : mainUI(context);
      }),
    );
  }

  Widget appBar(BuildContext context, Quiz quiz) {
    return CustomAppBar(
      title: quiz.name,
      centerTitle: true,
      isBackButtonExist: false,
    );
  }

  Widget mainUI(BuildContext context) {
    return Column(
      children: [
        informationSection(context),
        Expanded(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              const SizedBox(
                height: Dimensions.paddingSizeDefault,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: Dimensions.paddingSizeSmall),
                child: Column(
                  children: [
                    Timeline(
                      lineColor: Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(0.06),
                      indicators: indicatorList(),
                      style: PaintingStyle.stroke,
                      children: questionListWidgets(),
                    ),
                    if (quizResult?.fieldResult == "Passed")
                      PDFViewerScreen(
                        fileName: "certi",
                        pdfUrl: quizResult?.urlDownload ?? "",
                      ),
                    Padding(
                      padding: const EdgeInsets.all(7.0),
                      child: CustomButton(
                        onPressed: () {
                          Get.back();
                          Get.back();
                        },
                        buttonText: 'continue_course'.tr,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  bool isUserPassed(Quiz quiz) {
    int passMark = quiz.passMarks ?? 0;
    int totalMarks = quiz.totalMarks ?? 0;
    int totalQuestion = questionsList.length;
    double perQuestionMark = totalMarks / totalQuestion;
    double userObtainedMarks = 0;
    for (var ans in givenAnswerList) {
      if (ans.isCorrect ||
          ans.question.questionType == QuestionType.shortQuestion) {
        userObtainedMarks = userObtainedMarks + perQuestionMark;
      }
    }
    return userObtainedMarks >= passMark;
  }

  double calculateTotalMarks(Quiz quiz) {
    int totalMarks = quiz.totalMarks ?? 0;
    int totalQuestion = questionsList.length;
    double perQuestionMark = totalMarks / totalQuestion;
    double userObtainedMarks = 0;
    for (var ans in givenAnswerList) {
      if (ans.isCorrect ||
          ans.question.questionType == QuestionType.shortQuestion) {
        userObtainedMarks = userObtainedMarks + perQuestionMark;
      }
    }
    return userObtainedMarks;
  }

  String resultText(Quiz quiz) => isUserPassed(quiz)
      ? "Congratulation ! you have passed the quiz exam"
      : "Sorry, You have failed the quiz exam";

  Widget informationSection(BuildContext context) {
    return GetBuilder<QuizController>(builder: (controller) {
      return Container(
        height: 148,
        width: MediaQuery.of(context).size.width,
        color: Theme.of(context).primaryColor.withOpacity(0.06),
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textTitle(
                  title: resultText(controller.dataQuiz!.quiz!),
                  style: robotoRegular.copyWith(
                    color: Theme.of(context).textTheme.bodyLarge!.color!,
                    fontSize: Dimensions.fontSizeSmall,
                  ),
                ),
                const SizedBox(height: Dimensions.paddingSizeSmall),
                headerUI(controller.dataQuiz?.quiz, context),
              ],
            ),
            SizedBox(
              height: 148,
              width: 100,
              child: SvgPicture.asset(Images.quizBackRound),
            )
          ],
        ),
      );
    });
  }

  Widget questionItemMCQ(Questions question, int index) => SizedBox(
      width: 290,
      child: LabeledCheckbox(
        question: question,
        isCorrectAnsSelected: (bool value) {},
        isClickable: false,
        resultIndexes: givenAnswerList[index].selectedIndexes,
      ));

  Widget questionItemDefault(Questions question, int index) => SizedBox(
      width: 290,
      child: LabeledRadioButton(
        question: question,
        isCorrectAnsSelected: (bool value) {},
        isClickable: false,
        indexRight: givenAnswerList[index].question.correctAnswerIndex?.first,
        resultIndex: givenAnswerList[index].selectedIndexes.firstWhere(
          (e) => e != -1,
          orElse: () {
            return -1;
          },
        ),
      ));

  Widget textTitle({required String title, required TextStyle style}) {
    return Text(
      title,
      style: style,
    );
  }

  headerUI(Quiz? quiz, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customContainer(
          title: quizResult?.fieldScore ?? "0",
          sunTitle: 'your_score'.tr,
          style: robotoSemiBold.copyWith(
            color: Theme.of(context).primaryColor,
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.w500,
          ),
          style2: robotoRegular.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color!,
            fontSize: Dimensions.fontSizeSmall,
          ),
        ),
        const SizedBox(
          width: Dimensions.paddingSizeSmall,
        ),
        customContainer(
          title: quizResult?.fieldResult ?? "",
          sunTitle: 'your_result'.tr,
          style: robotoSemiBold.copyWith(
            color: Theme.of(context).primaryColor,
            fontSize: Dimensions.fontSizeDefault,
            fontWeight: FontWeight.w500,
          ),
          style2: robotoRegular.copyWith(
            color: Theme.of(context).textTheme.bodyLarge!.color!,
            fontSize: Dimensions.fontSizeSmall,
          ),
        ),
      ],
    );
  }

  Widget customContainer(
      {required String title,
      required String sunTitle,
      required TextStyle style,
      required TextStyle style2}) {
    return Container(
      width: 100,
      height: 55,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Theme.of(context).cardColor),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FittedBox(child: textTitle(title: title, style: style)),
            FittedBox(child: textTitle(title: sunTitle, style: style2)),
          ],
        ),
      ),
    );
  }

  String formatTime(int seconds) {
    return '${(Duration(seconds: seconds))}'.split('.')[0].padLeft(8, '0');
  }

  List<Widget> indicatorList() {
    //auto pass for short question widget
    // and check other question type
    return List.generate(
        ansList.length,
        (index) =>
            questionsList[index].questionType == QuestionType.shortQuestion
                ? indicatorItem(true)
                : indicatorItem(ansList[index]));
  }

  Widget indicatorItem(bool isCorrectAnswer) => isCorrectAnswer
      ? CircleAvatar(
          backgroundColor: Colors.green,
          child: SvgPicture.asset(
            Images.successful,
            height: 11,
            colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColorLight, BlendMode.srcIn),
          ),
        )
      : CircleAvatar(
          backgroundColor: Colors.red,
          child: SvgPicture.asset(
            Images.cancel,
            height: 11,
            colorFilter: ColorFilter.mode(
                Theme.of(context).primaryColorLight, BlendMode.srcIn),
          ),
        );

  List<Widget> questionListWidgets() => List.generate(
      questionsList.length,
      (index) => questionsList.elementAt(index).questionType ==
              QuestionType.defaultQuestion
          ? questionItemDefault(questionsList.elementAt(index), index)
          : questionsList.elementAt(index).questionType == QuestionType.mcq
              ? questionItemMCQ(questionsList.elementAt(index), index)
              : questionsList.elementAt(index).questionType ==
                      QuestionType.shortQuestion
                  ? ShortQuestionWidget(
                      isDisabled: true,
                      question: questionsList.elementAt(index))
                  : const SizedBox());
}
