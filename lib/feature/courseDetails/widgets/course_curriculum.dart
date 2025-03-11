import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/controller/quiz_controller.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/styles.dart';

import '../../../components/custom_button.dart';
import '../../../controller/course_detail_controller.dart';
import '../../../core/helper/route_helper.dart';
import '../../../data/model/common/lesson.dart';

import '../../../data/model/common/section.dart';
import '../../../data/model/quiz/quiz.dart';
import '../../quiz/quiz_detail_page.dart';

class CourseCurriculum extends StatelessWidget {
  final List<Section> sections;
  final CourseDetailController controller;
  const CourseCurriculum(
      {super.key, required this.sections, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'course_curriculum'.tr,
            style:
                robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),
          ),
          const SizedBox(
            height: Dimensions.paddingSizeDefault,
          ),
          //curriculumItem(context),
          SizedBox(
            //height: 400,
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sections.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      bottom: Dimensions.paddingSizeSmall),
                  child: curriculumItem(context, sections[index]),
                );
              },
            ),
          ),
          //const SizedBox(height: 10,),
          //foldedItem(context),
        ],
      ),
    );
  }

  Widget curriculumItem(BuildContext context, Section section) {
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
        title: Text(
          section.title ?? '',
          style: robotoMedium.copyWith(fontSize: Dimensions.fontSizeDefault),
        ),
        childrenPadding: const EdgeInsets.all(0),
        children: [
          Container(
            height: 1,
            width: MediaQuery.of(context).size.width,
            color:
                Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.06),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: section.lessons != null || section.quizes != null
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: section.lessons?.length == null
                        ? 0
                        : ((section.lessons?.length ?? 0) +
                            (section.quizes?.length ?? 0)),
                    itemBuilder: (context, index) {
                      return index >= section.lessons!.length
                          ? quizButton(
                              section.quizes![index - section.lessons!.length],
                              context)
                          : _item(context, section.lessons![index],
                              section.id.toString());
                    },
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget quizButton(Quiz quiz, BuildContext context) => CustomButton(
      onPressed: () {
        // return Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => QuizDetailScreen(quiz: quiz),
        //   ));
      },
      height: 25,
      buttonText: "Quiz");

  Widget _item(BuildContext context, Lesson lesson, String sectionID) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
            RouteHelper.getLearningScreen(
                lesson.id.toString(), lesson.title, "true"),
            arguments: lesson);
        // if (lesson.type == 'video') {
        //   controller.updateVideoUrl(
        //       false, lesson.link, 4, lesson.id.toString(), sectionID);
        // } else if (lesson.type == 'audio') {
        //   controller.openAudioPlayerDialog(lesson, sectionID);
        // } else if (lesson.type == 'doc') {
        //   _launchUrl(Uri.parse(lesson.link));
        // }
      },
      child: Padding(
        padding:
            const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width - 120,
              child: Text(lesson.title,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                  style: robotoRegular.copyWith(
                      color: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.6),
                      fontSize: Dimensions.fontSizeSmall)),
            ),
            if (lesson.isCompleted)
              Text("Done",
                  style: robotoMedium.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.fontSizeExtraSmall)),
          ],
        ),
      ),
    );
  }
}
