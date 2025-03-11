import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_app_bar.dart';
import 'package:opencentric_lms/components/loading_indicator.dart';
import 'package:opencentric_lms/controller/cart_controller.dart';
import 'package:opencentric_lms/controller/course_detail_controller.dart';
import 'package:opencentric_lms/controller/my_course_controller.dart';
import 'package:opencentric_lms/controller/user_controller.dart';
import 'package:opencentric_lms/feature/courseDetails/widgets/course_features.dart';
import 'package:opencentric_lms/feature/courseDetails/widgets/course_overview.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../components/custom_button.dart';
import '../../components/custom_snackbar.dart';
import '../../components/loading_dialog.dart';
import '../../controller/course_detail_not_purchase_controller.dart';
import '../../controller/home_controller.dart';
import '../../data/model/common/course.dart';
import '../../data/model/course_detail/features.dart';
import '../../data/model/course_not_purchased_model.dart';
import 'widgets/course_curriculum_not_purchase.dart';

class CourseDetailsNotPurchaseScreen extends StatefulWidget {
  const CourseDetailsNotPurchaseScreen({super.key});

  @override
  State<CourseDetailsNotPurchaseScreen> createState() =>
      _CourseDetailsNotPurchaseScreenState();
}

class _CourseDetailsNotPurchaseScreenState
    extends State<CourseDetailsNotPurchaseScreen> {
  Course? course;
  bool isSelect = false;

  YoutubePlayerController? _controller;

  @override
  void initState() {
    course = Get.arguments;
    if (course != null) {
      Get.find<CourseDetailNotPurchaseController>()
          .getCourseDetail(course?.id.toString() ?? "");
      Get.find<CourseDetailNotPurchaseController>()
          .lmsCheckCoursePayment(course?.id.toString() ?? "");
      Get.find<CourseDetailNotPurchaseController>()
          .checkCoursePermission(course?.id.toString() ?? "");
      Get.find<CourseDetailNotPurchaseController>()
          .checkStartCourse(course?.id.toString() ?? "");
    }
    super.initState();
  }

  @override
  void dispose() {
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
          // GetBuilder<CourseDetailNotPurchaseController>(
          //   builder: (controller) {
          //     if (controller.course != null) {
          //       return IconButton(
          //         onPressed: () => Get.find<CourseDetailController>().share(
          //           controller.course?.url ?? "",
          //         ),
          //         icon: SvgPicture.asset(
          //           Images.share,
          //           colorFilter: ColorFilter.mode(
          //               Theme.of(context).textTheme.bodyLarge?.color ??
          //                   Colors.white,
          //               BlendMode.srcIn),
          //         ),
          //         splashRadius: 23,
          //       );
          //     }
          //     return Container();
          //   },
          // ),
        ],
      ),
      body: GetBuilder<CourseDetailNotPurchaseController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const LoadingIndicator();
          }
          if (controller.course != null) {
            return mainUI(context, controller.course!, controller);
          }
          return Container();
        },
      ),
      // bottomNavigationBar:
      //     GetBuilder<CourseDetailNotPurchaseController>(builder: (controller) {
      //   return AnimatedContainer(
      //     duration: const Duration(milliseconds: 500),
      //     height: controller.isBottomNavVisible
      //         ? kBottomNavigationBarHeight * 2.3
      //         : 0,
      //   );
      // }),
    );
  }

  Widget mainUI(BuildContext context, Course course,
      CourseDetailNotPurchaseController controller) {
    // if (course.data.videoSource == "youtube") {
    //   _controller = YoutubePlayerController(
    //       initialVideoId: YoutubePlayer.convertUrlToId(course.data.videoLink!)!,
    //       flags: const YoutubePlayerFlags(autoPlay: true, mute: false));
    // }

    return Stack(
      children: [
        SingleChildScrollView(
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
                // CourseInstructor(
                //     title: 'course_instructor',
                //     instructors: course.data.instructors!),
                // const SizedBox(height: Dimensions.paddingSizeDefault),
                // //course curriculum
                GetBuilder<CourseDetailNotPurchaseController>(
                  builder: (controller) {
                    if (controller.isLoadingLesson) {
                      return const LoadingIndicator();
                    }
                    if (course.listSections!.isNotEmpty) {
                      return CourseCurriculumNotPurchase(
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
        ),
        Builder(builder: (context) {
          if (controller.isStartCourse ?? true) {
            return Container();
          }
          bool isMembership = false;
          if (Get.find<UserController>().userData?.roles ==
              AppConstants.membership) {
            isMembership = true;
          }
          if (controller.isBought || isMembership) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: CustomButton(
                  onPressed: () async {
                    LoadingDialog.show(context);
                    await Get.find<CourseDetailNotPurchaseController>()
                        .startCourse((course.id ?? 0).toString());

                    Get.find<HomeController>().getCourseNotPurchase();
                    Get.find<MyCourseController>().getMyCourseList();
                    LoadingDialog.hide(context);
                    Get.back();
                    customSnackBar("Add to my course successful",
                        isError: false);
                  },
                  buttonText: "Start course",
                ),
              ),
            );
          }
          return course.isFree ?? false
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: CustomButton(
                      onPressed: () async {
                        await Get.find<CourseDetailNotPurchaseController>()
                            .addCourse((course.id ?? 0).toString());
                        Get.find<HomeController>().getCourseNotPurchase();
                      },
                      buttonText: "Add course",
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: CustomButton(
                      onPressed: () async {
                        await Get.find<CartController>()
                            .addToCart(course.id ?? 0);
                      },
                      buttonText: "Add to cart",
                    ),
                  ),
                );
        }),
      ],
    );
  }
}
