import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/controller/forum_controller.dart';

import '../../components/custom_app_bar.dart';
import '../../components/loading_indicator.dart';
import '../../core/helper/route_helper.dart';
import '../../utils/helper.dart';
import '../../utils/images.dart';

class ForumDetailScreen extends StatefulWidget {
  const ForumDetailScreen({super.key});

  @override
  State<ForumDetailScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<ForumDetailScreen> {
  String forumName = '';
  @override
  void initState() {
    super.initState();
    final forumId = Get.arguments['forum_id'];
    forumName = Get.arguments['forum_name'];
    Get.find<ForumController>().getListTopic(forumId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: forumName,
        bgColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteHelper.createForumScreen, arguments: {
            'forum_id': Get.arguments['forum_id'],
          });
        },
        child: const Icon(Icons.add),
      ),
      body: GetBuilder<ForumController>(builder: (controller) {
        if (controller.isLoadingForumDetail) {
          return const LoadingIndicator();
        }
        return mainUI();
      }),
    );
  }

  Widget mainUI() {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: Get.find<ForumController>().listTopic.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final item = Get.find<ForumController>().listTopic[index];
              // Check time to now
              final time = DateTime.parse(item.created);
              final now = DateTime.now();
              final diff = now.difference(time);

              return GestureDetector(
                onTap: () async {
                  Get.toNamed(RouteHelper.topic, arguments: {
                    'topic_id': item.id,
                    'topic_name': item.title,
                    'forum_id': Get.arguments['forum_id'],
                  });
                },
                child: Container(
                  color: Colors.white,
                  child: ListTile(
                    title: Text(
                      item.title,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text("By ${item.name} ${formatTimeAgo(diff)} "),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            SvgPicture.asset(
                              Images.message,
                              height: 20,
                            ),
                            const SizedBox(width: 10),
                            Text("${item.commentCount} Comments"),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
