import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_app_bar.dart';
import 'package:opencentric_lms/components/custom_button.dart';
import 'package:opencentric_lms/components/loading_indicator.dart';
import 'package:opencentric_lms/controller/cart_controller.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';
import 'package:opencentric_lms/data/model/cart_list/calculations.dart';
import 'package:opencentric_lms/feature/cart/widget/calculate_payment.dart';
import 'package:opencentric_lms/feature/cart/widget/cart_item.dart';
import 'package:opencentric_lms/utils/dimensions.dart';
import 'package:opencentric_lms/utils/images.dart';
import 'package:opencentric_lms/utils/styles.dart';
import 'package:pay/pay.dart';
import 'package:paypal_payment/paypal_payment.dart';

import '../../components/custom_snackbar.dart';
import '../../components/loading_dialog.dart';
import '../../data/model/common/course.dart';
import '/pay_test.dart' as payment_configurations;

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'cart_item'.tr,
      ),
      body: GetBuilder<CartController>(
        builder: (cartController) {
          return cartController.isCartDataLoading == true
              ? const LoadingIndicator()
              : cartController.cartList.isEmpty
                  ? Center(
                      child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          Images.emptyCart,
                          scale: 3,
                        ),
                        Text(
                          'empty_cart'.tr,
                          style: robotoSemiBold.copyWith(
                            fontSize: Dimensions.fontSizeLarge,
                          ),
                        ),
                        const SizedBox(
                          height: Dimensions.paddingSizeExtraSmall,
                        ),
                        Text(
                          'you_have_not_added_anything'.tr,
                          style: robotoRegular.copyWith(
                            fontSize: Dimensions.fontSizeSmall,
                            color: Theme.of(Get.context!)
                                .textTheme
                                .bodySmall!
                                .color!
                                .withOpacity(.7),
                          ),
                        ),
                      ],
                    ))
                  : ListView.builder(
                      physics: const ScrollPhysics(),
                      itemCount: cartController.cartList.length,
                      itemBuilder: (context, index) {
                        return CartItem(
                          cart: cartController.cartList[index],
                          index: index,
                          course: cartController.listCourse[index],
                        );
                      });
        },
      ),
      bottomNavigationBar: GetBuilder<CartController>(builder: (controller) {
        return controller.isCartDataLoading == true
            ? const LoadingIndicator()
            : controller.cartList.isEmpty
                ? const SizedBox()
                : SizedBox(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CalculatePayment(calculation: controller.calculations),
                        Platform.isAndroid
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(
                                        Dimensions.paddingSizeDefault),
                                    child: CustomButton(
                                      onPressed: () {
                                        // Get.toNamed(RouteHelper.getCheekOutScreen());
                                        // Get.toNamed(RouteHelper.getPaymentScreen());
                                        payPalPayment(
                                            context,
                                            controller.calculations,
                                            controller.listCourse);
                                      },
                                      buttonText: 'PayPal Payment'.tr,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            Dimensions.paddingSizeDefault),
                                    child: CustomButton(
                                      onPressed: () {
                                        // Get.toNamed(RouteHelper.getCheekOutScreen());
                                        // Get.toNamed(RouteHelper.getPaymentScreen());
                                        initPaymentSheet(
                                            context,
                                            controller.calculations,
                                            controller.listCourse);
                                      },
                                      buttonText: 'Credit Payment'.tr,
                                    ),
                                  ),
                                ],
                              )
                            : Builder(builder: (context) {
                                double totalPayable = double.tryParse(
                                        controller.calculations?.totalPayable ??
                                            "0") ??
                                    0.0;
                                String formattedTotalPayable =
                                    totalPayable.toStringAsFixed(2);
                                return ApplePayButton(
                                  paymentConfiguration:
                                      PaymentConfiguration.fromJsonString(
                                          payment_configurations
                                              .defaultApplePay),
                                  paymentItems: [
                                    PaymentItem(
                                      label: 'Total',
                                      amount: formattedTotalPayable,
                                      status: PaymentItemStatus.final_price,
                                    )
                                  ],
                                  margin: const EdgeInsets.only(
                                      left: 15.0, right: 15.0, bottom: 15.0),
                                  width: double.infinity,
                                  height: 45,
                                  onPaymentResult: (paymentItem) async {
                                    LoadingDialog.show(context);

                                    final checkBoughtMembership =
                                        await Get.find<CartController>()
                                            .updateCompleteCart(
                                                typePayment: "APPLE");
                                    LoadingDialog.hide(context);
                                    if (checkBoughtMembership) {
                                      Get.offAllNamed(RouteHelper.getMainRoute(
                                          RouteHelper.splash));
                                      customSnackBar("Change to membership",
                                          isError: false);
                                    }
                                  },
                                  loadingIndicator: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }),
                        const SizedBox(
                          height: Dimensions.paddingSizeDefault,
                        )
                      ],
                    ),
                  );
      }),
    );
  }

  void payPalPayment(BuildContext context, Calculations? calculations,
      List<Course> listCourse) {
    double totalPayable =
        double.tryParse(calculations?.totalPayable ?? "0") ?? 0.0;
    String formattedTotalPayable = totalPayable.toStringAsFixed(2);
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => PaypalOrderPayment(
            amount: formattedTotalPayable,
            currencyCode: calculations?.currencyCode ?? "USD",
            sandboxMode: true,
            clientId: "${dotenv.env['PAYPAL_CLIENT_ID']}",
            secretKey: "${dotenv.env['PAYPAL_SECRET_KEY']}",
            returnURL: "https://language.dev.weebpal.com/payment/success",
            cancelURL: "https://language.dev.weebpal.com/payment/cancel",
            note: "Contact us for any questions on your order.",
            onSuccess: (Map params) async {
              LoadingDialog.show(context);

              final checkBoughtMembership = await Get.find<CartController>()
                  .updateCompleteCart(typePayment: "APPLE");
              LoadingDialog.hide(context);
              if (checkBoughtMembership) {
                Get.offAllNamed(RouteHelper.getMainRoute(RouteHelper.splash));
                customSnackBar("Change to membership", isError: false);
              }
            },
            onError: (error) {
              print("onError: $error");
            },
            onCancel: (params) {
              print('cancelled: $params');
            }),
      ),
    );
  }

  Future<void> initPaymentSheet(BuildContext context,
      Calculations? calculations, List<Course> listCourse) async {
    Dio dio = Dio();
    double totalPayable =
        (double.tryParse(calculations?.totalPayable ?? "0") ?? 0.0) * 100;
    String formattedTotalPayable = totalPayable.toStringAsFixed(0);
    final response = await dio.post(
      "https://api.stripe.com/v1/payment_intents",
      data: {
        "amount": formattedTotalPayable,
        "currency": "usd",
        "automatic_payment_methods[enabled]": "true"
      },
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'Authorization':
              'Basic ${base64Encode(utf8.encode('${dotenv.env['STRIPE_SECRET_KEY']}:'))}',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      ),
    );

    final data = response.data;
    // 2. initialize the payment sheet
    await Stripe.instance
        .initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        // Set to true for custom flow
        customFlow: false,
        // Main params
        merchantDisplayName: 'Flutter Stripe Store Demo',
        paymentIntentClientSecret: data['client_secret'],
        // Customer keys
        customerEphemeralKeySecret: data['ephemeralKey'],
        customerId: data['customer'],

        style: ThemeMode.dark,
      ),
    )
        .then((value) async {
      await Stripe.instance.presentPaymentSheet();
      LoadingDialog.show(context);

      final checkBoughtMembership = await Get.find<CartController>()
          .updateCompleteCart(typePayment: "APPLE");
      LoadingDialog.hide(context);
      if (checkBoughtMembership) {
        Get.offAllNamed(RouteHelper.getMainRoute(RouteHelper.splash));
        customSnackBar("Change to membership", isError: false);
      }
    });
  }
}
