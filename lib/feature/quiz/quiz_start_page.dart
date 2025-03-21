import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_app_bar.dart';
import 'package:opencentric_lms/components/custom_snackbar.dart';
import 'package:opencentric_lms/components/loading_indicator.dart';
import 'package:opencentric_lms/controller/quiz_controller.dart';
import 'package:opencentric_lms/core/helper/help_me.dart';
import 'package:opencentric_lms/data/model/quiz/data.dart';
import 'package:opencentric_lms/data/model/quiz/questions.dart';
import 'package:opencentric_lms/feature/quiz/widget/labeled_checkbox.dart';
import 'package:opencentric_lms/feature/quiz/widget/labeled_radio_button.dart';
import 'package:opencentric_lms/feature/quiz/widget/short_question_widget.dart';
import 'package:opencentric_lms/feature/quiz/widget/time_line.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:opencentric_lms/utils/styles.dart';

import '../../components/custom_button.dart';
import '../../core/helper/route_helper.dart';
import '../../data/model/quiz/quiz.dart';
import '../../data/model/quiz/quiz_model.dart';

class QuizStartPage extends StatefulWidget {
  const QuizStartPage({super.key});

  @override
  QuizStartPageState createState() => QuizStartPageState();
}

class QuizStartPageState extends State<QuizStartPage> {
  List<GivenAnswer> givenAnswerList = [];
  late Timer _timer;
  late int _remainingSeconds;
  bool isFirstTime = true;

