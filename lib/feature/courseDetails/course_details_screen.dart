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
import '../quiz/item_quiz.dart';

class CourseDetailsScreen extends StatefulWidget {
  const CourseDetailsScreen({super.key});

  @override
  State<CourseDetailsScreen> createState() => _CourseDetailsScreenState();
}

class _CourseDetailsScreenState extends State<CourseDetailsScreen>
    with RouteAware {
  Course? course;
  bool isSelect = false;
  YoutubePlayerController? _controller;

  @override
  void initState() {
    course = Get.arguments['course'];
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
    if (course != null) {
      Get.find<CourseDetailController>().getLesson(course!);
      Get.find<CourseDetailController>()
          .checkCoursePermission(course?.id.toString() ?? "");
      Get.find<QuizController>()
          .getQuizDataByCourseId(course?.id.toString() ?? "");
    }
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
          // if (Get.find<AuthController>().isLoggedIn())
          //   IconButton(
          //     onPressed: () => Get.find<WishListController>()
          //         .addToWishList(Get.arguments, 'course'),
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
          //   onPressed: () =>
          //       Get.find<CourseDetailController>().share(course?.url ?? ""),
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
      body: GetBuilder<CourseDetailController>(
        // initState: (state){
        //   Get.find<CourseDetailController>().getCourseDetail(id: Get.arguments);
        // },
        builder: (controller) {
          if (course != null) {
            return mainUI(context, course!, controller);
          }
          return Container();
        },
      ),
      // bottomNavigationBar:
      //     GetBuilder<CourseDetailController>(builder: (controller) {
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

  Widget mainUI(
      BuildContext context, Course course, CourseDetailController controller) {
    // if (course.data.videoSource == "youtube") {
    //   _controller = YoutubePlayerController(
    //       initialVideoId: YoutubePlayer.convertUrlToId(course.data.videoLink!)!,
    //       flags: const YoutubePlayerFlags(autoPlay: true, mute: false));
    // }

    return SingleChildScrollView(
      controller: controller.scrollController,
      // physics: const ClampingScrollPhysics(),
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
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault),
              child: Builder(
                builder: (context) {
                  if (course.listSections == null ||
                      (course.listSections?.isEmpty ?? true)) {
                    return Container();
                  }
                  final lesson = course.listSections![0].lessons;
                  if (lesson == null || lesson.isEmpty) {
                    return Container();
                  }
                  return Row(
                    children: [
                      Expanded(
                        child: LinearProgressIndicator(
                          value: lesson.where((e) => e.isCompleted).length /
                              lesson.length,
                          semanticsLabel: 'Linear progress indicator',
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                          '${(lesson.where((e) => e.isCompleted).length / lesson.length).toStringAsFixed(2)}%'),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: Dimensions.paddingSizeDefault),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Dimensions.paddingSizeDefault),
              child: GetBuilder<QuizController>(
                init: Get.find<QuizController>(),
                builder: (controller) {
                  if (controller.isDataLoading) {
                    return Container();
                  }
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: controller.quizModel?.data.length ?? 0,
                      itemBuilder: (context, index) {
                        final quiz = controller.quizModel?.data[index];
                        if (quiz != null) {
                          return ItemQuiz(quiz: quiz);
                        } else {
                          return Container(); // or handle the null case appropriately
                        }
                      });
                },
              ),
            ),

            const SizedBox(height: Dimensions.paddingSizeDefault),
            // CourseInstructor(
            //     title: 'course_instructor',
            //     instructors: course.data.instructors!),
            // const SizedBox(height: Dimensions.paddingSizeDefault),
            // //course curriculum
            GetBuilder<CourseDetailController>(
              builder: (controller) {
                if (controller.isLoadingLesson ||
                    controller.isHavePermissionLesson == null) {
                  return const LoadingIndicator();
                }
                if (controller.isHavePermissionLesson == true &&
                    course.listSections!.isNotEmpty) {
                  return CourseCurriculum(
                      sections: course.listSections ?? [],
                      controller: controller);
                }
                return Container();
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
