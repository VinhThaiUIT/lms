import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_image.dart';
import 'package:opencentric_lms/config.dart';
import 'package:opencentric_lms/core/helper/help_me.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';
import 'package:opencentric_lms/data/model/course_not_purchased_model.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:opencentric_lms/utils/styles.dart';

import '../../data/model/common/course.dart';

class CourseWidget extends StatelessWidget {
  final Course? course;
  const CourseWidget({super.key, this.course});

  @override
  Widget build(BuildContext context) {
    String fieldLanguage = course?.fieldLanguage ?? "";
    String fieldLevel = course?.fieldLevel ?? "";
    String imagePath = course?.fieldImage ?? "";
    return InkWell(
      onTap: () {
        Get.toNamed(RouteHelper.getCourseDetailsNotPurchaseScreenRoute(),
            arguments: course);
      },
      child: Container(
        width: 155,
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .color!
                    .withOpacity(0.06)),
            borderRadius: const BorderRadius.all(Radius.circular(6))),
        child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
          double containerHeight = constraints.maxHeight;
          double containerWidth = constraints.maxWidth;

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(6),
                  topRight: Radius.circular(6),
                ),
                child: CustomImage(
                  image: imagePath,
                  height: containerHeight * 0.60,
                  width: containerWidth,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course?.title ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.start,
                      style: robotoMedium.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          fontSize: Dimensions.fontSizeSemiSmall),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: Dimensions.paddingSizeExtraSmall),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                Images.playSmall,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(.6),
                                    BlendMode.srcIn),
                              ),
                              const SizedBox(
                                width: Dimensions.paddingSizeMint,
                              ),
                              Text(
                                "${course?.totalLessons ?? 0} Lessons",
                                style: robotoRegular.copyWith(
                                    fontSize: Dimensions.fontSizeExtraSmall,
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(.6)),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                fieldLanguage,
                                style: robotoRegular.copyWith(
                                    color: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(.6),
                                    fontSize: Dimensions.fontSizeExtraSmall),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${course?.fieldLearnerNumber} Learners",
                          style: robotoRegular.copyWith(
                              color: Get.isDarkMode
                                  ? Colors.green
                                  : Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: Dimensions.fontSizeSmall),
                        ),
                        Row(
                          children: [
                            Text(
                              fieldLevel,
                              style: robotoRegular.copyWith(
                                  fontSize: Dimensions.fontSizeExtraSmall),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
