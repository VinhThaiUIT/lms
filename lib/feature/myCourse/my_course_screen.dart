import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_app_bar.dart';
import 'package:opencentric_lms/controller/user_controller.dart';
import 'package:opencentric_lms/feature/myCourse/widgets/downloaded_course_list.dart';
import 'package:opencentric_lms/feature/myCourse/widgets/purchase_course_list.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/styles.dart';
import '../../controller/theme_controller.dart';
import '../../utils/images.dart';
import '../profile/widgets/user_logout.dart';

class MyCourseScreen extends StatefulWidget {
  const MyCourseScreen({super.key});

  @override
  State<MyCourseScreen> createState() => _MyCourseScreenState();
}

class _MyCourseScreenState extends State<MyCourseScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  bool isTeacher = false;

  @override
  void initState() {
    super.initState();
    if (Get.find<UserController>().userData?.roles == AppConstants.teacher) {
      isTeacher = true;
    }
    _tabController = TabController(length: 2, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onBackPressed: isTeacher
            ? () {
                Get.bottomSheet(const UserLogout(),
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true);
              }
            : null,
        isBackButtonExist: isTeacher ? true : false,
        title: 'my_course'.tr,
        centerTitle: true,
        actions: [
          isTeacher
              ? GestureDetector(
                  onTap: () {
                    Get.find<ThemeController>().toggleTheme();
                  },
                  child: SvgPicture.asset(
                    Images.darkMode,
                    colorFilter: ColorFilter.mode(
                        Get.isDarkMode
                            ? Theme.of(context).primaryColor
                            : Theme.of(context).primaryColorLight,
                        BlendMode.srcIn),
                  ),
                )
              : const SizedBox(),
        ],
        bgColor: null,
      ),
      body: Column(children: [
        const SizedBox(
          height: Dimensions.paddingSizeLarge,
        ),
        Padding(
          padding: const EdgeInsets.only(
              left: Dimensions.paddingSizeSmall,
              right: Dimensions.paddingSizeSmall),
          child: Container(
            height: 40,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.05),
                borderRadius: const BorderRadius.all(
                    Radius.circular(Dimensions.radiusSmall))),
            child: Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeExtraSmall),
              child: TabBar(
                isScrollable: true,
                controller: _tabController,
                indicatorColor: Theme.of(context).primaryColor,
                indicator: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                        Radius.circular(Dimensions.radiusSmall)),
                    color: Theme.of(context).primaryColor),
                indicatorSize: TabBarIndicatorSize.tab,
                padding: const EdgeInsets.only(left: 40),
                indicatorPadding: EdgeInsets.zero,
                labelColor: Get.isDarkMode
                    ? Theme.of(context).textTheme.bodyMedium?.color
                    : Theme.of(context).cardColor,
                unselectedLabelColor: Theme.of(context).primaryColor,
                unselectedLabelStyle: robotoRegular.copyWith(
                  color: Theme.of(context).primaryColor,
                  fontSize: Dimensions.fontSizeSmall,
                ),
                automaticIndicatorColorAdjustment: true,
                labelStyle: robotoBold.copyWith(
                  color: Theme.of(context).cardColor,
                  fontSize: Dimensions.fontSizeSmall,
                ),
                tabs: [
                  Tab(text: 'my_course'.tr),
                  // Tab(text: 'wishlist'.tr),
                  Tab(text: 'downloaded'.tr),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: Dimensions.paddingSizeDefault,
        ),
        Expanded(
            child: TabBarView(
          controller: _tabController,
          children: const [
            PurchaseCourseList(),
            // WishListCourse(),
            DownloadedCourseList(),
          ],
        )),
      ]),
    );
  }
}
