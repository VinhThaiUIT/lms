import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:opencentric_lms/data/model/explore.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/styles.dart';
import 'package:opencentric_lms/feature/explore/widgets/explore_course_widget.dart';
import '../../../data/model/common/course.dart';

class FreeCourses extends StatelessWidget {
  final Explore explore;
  const FreeCourses({super.key, required this.explore});

  @override
  Widget build(BuildContext context) {
    List<Course> courses = explore.data!.freeCourses!;
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'free_course'.tr,
            style:
                robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),
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
                  padding: const EdgeInsets.only(
                      right: Dimensions.paddingSizeDefault),
                  child: ExploreCourseWidget(
                    course: courses.elementAt(index),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
