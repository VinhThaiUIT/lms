import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:opencentric_lms/components/custom_app_bar.dart';
import 'package:opencentric_lms/components/custom_snackbar.dart';
import 'package:opencentric_lms/controller/forum_controller.dart';

import '../../components/custom_text_field.dart';
import '../../utils/dimensions.dart';

class CreateForumScreen extends StatefulWidget {
  const CreateForumScreen({super.key});

  @override
  State<CreateForumScreen> createState() => _CreateForumScreenState();
}

class _CreateForumScreenState extends State<CreateForumScreen> {
  HtmlEditorController bodyController = HtmlEditorController();
  TextEditingController subjectController = TextEditingController();

  String? selectForum;
  final forumController = Get.find<ForumController>();
  @override
  void initState() {
    if (Get.arguments != null) {
      selectForum = Get.arguments['forum_id'];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        bodyController.clearFocus();
      },
      child: Scaffold(
        appBar: CustomAppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                onPressed: () async {
                  print(subjectController.text);
                  final bodyText = await bodyController.getText();
                  if (subjectController.text.isEmpty) {
                    customSnackBar("Subject is required".tr);
                    return;
                  } else if (bodyText.isEmpty) {
                    customSnackBar("Body is required".tr);
                    return;
                  } else if (selectForum == null) {
                    customSnackBar("Forum is required".tr);
                    return;
                  }
                  await Get.find<ForumController>().createForum(
                      subjectController.text, selectForum ?? "", bodyText);
                },
                icon: Text(
                  "Save".tr,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeLarge),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Subject".tr,
                    style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 15),
                Container(
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
                const SizedBox(height: 20),
                Text("Forum".tr, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 15),
                GetBuilder<ForumController>(
                    init: forumController,
                    builder: (controller) {
                      if (controller.isLoading) {
                        return Container();
                      }
                      final listItem = controller.listForum
                          .where((e) => e.id == selectForum)
                          .toList();
                      String currentForum =
                          listItem.isNotEmpty ? listItem.first.name : "";
                      return Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .color!
                                .withOpacity(0.06),
                          ),
                          borderRadius: const BorderRadius.all(Radius.circular(
                              Dimensions.paddingSizeExtraSmall)),
                        ),
                        child: CustomTextField(
                          hintText: 'Your text here...'.tr,
                          isEnabled: false,
                          controller: TextEditingController(text: currentForum),
                        ),
                      );
                    }),
                const SizedBox(height: 20),
                Text("Body".tr, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 15),
                HtmlEditor(
                  controller: bodyController, //required
                  htmlEditorOptions: const HtmlEditorOptions(
                    hint: "Your text here...",
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
                    height: 400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
