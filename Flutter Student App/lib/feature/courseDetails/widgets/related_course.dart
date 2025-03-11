import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/styles.dart';

import '../../../core/helper/route_helper.dart';
import '../../../data/model/common/course.dart';
import '../../../utils/images.dart';

class RelatedCourse extends StatelessWidget {
  final List<Course> courses;
  const RelatedCourse({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
          child: Text(
            'related_course'.tr,
            style:
                robotoSemiBold.copyWith(fontSize: Dimensions.fontSizeDefault),
          ),
        ),
        const SizedBox(height: Dimensions.paddingSizeDefault),
        SizedBox(
          height: 225,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.only(left: Dimensions.paddingSizeDefault),
                child: RelatedCourseWidget(
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

class RelatedCourseWidget extends StatelessWidget {
  final Course? course;
  const RelatedCourseWidget({super.key, this.course});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //Get.toNamed(RouteHelper.getCourseDetailsScreenRoute(),
        //arguments: course?.id);

        Get.offAndToNamed(RouteHelper.courseDetailsScreen,
            arguments: course?.id);
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
                child: Image.network(
                  course?.thumbnail ?? "",
                  height: containerHeight * 0.50,
                  width: containerWidth,
                  fit: BoxFit.fitHeight,
                  filterQuality: FilterQuality.high,
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
                              SvgPicture.asset(
                                Images.profileSmall,
                                colorFilter: ColorFilter.mode(
                                    Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .color!
                                        .withOpacity(.6),
                                    BlendMode.srcIn),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                "${course?.totalLessons ?? 0}",
                                style: robotoRegular.copyWith(
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
                          "${course?.price}",
                          style: robotoRegular.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w600,
                              fontSize: Dimensions.fontSizeSmall),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(Images.starFill),
                            const SizedBox(
                              width: Dimensions.paddingSizeExtraSmall,
                            ),
                            Text(
                              course?.totalRating ?? "0.0",
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
