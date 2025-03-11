import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:opencentric_lms/components/custom_button.dart';
import 'package:opencentric_lms/controller/forum_controller.dart';

import '../../components/custom_app_bar.dart';
import '../../components/custom_text_field.dart';
import '../../components/loading_indicator.dart';
import '../../core/helper/route_helper.dart';
import '../../utils/dimensions.dart';
import '../../utils/helper.dart';
import '../../utils/images.dart';

class TopicScreen extends StatefulWidget {
  const TopicScreen({super.key});

  @override
  State<TopicScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<TopicScreen> {
  String topicName = '';
  String forumId = '';
  HtmlEditorController controller = HtmlEditorController();
  final TextEditingController subjectController = TextEditingController();
  @override
  void initState() {
    super.initState();
    final topicId = Get.arguments['topic_id'];
    topicName = Get.arguments['topic_name'];
    forumId = Get.arguments['forum_id'];
    Get.find<ForumController>().getTopic(topicId);
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
        body: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: GetBuilder<ForumController>(builder: (controller) {
            if (controller.isLoadingTopicDetail) {
              return const LoadingIndicator();
            }
            return mainUI();
          }),
        ),
      ),
    );
  }

  Widget mainUI() {
    final topic = Get.find<ForumController>().topic;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            topic?.title ?? "",
            style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          Html(data: topic?.body ?? ""),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: topic?.listComment.length ?? 0,
            itemBuilder: (context, index) {
              final item = topic?.listComment[index];
              return ListTile(
                title: Row(
                  children: [
                    const SizedBox(width: 5),
                    Text(
                      item?.subject ?? "",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                subtitle: Html(data: item?.body ?? ""),
              );
            },
          ),
          const SizedBox(height: 10),
          Container(
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text("Subject".tr,
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .color!
                            .withOpacity(0.06),
                      ),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(Dimensions.paddingSizeExtraSmall)),
                    ),
                    child: CustomTextField(
                      hintText: 'Your text here...'.tr,
                      controller: subjectController,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.zero, // Remove padding
                  margin: EdgeInsets.zero,
                  child: HtmlEditor(
                    controller: controller, //required
                    htmlEditorOptions: const HtmlEditorOptions(
                      hint: "Your text here...",

                      //initalText: "text content initial, if any",
                    ),

                    htmlToolbarOptions: HtmlToolbarOptions(
                      gridViewVerticalSpacing: 0,
                      gridViewHorizontalSpacing: 0,
                      defaultToolbarButtons: [
                        const InsertButtons(
                          audio: false,
                          video: false,
                          otherFile: false,
                          table: false,
                          hr: false,
                          link: false,
                          picture: true, // Only show the picture button
                        ),
                      ],
                      customToolbarButtons: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Container()],
                        ),
                      ],
                      toolbarPosition: ToolbarPosition
                          .aboveEditor, // Place the toolbar above the editor
                      toolbarType: ToolbarType
                          .nativeGrid, // Use the native grid toolbar type
                    ),
                    otherOptions: const OtherOptions(
                      height: 200,
                    ),
                  ),
                ),
                CustomButton(
                    buttonText: "send".tr,
                    onPressed: () async {
                      final text = await controller.getText();
                      if (text.isNotEmpty &&
                          subjectController.text.isNotEmpty) {
                        Get.find<ForumController>().createComment(
                            subjectController.text,
                            forumId,
                            text,
                            topic?.id ?? "");
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
