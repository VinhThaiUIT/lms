import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/controller/forum_controller.dart';

import '../../components/custom_app_bar.dart';
import '../../components/loading_indicator.dart';
import '../../core/helper/route_helper.dart';
import '../../utils/images.dart';

class ForumOfflineScreen extends StatefulWidget {
  const ForumOfflineScreen({super.key});

  @override
  State<ForumOfflineScreen> createState() => _ForumOfflineScreenState();
}

class _ForumOfflineScreenState extends State<ForumOfflineScreen> {
  @override
  void initState() {
    super.initState();
    Get.find<ForumController>().getForumOffline();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "forum".tr,
        bgColor: Theme.of(context).primaryColor,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(RouteHelper.createForumScreen);
        },
        child: const Icon(Icons.add),
      ),
      body: GetBuilder<ForumController>(builder: (controller) {
        if (controller.isLoading) {
          return LoadingIndicator();
        }
        return mainUI();
      }),
    );
  }

  Widget mainUI() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: Get.find<ForumController>().listForum.length,
            itemBuilder: (context, index) {
              final item = Get.find<ForumController>().listForum[index];
              bool isParent = item.parents == "0";
              return GestureDetector(
                onTap: () {
                  if (!isParent) {
                    Get.toNamed(RouteHelper.forumDetail, arguments: {
                      'forum_id': item.id,
                      'forum_name': item.name,
                    });
                  }
                },
                child: Container(
                  color: isParent ? Colors.grey[200] : Colors.white,
                  child: ListTile(
                    title: Row(
                      children: [
                        const SizedBox(width: 5),
                        Text(
                          item.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Html(data: item.description),
                        if (!isParent)
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  Images.message,
                                  height: 20,
                                ),
                                const SizedBox(width: 10),
                                Text("${item.numberTopics} Topics"),
                                const SizedBox(width: 20),
                                SvgPicture.asset(
                                  Images.myAssignment,
                                  height: 20,
                                ),
                                const SizedBox(width: 10),
                                Text("${item.numPosts} Posts"),
                              ],
                            ),
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
