import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/controller/my_course_controller.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';
import 'package:opencentric_lms/data/model/common/course.dart';
import '../../data/model/common/lms_my_course.dart';
import '../../data/model/common/my_course_offline.dart';
import '../../utils/dimensions.dart';

class MyCourseWidgetNew extends StatefulWidget {
  final LMSMyCourseModel course;
  final List<MyCourseOffline> offlineCourse;
  final MyCourseController controller;
  final String url;
  const MyCourseWidgetNew(
      {super.key,
        required this.course,
        required this.offlineCourse,
        required this.controller,
        required this.url,
      });

  @override
  State<MyCourseWidgetNew> createState() => _MyCourseWidgetItemNewState();
}

class _MyCourseWidgetItemNewState extends State<MyCourseWidgetNew> {
  String status = "";
  List listMyCourseOffline = [];
  bool isDownloaded = false;
  @override
  void initState() {
    isDownloaded = widget.offlineCourse
        .where((e) => e.title == widget.course.courseName)
        .isNotEmpty;


    super.initState();
  }
  @override
  void didChangeDependencies() {
    isDownloaded = widget.offlineCourse
        .where((e) => e.title == widget.course.courseName)
        .isNotEmpty;
    super.didChangeDependencies();
  }

  void setStatus(String s) {
    setState(() {
      status = s;
    });
  }

  @override
  Widget build(BuildContext context) {
    return customCourse(widget.course, widget.controller);
  }

  double calculatePercentage(String percentage) {
    return double.parse(percentage.replaceAll('%', '')) / 100;
  }

  Widget customCourse(LMSMyCourseModel myCourse, MyCourseController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Dimensions.paddingSizeDefault),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.3,
        // constraints:
        // const BoxConstraints(minWidth: 160, maxHeight: double.infinity),
        margin: const EdgeInsets.symmetric(vertical: Dimensions.paddingSizeSmall),
        padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
          color: Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: Dimensions.paddingSizeDefault,
                children: [
                  Flexible(
                      child: Text(
                        myCourse.courseName!,
                        style: Theme.of(context).textTheme.titleSmall,
                      )),
                  Flexible(
                      child: Row(
                        spacing: 5,
                        children: [
                          Container(
                            constraints: const BoxConstraints(maxWidth: 70),
                            alignment: Alignment.centerLeft,
                            // color: Colors.lightGreen,
                            child: Transform.scale(
                              scale: 1.3,
                              alignment: Alignment.centerLeft,
                              child: CircularProgressIndicator(
                                color: Colors.greenAccent[100],
                                backgroundColor: Colors.black,
                                value: 0.1,
                              ),
                            ),
                          ),
                          const Text(
                            'complete',
                          ),
                        ],
                      )),
                  Flexible(
                    child: Row(
                      spacing: 5,
                      children: [
                        Container(
                          constraints: const BoxConstraints(minWidth: 70),
                          alignment: Alignment.centerLeft,
                          child: Switch(
                              value: isDownloaded,
                              onChanged: (value) {
                                value
                                  ? Get.defaultDialog(
                                  title: 'Downloading',
                                  textCancel: 'Cancel',
                                  textConfirm: 'Downloading',
                                  cancel: IconButton(
                                      onPressed: (){Get.back(closeOverlays: true);},
                                      icon: const Icon(Icons.close)),
                                  confirm: IconButton(
                                      onPressed: () {
                                        setStatus('Downloading');
                                        controller.downloadAndExtractZip(
                                            myCourse, (String status) {
                                          setStatus(status);
                                          if (status == "Done") {
                                            setState(() {
                                              isDownloaded = true;
                                            });
                                          }
                                        });
                                        Get.back(closeOverlays: true);
                                      },
                                      icon: const Icon(Icons.check)
                                  ),
                                  middleText: '',
                                )
                                : Get.defaultDialog(
                                  title: 'Remove',
                                  middleText: 'Are you sure remove offline course',
                                  cancel: IconButton(
                                      onPressed: (){Get.back(closeOverlays: true);},
                                      icon: const Icon(Icons.close)),
                                  confirm: IconButton(
                                      onPressed: (){Get.back(closeOverlays: true);},
                                      icon: const Icon(Icons.check)
                                  ),
                                );
                              }),
                        ),
                        const Flexible(
                            child: Text(
                              'Available offline',
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Flexible(
                flex: 1,
                child: IconButton.filledTonal(
                    onPressed: () {
                      // route course detail screen
                      Get.toNamed(RouteHelper.getCourseDetailsScreenRoute(),
                          arguments: {
                            'course': Course.fromJson(
                              myCourse.toJson(),
                            ),
                          });
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                    ),
                    style:  IconButton.styleFrom(
                backgroundColor: const Color(0xFFCEE3E5)
              ),
                    ))
          ],
        ),
      ),
    );
  }
}
