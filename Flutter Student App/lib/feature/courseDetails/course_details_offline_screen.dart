import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_app_bar.dart';
import 'package:opencentric_lms/components/loading_indicator.dart';
import 'package:opencentric_lms/controller/auth_controller.dart';

import 'package:opencentric_lms/feature/courseDetails/widgets/course_features.dart';
import 'package:opencentric_lms/feature/courseDetails/widgets/course_overview.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../controller/course_detail_offline_controller.dart';
import '../../data/model/common/course.dart';
import '../../data/model/course_detail/features.dart';
import 'widgets/course_curriculum_offline.dart';

class CourseDetailsOfflineScreen extends StatefulWidget {
  const CourseDetailsOfflineScreen({super.key});

  @override
  State<CourseDetailsOfflineScreen> createState() =>
      _CourseDetailsOfflineScreenState();
}

class _CourseDetailsOfflineScreenState
    extends State<CourseDetailsOfflineScreen> {
  Course? course;
  bool isSelect = false;

  YoutubePlayerController? _controller;

  @override
  void initState() {
    course = Get.arguments;
    if (course != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.find<CourseDetailOfflineController>().getLesson(course!);
      });
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        // title: 'course_details'.tr,
        titleColor: Theme.of(context).textTheme.bodyLarge?.color,
        bgColor: Theme.of(context).canvasColor,
        actions: const [
          // if (Get.find<AuthController>().isLoggedIn())
          //   IconButton(
          //     onPressed: () {},
          //     icon: SvgPicture.asset(
          //       Images.heart,
          //       colorFilter: ColorFilter.mode(
          //           Theme.of(context).textTheme.bodyLarge?.color ??
          //               Colors.white,
          //           BlendMode.srcIn),
          //     ),
          //     splashRadius: 23,
          //   ),
          // IconButton(
          //   onPressed: () {},
          //   icon: SvgPicture.asset(
          //     Images.share,
          //     colorFilter: ColorFilter.mode(
          //         Theme.of(context).textTheme.bodyLarge?.color ?? Colors.white,
          //         BlendMode.srcIn),
          //   ),
          //   splashRadius: 23,
          // ),
        ],
      ),
      body: GetBuilder<CourseDetailOfflineController>(
        builder: (controller) {
          if (course != null) {
            return mainUI(context, course!, controller);
          }
          return Container();
        },
      ),
      // bottomNavigationBar:
      //     GetBuilder<CourseDetailOfflineController>(builder: (controller) {
      //   return AnimatedContainer(
      //     duration: const Duration(milliseconds: 500),
      //     height: controller.isBottomNavVisible
      //         ? kBottomNavigationBarHeight * 2.3
      //         : 0,
      //     child: controller.isLoading || controller.courseDetail == null
      //         ? const SizedBox()
      //         : OverflowBox(
      //             minHeight: 0,
      //             maxHeight: double.infinity,
      //             alignment: Alignment.topCenter,
      //             child: ButtonSection(data: controller.courseDetail!.data)),
      //   );
      // }),
    );
  }

  Widget mainUI(BuildContext context, Course course,
      CourseDetailOfflineController controller) {
    return SingleChildScrollView(
      controller: controller.scrollController,
      physics: const ClampingScrollPhysics(),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.paddingSizeDefault),
            CourseOverView(data: course),
            const SizedBox(height: 30),
            CourseFeatures(
                feature: Features(
              totalLesson: course.fieldTotalLessons,
              totalQuiz: course.fieldTotalQuizPass,
              totalEnroll: course.fieldLearnerNumber,
            )),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            GetBuilder<CourseDetailOfflineController>(
              builder: (controller) {
                if (controller.isLoadingLesson) {
                  return const LoadingIndicator();
                }
                if (course.listSections!.isNotEmpty) {
                  return CourseCurriculumOffline(
                      sections: course.listSections ?? [],
                      controller: controller);
                }
                return Container();
              },
            ),
          ]),
    );
  }
}
