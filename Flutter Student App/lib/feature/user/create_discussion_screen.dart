import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:opencentric_lms/components/custom_button.dart';
import 'package:opencentric_lms/controller/chat_controller.dart';

import '../../components/custom_app_bar.dart';
import '../../core/helper/route_helper.dart';

class CreateDiscussionScreen extends StatefulWidget {
  const CreateDiscussionScreen({super.key});

  @override
  State<CreateDiscussionScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<CreateDiscussionScreen> {
  HtmlEditorController controller = HtmlEditorController();
  List<String> listUserId = [];
  @override
  void initState() {
    if (Get.arguments != null) {
      listUserId = Get.arguments['list_user_id'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        controller.clearFocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          bgColor: Theme.of(context).primaryColor,
        ),
        body: mainUI(),
      ),
    );
  }

  Widget mainUI() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HtmlEditor(
                  controller: controller, //required
                  htmlEditorOptions: const HtmlEditorOptions(
                    hint: "Your text here...",
                    //initalText: "text content initial, if any",
                  ),
                  htmlToolbarOptions: const HtmlToolbarOptions(
                    toolbarType: ToolbarType.nativeGrid,
                  ),
                  otherOptions: const OtherOptions(
                    height: 400,
                  ),
                ),
                CustomButton(
                    buttonText: "send".tr,
                    onPressed: () async {
                      final discussionId = await Get.find<ChatController>()
                          .createMessage(
                              listUserId, await controller.getText());
                      if (discussionId.isNotEmpty) {
                        Get.offNamed(
                          RouteHelper.discussionDetail,
                          arguments: {
                            'discussion_id': discussionId,
                          },
                        );
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
