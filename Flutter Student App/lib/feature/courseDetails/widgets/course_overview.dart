import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/styles.dart';
import '../../../data/model/common/course.dart';

class CourseOverView extends StatelessWidget {
  final Course data;
  const CourseOverView({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: Dimensions.paddingSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(data.courseName ?? "",
              style: robotoSemiBold.copyWith(
                  fontSize: Dimensions.fontSizeDefault)),
          const SizedBox(height: Dimensions.paddingSizeDefault),
          Html(
            data: data.fieldShortDescription ?? "",
            style: {
              "p": Style(
                fontSize: FontSize.medium,
              ),
            },
          ),
        ],
      ),
    );
  }
}