  @override
  void initState() {
    Get.find<QuizController>().updateLoadingTrue();
    final minutes =
        int.parse(Get.find<QuizController>().dataQuiz?.quiz!.duration ?? "0");
    final startTime = Get.find<QuizController>().startTime;
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    _remainingSeconds = minutes * 60 - ((currentTime - startTime!) ~/ 1000);
    Get.find<QuizController>().getListAnswer().then((value) {
      if (value != null) {
        isFirstTime = false;
        givenAnswerList = value;
      }
      Get.find<QuizController>().updateLoadingFalse();
      setState(() {});
    });

    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size(Get.size.width, Get.statusBarHeight),
          child: GetBuilder<QuizController>(builder: (controller) {
            return controller.isDataLoading == true &&
                    controller.quizModel == null
                ? AppBar()
                : appBar(context, controller.dataQuiz!.quiz!);
          })),
      body: GetBuilder<QuizController>(
        builder: (controller) {
          return controller.isQuizLoading
              ? const LoadingIndicator()
              : mainUI(context, controller.dataQuiz!);
        },
      ),
      //body: mainUI(context),
    );
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        final quiz = Get.find<QuizController>().dataQuiz;
        await Get.find<QuizController>().answerQuiz(
          DateTime.now().millisecondsSinceEpoch,
          DateTime.now().millisecondsSinceEpoch,
          quiz?.quiz?.id ?? "",
          givenAnswerList,
          () {
            Get.offAndToNamed(RouteHelper.quizResultScreen,
                arguments: givenAnswerList);
          },
        );
      }
    });
  }

  String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')} m : ${remainingSeconds.toString().padLeft(2, '0')} s';
  }

  Widget appBar(BuildContext context, Quiz quiz) {
    return CustomAppBar(
      title: quiz.name,
      centerTitle: false,
      actions: [
        Container(
          alignment: Alignment.center,
          child: Text(
            formatTime(_remainingSeconds),
            style: robotoSemiBold.copyWith(
                color: Theme.of(context).primaryColorLight,
                fontSize: Dimensions.fontSizeDefault),
          ),
        ),
        const SizedBox(width: Dimensions.paddingSizeDefault),
      ],
    );
  }

  List<Widget> indicatorList(List<Questions> questionList) {
    return List.generate(
      questionList.length,
      (index) => CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor.withOpacity(0.06),
        child: Text(
          "${index + 1}",
          style: robotoRegular.copyWith(color: Theme.of(context).primaryColor),
        ),
      ),
    );
  }

  Widget questionItemMCQ(Questions question, int index) => SizedBox(
      width: 290,
      child: LabeledCheckbox(
        question: question,
        isCorrectAnsSelected: (bool value) {
          // GivenAnswer answer = GivenAnswer(
          //     question: question, isCorrect: value, selectedIndexes: [-1]);
          // givenAnswerList[index] = answer;
        },
        selectedIndexes: (List<int>? value) {
          GivenAnswer givenAnswer = givenAnswerList[index];
          givenAnswer.selectedIndexes = value!;
          givenAnswerList[index] = givenAnswer;
          printLog(
              "-------quiz start page: ${givenAnswerList[index].selectedIndexes}");
          Get.find<QuizController>().setListAnswer(givenAnswerList);
        },
        isClickable: true,
        resultIndexes: givenAnswerList[index].selectedIndexes,
      ));

  Widget questionItemDefault(Questions question, int index) => SizedBox(
      width: 290,
      child: LabeledRadioButton(
        question: question,
        isCorrectAnsSelected: (bool value) {
          GivenAnswer answer = GivenAnswer(
              question: question, isCorrect: value, selectedIndexes: [-1]);
          givenAnswerList[index] = answer;
        },
        selectedIndex: (int? value) {
          givenAnswerList[index].selectedIndexes = [value ?? -1];
          Get.find<QuizController>().setListAnswer(givenAnswerList);
        },
        resultIndex: givenAnswerList[index].selectedIndexes.first != -1
            ? givenAnswerList[index].selectedIndexes.first
            : null,
      ));

  Widget shortQuestion(Questions question, int index) => ShortQuestionWidget(
        question: question,
        onTextChanged: (value) {
          GivenAnswer answer = GivenAnswer(
              question: question, isCorrect: true, selectedIndexes: [-1]);
          givenAnswerList[index] = answer;
        },
      );

  List<Widget> questionListWidgets(List<Questions> list) => List.generate(
      list.length,
      (index) => list.elementAt(index).questionType ==
              QuestionType.defaultQuestion
          ? questionItemDefault(list.elementAt(index), index)
          : list.elementAt(index).questionType == QuestionType.mcq
              ? questionItemMCQ(list.elementAt(index), index)
              : list.elementAt(index).questionType == QuestionType.shortQuestion
                  ? shortQuestion(list.elementAt(index), index)
                  : const SizedBox());

  Widget mainUI(BuildContext context, DataQuiz quizModel) {
    Quiz quiz = quizModel.quiz!;
    List<Questions> questionList = quizModel.questions;
    if (isFirstTime) {
      isFirstTime = false;
      givenAnswerList.clear();
      for (var question in questionList) {
        givenAnswerList.add(GivenAnswer(
            question: question,
            isCorrect: false,
            selectedIndexes: [-1],
            shortQuestionAns: ""));
      }
      Get.find<QuizController>().setListAnswer(givenAnswerList);
    }

    return Column(
      children: [
        // informationSection(context, quiz),
        if (questionList.isNotEmpty)
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
                        indicators: indicatorList(questionList),
                        style: PaintingStyle.stroke,
                        children: questionListWidgets(questionList),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(7.0),
          child: CustomButton(
            onPressed: () async {
              await Get.find<QuizController>().answerQuiz(
                DateTime.now().millisecondsSinceEpoch,
                DateTime.now().millisecondsSinceEpoch,
                quiz.id ?? "",
                givenAnswerList,
                () {
                  Get.offAndToNamed(RouteHelper.quizResultScreen,
                      arguments: givenAnswerList);
                },
              );
            },
            buttonText: 'submit'.tr,
          ),
        ),
      ],
    );
  }

  Container informationSection(BuildContext context, Quiz quiz) {
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
                title: "Minimum pass mark ${quiz.passMarks} correct answer",
                style: robotoRegular.copyWith(
                  color: Theme.of(context).textTheme.bodyLarge!.color!,
                  fontSize: Dimensions.fontSizeSmall,
                ),
              ),
              const SizedBox(height: Dimensions.paddingSizeSmall),
              headerUI(quiz, context),
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
  }

  Row headerUI(Quiz quiz, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        customContainer(
          title: '${quiz.duration} mins',
          sunTitle: 'Your time',
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
          title: "${quiz.totalMarks ?? 0}",
          sunTitle: 'total_score'.tr,
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

  Widget customButton(
      {required String title,
      required Color color,
      required TextStyle style,
      required Color color2,
      required VoidCallback onPressed}) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        width: 190.0,
        height: 44.0,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: color2),
        ),
        child: Center(
          child: textTitle(title: title, style: style),
        ),
      ),
    );
  }

  Widget textTitle({required String title, required TextStyle style}) {
    return Text(title, style: style);
  }
}

class GivenAnswer {
  final Questions question;
  final bool isCorrect;
  List<int> selectedIndexes = [];
  String? shortQuestionAns = "";
  GivenAnswer(
      {required this.question,
      required this.selectedIndexes,
      required this.isCorrect,
      this.shortQuestionAns});

  factory GivenAnswer.fromJson(Map<String, dynamic> json) {
    return GivenAnswer(
      question: Questions.fromJson(json['question']),
      isCorrect: json['isCorrect'],
      selectedIndexes: (json['selectedIndexes'] as List<dynamic>).map((e) {
        return e as int;
      }).toList(),
      shortQuestionAns: json['shortQuestionAns'],
    );
  }

  toJson() {
    return {
      'question': question.toJson(),
      'isCorrect': isCorrect,
      'selectedIndexes': selectedIndexes,
      'shortQuestionAns': shortQuestionAns
    };
  }
}
