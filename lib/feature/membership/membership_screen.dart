import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';

import 'package:opencentric_lms/components/custom_app_bar.dart';
import 'package:opencentric_lms/components/custom_button.dart';
import 'package:opencentric_lms/components/loading_dialog.dart';
import 'package:opencentric_lms/components/loading_indicator.dart';
import 'package:opencentric_lms/controller/membership_controller.dart';

import '../../controller/cart_controller.dart';
import '../../utils/styles.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    Get.find<MembershipController>().getMembership();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Membership'.tr,
        centerTitle: true,
        bgColor: null,
      ),
      body: GetBuilder<MembershipController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const LoadingIndicator();
          }
          return Column(children: [
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.listMembership.length,
                itemBuilder: (context, index) {
                  final item = controller.listMembership[index];
                  return Container(
                    margin: const EdgeInsets.only(
                        left: 16, right: 16, top: 8, bottom: 8),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).shadowColor,
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title ?? "",
                          style: robotoBold.copyWith(
                              color: Theme.of(context)
                                  .textTheme
                                  .headlineSmall!
                                  .color,
                              fontSize: 26),
                        ),
                        Text(
                          item.fieldSubtitle ?? "",
                          style: robotoBold.copyWith(
                            color:
                                Theme.of(context).textTheme.displaySmall!.color,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          item.priceNumber ?? "",
                          style: robotoBold.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontSize: 30,
                          ),
                        ),
                        Text(
                          item.listPriceNumber ?? "",
                          style: robotoBold.copyWith(
                              color: Theme.of(context).primaryColor,
                              fontSize: 20,
                              decoration: TextDecoration.lineThrough),
                        ),
                        CustomButton(
                            buttonText: "Buy Now".tr,
                            onPressed: () async {
                              LoadingDialog.show(context);
                              await Get.find<CartController>().addToCart(
                                  int.tryParse(item.productId ?? "") ?? 0);
                              LoadingDialog.hide(context);
                            }),
                        Divider(
                          indent: 10,
                          endIndent: 10,
                          color: Theme.of(context).dividerColor,
                        ),
                        Html(
                          data: controller.listMembership[index].body!,
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ]);
        },
      ),
    );
  }
}
