import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_app_bar.dart';
import 'package:opencentric_lms/components/custom_button.dart';
import 'package:opencentric_lms/controller/cart_controller.dart';
import 'package:opencentric_lms/feature/cheekOut/widget/payment_method.dart';
import 'package:opencentric_lms/feature/cheekOut/widget/success_message.dart';
import 'package:opencentric_lms/utils/dimensions.dart';

class CheekOutScreen extends StatelessWidget {
  const CheekOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Cheek Out'.tr,
      ),
      body: GetBuilder<CartController>(
        builder: (cartController) {
          return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                //todo: change below
                //return const CartItem(isCoupon: false);
                return Container();
              });
        },
      ),
      bottomNavigationBar: SizedBox(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // todo: remove comment
            //const CalculatePayment(),
            const PaymentMethod(),
            Padding(
              padding: const EdgeInsets.all(Dimensions.paddingSizeDefault),
              child: CustomButton(
                onPressed: () {
                  Get.dialog(const SuccessMessage());
                },
                buttonText: 'complete_payment'.tr,
              ),
            ),
            const SizedBox(
              height: Dimensions.paddingSizeDefault,
            )
          ],
        ),
      ),
    );
  }
}
