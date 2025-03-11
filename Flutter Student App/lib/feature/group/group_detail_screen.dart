import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:opencentric_lms/utils/dimensions.dart';

import '../../components/custom_app_bar.dart';
import '../../components/loading_indicator.dart';
import '../../controller/group_controller.dart';
import '../../core/helper/route_helper.dart';
import '../../utils/styles.dart';

class GroupDetailScreen extends StatefulWidget {
  const GroupDetailScreen({super.key});

  @override
  State<GroupDetailScreen> createState() => _GroupDetailScreenState();
}

class _GroupDetailScreenState extends State<GroupDetailScreen>
    with TickerProviderStateMixin {
  String groupId = '';
  TabController? _tabController;
  @override
  void initState() {
    super.initState();
    groupId = Get.arguments['group_id'];
    Get.find<GroupController>().getGroupDetail(groupId);

    _tabController = TabController(length: 3, initialIndex: 0, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Group Detail".tr,
        bgColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: GetBuilder<GroupController>(builder: (controller) {
        if (controller.isLoadingGroupDetail) {
          return Container();
        }
        if (controller.isJoined) {
          return Container();
        }
        return TextButton(
          onPressed: () {
            if (controller.isRequest) {
              return;
            }
            Get.find<GroupController>().requestJoinGroup(groupId);
          },
          style: TextButton.styleFrom(
            backgroundColor: controller.isRequest
                ? Theme.of(context).disabledColor
                : Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(
                horizontal: Dimensions.paddingSizeDefault,
                vertical: Dimensions.paddingSizeSmall),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimensions.radiusDefault),
            ),
          ),
          child: Text(
            "Request join group".tr,
            style: robotoBold.copyWith(
              color: Theme.of(context).cardColor,
              fontSize: Dimensions.fontSizeDefault,
            ),
          ),
        );
      }),
      body: GetBuilder<GroupController>(builder: (controller) {
        if (controller.isLoadingGroupDetail) {
          return const LoadingIndicator();
        }
        return Column(children: [
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
                    Tab(text: 'View'.tr),
                    Tab(text: 'Members'.tr),
                    Tab(text: 'Nodes'.tr),
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
            children: [
              viewUI(),
              viewMembers(),
              viewNodes(),
            ],
          )),
        ]);
      }),
    );
  }

  Widget viewUI() {
    final group = Get.find<GroupController>().groupModel;
    return SingleChildScrollView(
      child: ListTile(
        title: Row(
          children: [
            const SizedBox(width: 5),
            Text(
              group?.name ?? "",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        subtitle: Html(
          data: group?.description ?? "",
        ),
      ),
    );
  }

  Widget viewMembers() {
    final group = Get.find<GroupController>().groupModel;
    return ListView.separated(
      itemCount: group?.listMember.length ?? 0,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = group?.listMember[index];

        return GestureDetector(
          onTap: () {
            Get.toNamed(RouteHelper.createDiscussion, arguments: {
              'list_user_id': [item?.id ?? ""],
            });
          },
          child: Container(
            color: Colors.white,
            child: ListTile(
              title: Text(
                item?.name ?? "",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget viewNodes() {
    final group = Get.find<GroupController>().groupModel;
    return ListView.separated(
      itemCount: group?.listForumTopic.length ?? 0,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = group?.listForumTopic[index];

        return GestureDetector(
          onTap: () {
            Get.toNamed(RouteHelper.topic, arguments: {
              'topic_id': item?.id ?? "",
              'topic_name': item?.title ?? "",
              'forum_id': item?.forumId ?? "",
            });
          },
          child: Container(
            color: Colors.white,
            child: ListTile(
              title: Text(
                item?.title ?? "",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }
}
