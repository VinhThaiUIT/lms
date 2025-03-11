import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/loading_indicator.dart';
import 'package:opencentric_lms/controller/forum_controller.dart';
import 'package:opencentric_lms/controller/home_controller.dart';
import 'package:opencentric_lms/data/model/home_data_model/home_data.dart';
import 'package:opencentric_lms/feature/common/course_instructor.dart';
import 'package:opencentric_lms/feature/common/course_widget.dart';
import 'package:opencentric_lms/training/form_custom.dart';
import 'package:opencentric_lms/training/progress_report_screen.dart';
import 'package:opencentric_lms/training/training_course_screen.dart';
import 'package:opencentric_lms/feature/home/widgets/home_app_bar.dart';
import 'package:opencentric_lms/feature/home/widgets/my_course_widget.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/enum.dart';
import '../../controller/user_controller.dart';
import '../../core/helper/route_helper.dart';
import '../../utils/styles.dart';
import '../common/explore_by_category.dart';
import '../common/featured_courses_widget.dart';
import '../common/offer_courses.dart';
import '../landing/offline_landing_screen.dart';
import 'widgets/banner_view.dart';

class HomeScreen extends StatefulWidget {
  final Function() callback;
  const HomeScreen({super.key, required this.callback});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Get.find<UserController>().getUserProfile().then((value) {
      Get.find<ForumController>().saveForumOffline();
      if (Get.find<UserController>().userData?.roles == AppConstants.teacher) {
        Get.offAllNamed(RouteHelper.myCourseScreen);
      } else if (Get.find<UserController>().userData == null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MainOfflineScreen(pageIndex: 0)));
      } else {
        Get.find<HomeController>().getCourseNotPurchase();
        // _scrollController.addListener(() {
        //   if (_scrollController.position.pixels ==
        //       _scrollController.position.maxScrollExtent) {
        //     Get.find<HomeController>().paginate();
        //   }
        // });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: HomeAppBar(
        backButton: false,
        callBack: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => MainOfflineScreen(pageIndex: 0))),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            flex: 6,
            child: GetBuilder<HomeController>(
              builder: (controller) {
                if (controller.appState == AppState.loading) {
                  return const LoadingIndicator();
                }
                if (controller.appState == AppState.error) {
                  return Container();
                }
                if (controller.listMyCourse!.isNotEmpty) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: controller.listMyCourse!.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: 100,
                        height: 230,
                        child: CourseWidget(
                            course: controller.listMyCourse?[index]),
                      );
                    },
                  );
                }
                return Container();
                // : mainUI(controller, context);
              },
            ),
          ),
        ],
      )
      ),
    );
  }
  Widget mainUI(HomeController controller, BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => controller.getHomeData(),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            if (controller.homeModel != null)
              SliverToBoxAdapter(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.homeModel?.data?.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                        padding: const EdgeInsets.only(
                            //top: Dimensions.paddingSizeExtraLarge,
                            //bottom: Dimensions.paddingSizeExtraLarge,
                            ),
                        child: itemBuilderByCategory(
                            context, index, controller.homeModel!.data!));
                  },
                ),
              ),
            if (controller.latestCourseList!.isNotEmpty)
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.all(Dimensions.paddingSizeDefault),
                      child: Text(
                        'latest_courses'.tr,
                        style: robotoSemiBold.copyWith(
                            fontSize: Dimensions.fontSizeDefault),
                      ),
                    ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: Dimensions.paddingSizeDefault),
                    //   child: GridView.builder(
                    //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //       crossAxisSpacing: Dimensions.paddingSizeDefault,
                    //       mainAxisSpacing: Dimensions.paddingSizeDefault,
                    //       childAspectRatio:
                    //           ResponsiveHelper.isTab(context) ? .9 : .63,
                    //       mainAxisExtent:
                    //           ResponsiveHelper.isMobile(context) ? 225 : 260,
                    //       crossAxisCount: ResponsiveHelper.isMobile(context)
                    //           ? 2
                    //           : ResponsiveHelper.isTab(context)
                    //               ? 3
                    //               : 5,
                    //     ),
                    //     itemCount: controller.latestCourseList?.length,
                    //     physics: const NeverScrollableScrollPhysics(),
                    //     shrinkWrap: true,
                    //     itemBuilder: (BuildContext context, int index) {
                    //       return CourseWidget(
                    //           course: controller.latestCourseList![index]);
                    //     },
                    //   ),
                    // ),
                    const SizedBox(height: Dimensions.paddingSizeDefault),
                    if (controller.isLoadingMoreData == true)
                      const Padding(
                        padding: EdgeInsets.all(Dimensions.paddingSizeDefault),
                        child: Center(child: LoadingIndicator()),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget itemBuilderByCategory(BuildContext context, int index, List<HomeData> data) {
    switch (data[index].sectionType) {
      case "sliders":
        return BannerView(bannerIndex: index);
      case 'my_courses':
        return data[index].myCourses!.isNotEmpty
            ? MyCourseWidget(
                myCourseList: data[index].myCourses, callback: widget.callback)
            : const SizedBox();
      case 'categories':
        return data[index].categories!.isNotEmpty
            ? ExploreByCategoryWidget(
                title: 'categories', categoryList: data[index].categories!)
            : const SizedBox();
      // case 'top_courses':
      //   return TopCourseWidget(list: data[index].topCourses!);
      case 'instructors':
        return CourseInstructor(
            title: 'instructor', instructors: data[index].instructors!);
      case 'offer_courses':
        return OfferCourses(offeredCourses: data[index].offerCourses!);
      case 'featured_courses':
        return data[index].featuredCourses!.isNotEmpty
            ? FeaturedCourse(courseList: data[index].featuredCourses!)
            : const SizedBox();
      default:
        return const SizedBox();
    }
  
}
}


