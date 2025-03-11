import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:opencentric_lms/components/custom_button.dart';
import 'package:opencentric_lms/controller/chat_controller.dart';
import 'package:opencentric_lms/controller/forum_controller.dart';

import '../../components/custom_app_bar.dart';
import '../../components/custom_text_field.dart';
import '../../components/loading_indicator.dart';
import '../../utils/dimensions.dart';

class DiscussionDetailScreen extends StatefulWidget {
  const DiscussionDetailScreen({super.key});

  @override
  State<DiscussionDetailScreen> createState() => _ForumScreenState();
}

class _ForumScreenState extends State<DiscussionDetailScreen> {
  HtmlEditorController controller = HtmlEditorController();
  final TextEditingController subjectController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    final discussionId = Get.arguments['discussion_id'];
    Get.find<ChatController>().getDiscussionDetail(discussionId);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("reach the bottom");
      }
    });
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
          child: GetBuilder<ChatController>(builder: (controller) {
            if (controller.isLoadingDiscussionDetail) {
              return const LoadingIndicator();
            }
            return mainUI();
          }),
        ),
      ),
    );
  }

  Widget mainUI() {
    final discussionDetail = Get.find<ChatController>().discussionDetail;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Builder(builder: (context) {
          if (discussionDetail?.subject == null) {
            return const SizedBox();
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Text(
              discussionDetail?.subject ?? "",
              style: const TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
            ),
          );
        }),
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            itemCount: discussionDetail?.privateMessage?.length ?? 0,
            itemBuilder: (context, index) {
              final item = discussionDetail?.privateMessage?[index];
              return ListTile(
                // title: Row(
                //   children: [
                //     const SizedBox(width: 5),
                //     Text(
                //       item?.subject ?? "",
                //       style: const TextStyle(
                //           fontSize: 18, fontWeight: FontWeight.bold),
                //     ),
                //   ],
                // ),
                title: Builder(builder: (context) {
                  if (item?.message == null || item?.message.isEmpty == true) {
                    return const SizedBox();
                  }
                  return Html(data: item?.message.first.message ?? "");
                }),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Column(
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
                        await Get.find<ChatController>().createMessage(
                            discussionDetail?.members
                                    ?.map((e) => e.userId)
                                    .toList() ??
                                [],
                            await controller.getText());
                        // clear text and focus bottom
                        controller.clear();
                        Future.delayed(const Duration(milliseconds: 500), () {
                          _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent);
                        });
                      }),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
