import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_app_bar.dart';
import 'package:opencentric_lms/components/loading_indicator.dart';
import 'package:opencentric_lms/controller/course_detail_controller.dart';
import 'package:opencentric_lms/controller/quiz_controller.dart';
import 'package:opencentric_lms/feature/courseDetails/widgets/course_curriculum.dart';
import 'package:opencentric_lms/feature/courseDetails/widgets/course_features.dart';
import 'package:opencentric_lms/feature/courseDetails/widgets/course_overview.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../data/model/common/course.dart';
import '../../data/model/course_detail/features.dart';
import '../../main.dart';
import '../controller/my_course_controller.dart';
// import '../quiz/item_quiz.dart';

class LessonBrowser extends StatefulWidget {
  const LessonBrowser({super.key});

  @override
  State<LessonBrowser> createState() => _LessonBrowserState();
}

class _LessonBrowserState extends State<LessonBrowser>
    with RouteAware {
  // List<Course?> course;
  Course? course;
  bool isSelect = false;
  YoutubePlayerController? _controller;

  MyCourseController myCourseController = Get.find<MyCourseController>();

  @override
  void initState() {
    if(myCourseController.myCourseList.isEmpty) {
      myCourseController.getMyCourseList();
    }
    // course = Get.arguments['course'];
    if (course != null) {
      Get.find<CourseDetailController>().getLesson(course!);
      Get.find<CourseDetailController>()
          .checkCoursePermission(course?.id.toString() ?? "");
      Get.find<QuizController>()
          .getQuizDataByCourseId(course?.id.toString() ?? "");
    }

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void didPopNext() {
    // Reload data when the screen is popped back to

    // if (course != null) {
    //   Get.find<CourseDetailController>().getLesson(course!);
    //   Get.find<CourseDetailController>()
    //       .checkCoursePermission(course?.id.toString() ?? "");
    //   Get.find<QuizController>()
    //       .getQuizDataByCourseId(course?.id.toString() ?? "");
    // }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    Get.find<CourseDetailController>().stopVideoPlayer();
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

        ],
      ),
      body: GetBuilder<CourseDetailController>(
        // initState: (state){
        //   Get.find<CourseDetailController>().getCourseDetail(id: Get.arguments);
        // },
        builder: (controller) {
          // if (course != null) {
          //   return mainUI(context, course!, controller);
          // }
          // return Container();
          return ListView.builder(
            itemCount: myCourseController.myCourseList.length,
              itemBuilder: (context, index){
              Course course = Course.fromJson(myCourseController.myCourseList[index].toJson());
                return mainUI(context, course, controller);

          });
        },
      ),

    );
  }

  Widget mainUI(
      BuildContext context, Course course, CourseDetailController controller) {


    return SingleChildScrollView(
      controller: controller.scrollController,
      // physics: const ClampingScrollPhysics(),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Dimensions.paddingSizeDefault),
            // CourseInstructor(
            //     title: 'course_instructor',
            //     instructors: course.data.instructors!),
            // const SizedBox(height: Dimensions.paddingSizeDefault),
            // //course curriculum
            GetBuilder<CourseDetailController>(
              builder: (controller) {
                // if (controller.isLoadingLesson ||
                //     controller.isHavePermissionLesson == null) {
                //   return const LoadingIndicator();
                // }
                // if (controller.isHavePermissionLesson == true &&
                //     course.listSections!.isNotEmpty) {
                //   return CourseCurriculum(
                //       sections: course.listSections ?? [],
                //       controller: controller);
                // }
                // return Container();
                return CourseCurriculum(
                    sections: course.listSections ?? [],
                    controller: controller);
              },
            ),

            // SizedBox(
            //     height: course.data.sections!.isNotEmpty
            //         ? Dimensions.paddingSizeDefault
            //         : 0),
            // if (course.data.resources?.isAudioAvailable == true ||
            //     course.data.resources?.isDocAvailable == true ||
            //     course.data.resources?.isVideoAvailable == true)
            //   CourseResource(resource: course.data.resources!),
            // SizedBox(
            //     height: course.data.resources?.isAudioAvailable == true ||
            //             course.data.resources?.isDocAvailable == true ||
            //             course.data.resources?.isVideoAvailable == true
            //         ? Dimensions.paddingSizeDefault
            //         : 0),
            // CourseReview(
            //     courseId: course.data.id!,
            //     totalReview: course.data.totalReviews ?? 0,
            //     avgRatings: course.data.avgRatings ?? "0.0",
            //     isReviewed: course.data.isReviewed ?? false,
            //     isCanReview: course.data.canReview ?? false),
            // const SizedBox(height: Dimensions.paddingSizeDefault),
            // if (course.data.relatedCourses!.isNotEmpty)
            //   RelatedCourse(courses: course.data.relatedCourses!),
            // SizedBox(
            //     height: course.data.relatedCourses!.isNotEmpty
            //         ? Dimensions.paddingSizeExtraLarge
            //         : 0),
            // if (course.data.faqs!.isNotEmpty)
            //   FrequentlyAskQuestion(faqList: course.data.faqs!),
            // SizedBox(
            //     height: course.data.faqs!.isNotEmpty
            //         ? Dimensions.paddingSizeDefault
            //         : 0),
            // //organization section
            // if (course.data.organization != null)
            //   OrganizationWidget(organization: course.data.organization!),
            // const SizedBox(height: Dimensions.paddingSizeDefault),
          ]),
    );
  }
}
