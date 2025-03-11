import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_button_notification.dart';
import 'package:opencentric_lms/controller/forum_controller.dart';
import 'package:opencentric_lms/controller/my_course_controller.dart';
import 'package:opencentric_lms/controller/my_course_offline_controller.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';
import 'package:opencentric_lms/components/header_form_widget.dart';
import '../components/loading_indicator.dart';
import '../utils/dimensions.dart';
import 'my_course_widget_new.dart';

class TrainingCourseScreen extends StatefulWidget {
  final VoidCallback callback;
  const TrainingCourseScreen({super.key, required this.callback});

  @override
  State<TrainingCourseScreen> createState() => _TrainingCourseScreenState();
}

class _TrainingCourseScreenState extends State<TrainingCourseScreen> {
  List listMyCourseOffline = [];
  List listMyCourse = [];
  // String status = "";
  // bool isDownloaded = false;
  final ScrollController _scrollController = ScrollController();
  final MyCourseOfflineController _controller = MyCourseOfflineController();
  final expansionKey = GlobalKey();

  @override
  void initState() {
    listMyCourse = Get.find<MyCourseController>().myCourseList;
    if (listMyCourse.isEmpty) {
      Get.find<MyCourseController>().getMyCourseList();
    }
    Get.find<ForumController>().getForum();
    Get.find<MyCourseOfflineController>().getMyCourseList();
    listMyCourseOffline = Get.find<MyCourseOfflineController>()
        .myCourseOfflineList
        .map((e) => e.id)
        .toList();

    _controller.getMyCourseList();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffEEF9FC),
        body: GetBuilder<MyCourseController>(builder: (controller) {
          if (controller.myCourseList.isEmpty) {
            return const LoadingIndicator();
          }
          return SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(Dimensions.paddingSizeExtraLarge),
              child: Column(
                children: [
                  customCourseViewHeader(),
                  ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.myCourseList.length,
                      itemBuilder: (context, index) {
                        return MyCourseWidgetNew(
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
                      }),
                  customForumView(),
                ],
              ),
            ),
          );
        }));
  }

  Widget customCourseViewHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimensions.paddingSizeLarge,
      children: [
        HeaderFormWidget(avatarBg: Theme.of(context).primaryColorLight),
        TextButton.icon(
          onPressed: widget.callback,
          icon: const Icon(Icons.arrow_back_ios_new_outlined),
          label: Text(
            'Home',
            style: Theme.of(context)
                .textTheme
                .titleSmall
                ?.copyWith(fontWeight: FontWeight.normal),
          ),
        ),
        Text(
          'Courses',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        CustomButtonNotification(
          buttonText: 'Notifications',
          notifications: List.filled(5, 'notification'),
          btnColor: const Color(0xffCEE3E5),
          expandColor: Theme.of(context).primaryColor,
          alert: false,
        ),
      ],
    );
  }

  Widget customForumView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimensions.paddingSizeDefault,
      children: [
        Text(
          'Discussion forum',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        CustomButtonNotification(
          buttonText: 'Replies to posts',
          notifications: List.filled(5, 'notification'),
          btnColor: const Color(0xffCEE3E5),
          alert: false,
          expandColor: null,
        ),
        ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: Get.find<ForumController>().listForum.length,
            itemBuilder: (context, index) {
              final item = Get.find<ForumController>().listForum[index];
              bool isParent = item.parents == "0";
              return Card(
                margin: const EdgeInsets.only(
                    bottom: Dimensions.paddingSizeDefault),
                child: Padding(
                  padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      IconButton.filledTonal(
                        onPressed: () {
                          if (!isParent) {
                            Get.toNamed(RouteHelper.forumDetail, arguments: {
                              'forum_id': item.id,
                              'forum_name': item.name,
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.arrow_forward_ios_rounded,
                        ),
                        style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFCEE3E5)),
                      )
                    ],
                  ),
                ),
              );
            }),
      ],
    );
  }

}
