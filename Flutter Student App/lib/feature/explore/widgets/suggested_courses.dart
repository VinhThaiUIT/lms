import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:opencentric_lms/data/model/explore.dart';
import 'package:opencentric_lms/feature/explore/widgets/explore_course_widget.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/styles.dart';
import '../../../data/model/common/course.dart';

class SuggestedCourses extends StatelessWidget {
  final Explore explore;
  const SuggestedCourses({super.key, required this.explore});

  @override
  Widget build(BuildContext context) {
    List<Course> courses = explore.data!.suggestedCourses!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: Dimensions.paddingSizeDefault),
          child: Text(
            'suggested_courses'.tr,
            style:
                robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),
          ),
        ),
        const SizedBox(
          height: Dimensions.paddingSizeDefault,
        ),
        SizedBox(
          height: 197,
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                    right: Dimensions.paddingSizeDefault,
                    left: index == 0 ? Dimensions.paddingSizeDefault : 0),
                child: ExploreCourseWidget(
                  course: courses.elementAt(index),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
