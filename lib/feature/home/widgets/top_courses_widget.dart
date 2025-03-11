import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:opencentric_lms/components/title_view.dart';
import 'package:opencentric_lms/utils/dimensions.dart';

import '../../../data/model/common/course.dart';

class TopCourseWidget extends StatelessWidget {
  final List<Course> list;
  const TopCourseWidget({super.key, required this.list});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: Dimensions.paddingSizeSmall,
        ),
        TitleView(title: 'top_courses'.tr, isViewAllEnabled: false),
        const SizedBox(
          height: Dimensions.paddingSizeDefault,
        ),
        // SizedBox(
        //   height: 225,
        //   child: ListView.builder(
        //     scrollDirection: Axis.horizontal,
        //     itemCount: 3,
        //     itemBuilder: (context, index) {
        //       return Padding(
        //         padding: EdgeInsets.only(
        //             right: Dimensions.paddingSizeDefault,
        //             left: index == 0 ? Dimensions.paddingSizeDefault : 0),
        //         child: CourseWidget(course: list.elementAt(index)),
        //       );
        //     },
        //   ),
        // )
      ],
    );
  }
}
