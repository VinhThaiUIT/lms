import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/controller/my_course_controller.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';
import 'package:opencentric_lms/data/model/common/course.dart';

import '../../components/custom_image.dart';
import '../../config.dart';
import '../../data/model/common/lms_my_course.dart';
import '../../data/model/common/my_course_offline.dart';
import '../../utils/dimensions.dart';
import '../../utils/images.dart';
import '../../utils/styles.dart';

class MyCourseWidgetItem extends StatefulWidget {
  final LMSMyCourseModel course;
  final List<MyCourseOffline> offlineCourse;
  final MyCourseController controller;
  final String url;
  const MyCourseWidgetItem(
      {super.key,
      required this.course,
      required this.offlineCourse,
      required this.controller,
      required this.url
      });

  @override
  State<MyCourseWidgetItem> createState() => _MyCourseWidgetItemState();
}

class _MyCourseWidgetItemState extends State<MyCourseWidgetItem> {
  String status = "";
  bool isDownloaded = false;
  @override
  void initState() {
    isDownloaded = widget.offlineCourse
        .where((e) => e.title == widget.course.courseName)
        .isNotEmpty;
    super.initState();
  }

  void setStatus(String s) {
    setState(() {
      status = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: InkWell(
        // onTap: () => Navigator.of(context).pushNamed(RouteHelper.learningScreen, arguments: course.id),
        onTap: () {
          Get.toNamed(RouteHelper.getCourseDetailsScreenRoute(),
              arguments: Course.fromJson(
                widget.course.toJson(),
              ));
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
                      borderRadius: const BorderRadius.all(Radius.circular(6)),
                      child: CustomImage(
                        width: 60,
                        height: 60,
                        image:
                            Config.baseUrl + (widget.course.fieldImage ?? ''),
                        placeholder: Images.placeholder,
                      ),
                    ),
                    const SizedBox(
                      width: Dimensions.paddingSizeSmall,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.course.courseName ?? '',
                            style: robotoMedium.copyWith(
                                fontSize: Dimensions.fontSizeDefault),
                          ),
                          const SizedBox(
                            height: Dimensions.paddingSizeExtraSmall,
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "${widget.course.fieldTotalLessons} Lesson",
                                  style: robotoRegular.copyWith(
                                      fontSize: Dimensions.fontSizeExtraSmall,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .color!
                                          .withOpacity(.5)),
                                ),
                              ),
                              Expanded(
                                  flex: 2,
                                  child: Visibility(
                                    visible: widget.url != "",
                                    child: Text(
                                      status,
                                      style: robotoRegular.copyWith(
                                          fontSize:
                                              Dimensions.fontSizeExtraSmall,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyLarge!
                                              .color!
                                              .withOpacity(.5)),
                                    ),
                                  )),
                              Builder(builder: (context) {
                                if (isDownloaded) {
                                  return Container();
                                }
                                return Expanded(
                                  child: IconButton(
                                      onPressed: () {
                                        setStatus('Downloading');
                                        widget.controller.downloadAndExtractZip(
                                            widget.course, (String status) {
                                          setStatus(status);
                                          if (status == "Done") {
                                            setState(() {
                                              isDownloaded = true;
                                            });
                                          }
                                        });
                                      },
                                      icon: const Icon(
                                          Icons.file_download_outlined)),
                                );
                              })
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: Dimensions.paddingSizeExtraSmall),
                // ClipRRect(
                //   borderRadius: const BorderRadius.all(Radius.circular(10)),
                //   child: LinearProgressIndicator(
                //     value: calculatePercentage(
                //         widget.course.completedPercentage ?? "0%"),
                //     valueColor: AlwaysStoppedAnimation<Color>(Get.isDarkMode
                //         ? Colors.green.withOpacity(.5)
                //         : Theme.of(context).primaryColor.withOpacity(.5)),
                //     backgroundColor: Get.isDarkMode
                //         ? Colors.green.withOpacity(.1)
                //         : Theme.of(context).primaryColor.withOpacity(.1),
                //   ),
                // )
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
