import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:opencentric_lms/utils/dimensions.dart';

import '../../components/custom_app_bar.dart';
import '../../components/loading_indicator.dart';
import '../../controller/group_controller.dart';
import '../../core/helper/route_helper.dart';
import '../../widget/expandable_html.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  void initState() {
    super.initState();

    Get.find<GroupController>().checkAdmin();
    Get.find<GroupController>().getGroup();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Group".tr,
        bgColor: Theme.of(context).primaryColor,
      ),
      body: GetBuilder<GroupController>(builder: (controller) {
        if (controller.isLoading) {
          return const LoadingIndicator();
        }
        return Padding(
          padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
          child: mainUI(),
        );
      }),
    );
  }

  Widget mainUI() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: Get.find<GroupController>().listGroup.length,
            itemBuilder: (context, index) {
              final item = Get.find<GroupController>().listGroup[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.groupDetail, arguments: {
                      'group_id': item.id,
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                      subtitle: ExpandableHtml(
                        data: item.description,
                      ),
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
