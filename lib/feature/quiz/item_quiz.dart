import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_button.dart';
import 'package:opencentric_lms/controller/quiz_controller.dart';
import 'package:opencentric_lms/data/model/quiz/quiz.dart';

import 'package:opencentric_lms/utils/styles.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/quiz/data.dart';
import '../../utils/dimensions.dart';
import 'quiz_detail_page.dart';

class ItemQuiz extends StatelessWidget {
  final DataQuiz? quiz;
  const ItemQuiz({this.quiz, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border.all(
          color:
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),
          width: 1,
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.all(
          Radius.circular(Dimensions.radiusSmall),
        ),
      ),
      child: ExpansionTile(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: Get.isDarkMode
                  ? Colors.green
                  : Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radiusSmall),
        ),
        collapsedTextColor: Get.isDarkMode
            ? Colors.grey
            : Theme.of(context).textTheme.bodyMedium?.color,
        iconColor:
            Get.isDarkMode ? Colors.green : Theme.of(context).primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                quiz?.quiz?.name ?? '',
                style:
                    robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              quiz?.quiz?.fieldStatusQuiz ?? "",
              style:
                  robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Html(
                  data: quiz?.quiz?.fieldBody ?? "",
                ),
                CustomButton(
                  buttonText: 'view_details'.tr,
                  onPressed: () async {
                    Get.find<QuizController>().dataQuiz = quiz;
                    SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.setString(
                        "dataQuiz", json.encode(quiz?.toJson()));

                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => QuizDetailScreen(quiz: quiz),
                    ));
                  },
                ),
                const SizedBox(height: 15),
              ],
            ),
          )
        ],
      ),
    );
  }
}
