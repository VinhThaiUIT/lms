import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/loading_indicator.dart';
import 'package:opencentric_lms/controller/my_course_controller.dart';
import 'package:opencentric_lms/feature/common/my_course_widget_item.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';

import '../../../controller/my_course_offline_controller.dart';
import '../../../utils/styles.dart';

class PurchaseCourseList extends StatefulWidget {
  const PurchaseCourseList({super.key});

  @override
  State<PurchaseCourseList> createState() => _PurchaseCourseListState();
}

class _PurchaseCourseListState extends State<PurchaseCourseList> {
  final ScrollController _scrollController = ScrollController();
  final MyCourseOfflineController _controller = MyCourseOfflineController();
  @override
  void initState() {
    super.initState();
    _controller.getMyCourseList();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     Get.find<MyCourseController>().paginatePurchaseCourse();
    //   }
    // });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MyCourseController>(
        initState: (state) => Get.find<MyCourseController>().getMyCourseList(),
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeSmall),
            child: controller.isMyCourseLoading
                ? const LoadingIndicator()
                : controller.myCourseList.isEmpty
                    ? Center(
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            Images.emptyCourse,
                            scale: 3,
                          ),
                          Text('you_dont_have_any_purchased_course'.tr,
                              style: robotoRegular),
                        ],
                      ))
                    : mainUI(controller),
          );
        });
  }

  Widget mainUI(MyCourseController controller) {
    return RefreshIndicator(
      onRefresh: () => controller.getMyCourseList(),
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return MyCourseWidgetItem(
                  course: controller.myCourseList[index],
                  offlineCourse: _controller.myCourseOfflineList,
                  controller: controller,
                  url: index == 0
                      ? "https://uithcm-my.sharepoint.com/personal/17521196_ms_uit_edu_vn/_layouts/15/download.aspx?UniqueId=964d5dfb-2b3d-4a8e-843e-9302f5359b02"
                      : index == 1
                          ? "https://uithcm-my.sharepoint.com/personal/17521196_ms_uit_edu_vn/_layouts/15/download.aspx?UniqueId=0cfb4767-f024-455a-bb06-465c7b817908"
                          : index == 2
                              ? "https://uithcm-my.sharepoint.com/personal/17521196_ms_uit_edu_vn/_layouts/15/download.aspx?UniqueId=3adfbdc8-9988-4e4e-93c9-8fe19f2c2212"
                              : "");
            }, childCount: controller.myCourseList.length),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: Dimensions.paddingSizeDefault),
          ),
          if (controller.isMyCourseLoadingMore == true)
            const SliverToBoxAdapter(
              child: LoadingIndicator(),
            )
        ],
      ),
    );
  }
}
