import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:opencentric_lms/controller/chat_controller.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';

import '../../components/custom_app_bar.dart';
import '../../components/loading_indicator.dart';
import '../../data/model/conversation/chat_list.dart';

class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({super.key});

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen>
    with TickerProviderStateMixin {
  String userName = "";
  String userId = "";
  @override
  void initState() {
    super.initState();
    Get.find<ChatController>().getListDiscussion();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "My discussion".tr,
        bgColor: Theme.of(context).primaryColor,
      ),
      body: GetBuilder<ChatController>(builder: (controller) {
        if (controller.isLoadingDiscussion) {
          return const LoadingIndicator();
        }
        return Column(
          children: [
            Expanded(
              child: Builder(builder: (context) {
                if (controller.listDiscussion.isEmpty) {
                  return const Center(
                    child: Text('No discussion found'),
                  );
                }
                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.listDiscussion.length,
                  itemBuilder: (context, index) {
                    // Concatenate member names
                    String memberNames = controller
                            .listDiscussion[index].members
                            ?.map((member) => member.userName)
                            .join(', ') ??
                        "";
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            memberNames,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            controller.listDiscussion[index].lastMessage
                                    ?.message.message ??
                                "",
                          ),
                          onTap: () {
                            Get.toNamed(
                              RouteHelper.discussionDetail,
                              arguments: {
                                'discussion_id':
                                    controller.listDiscussion[index].id,
                              },
                            );
                          },
                        ),
                        const Divider(
                          height: 0,
                        )
                      ],
                    );
                  },
                );
              }),
            )
          ],
        );
      }),
    );
  }
}
