import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/controller/my_course_offline_controller.dart';
import 'package:opencentric_lms/data/model/common/my_course_offline.dart';
import '../../core/helper/route_helper.dart';
import '../../data/model/common/course.dart';
import '../../utils/dimensions.dart';
import '../../utils/styles.dart';

class MyCourseOfflineWidgetItem extends StatelessWidget {
  final MyCourseOffline course;
  final MyCourseOfflineController controller;
  const MyCourseOfflineWidgetItem(
      {super.key, required this.course, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.paddingSizeDefault),
      child: InkWell(
        onTap: () {
          // Future.delayed(const Duration(seconds: 20), () {
          //   _startLocalServer();
          // });
          // Navigator.of(context).push(MaterialPageRoute(
          //     builder: (_) => ScormViewer(
          //         scormContentPath: 'http://127.0.0.1:8080/${course.url}')));
          Get.toNamed(RouteHelper.getCourseDetailsOfflineRoute(),
              arguments: Course.fromJson(course.course?.toJson() ?? {}));
        },
        radius: 6,
        child: Container(
          width: MediaQuery.of(context).size.width / 1.3,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .color!
                      .withOpacity(0.06)),
              borderRadius: const BorderRadius.all(Radius.circular(6))),
          child: Padding(
            padding: const EdgeInsets.all(Dimensions.paddingSizeSmall),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(6)),
                        child: SizedBox(
                            height: 60,
                            width: 60,
                            child: Image.file(
                              File(course.thumbnail ?? ''),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.error);
                              },
                            ))),
                    const SizedBox(
                      width: Dimensions.paddingSizeSmall,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 120,
                      child: Text(
                        course.title ?? '',
                        style: robotoMedium.copyWith(
                            fontSize: Dimensions.fontSizeDefault),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(
                      height: Dimensions.paddingSizeExtraSmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double calculatePercentage(String percentage) {
    return double.parse(percentage.replaceAll('%', '')) / 100;
  }
}
