import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/data/provider/client_api.dart';
import 'package:paypal_payment/paypal_payment.dart';
import 'package:http/http.dart' as http;

class PayPalPayment extends StatefulWidget {
  const PayPalPayment({super.key, required this.title});
  final String title;

  @override
  State<PayPalPayment> createState() => _PayPalPaymentState();
}

class _PayPalPaymentState extends State<PayPalPayment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Column(
            children: [
              TextButton(
                  onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                PaypalOrderPayment(
                                    amount: "10",
                                    currencyCode: "USD",
                                    sandboxMode: true,
                                    clientId:
                                        "${dotenv.env['PAYPAL_CLIENT_ID']}",
                                    secretKey:
                                        "${dotenv.env['PAYPAL_SECRET_KEY']}",
                                    returnURL:
                                        "https://language.dev.weebpal.com/payment/success",
                                    cancelURL:
                                        "https://language.dev.weebpal.com/payment/cancel",
                                    note:
                                        "Contact us for any questions on your order.",
                                    onSuccess: (Map params) async {
                                      print(jsonEncode(params));
                                    },
                                    onError: (error) {
                                      print("onError: $error");
                                    },
                                    onCancel: (params) {
                                      print('cancelled: $params');
                                    }),
                          ),
                        )
                      },
                  child: const Text("Make Payment")),
              TextButton(
                  onPressed: () => {initPaymentSheet()},
                  child: const Text("Make Payment")),
            ],
          ),
        ));
  }

  Future<void> initPaymentSheet() async {
    try {
      Dio dio = Dio();
      ApiClient apiClient = Get.find();
      final response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: {
          "amount": "2000",
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
        final value = await Stripe.instance.presentPaymentSheet();
        print(value);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }
}
