import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/controller/splash_controller.dart';
import '../config.dart';
import '../data/provider/client_api.dart';
import '../utils/app_constants.dart';
import 'package:http/http.dart' as http;

class PaymentController extends GetxController implements GetxService {
  final ApiClient apiClient;
  PaymentController(this.apiClient);

  bool isLoading = true;
  bool isPaymentSuccess = false;
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;

  late PullToRefreshController pullToRefreshController;
  late ContextMenu contextMenu;
  String url = "https://www.linkedin.com/";
  double progress = 0;
  final urlController = TextEditingController();
  bool showButton = false;
  String langCode = "en";
  String currencyCode = "USD";

  @override
  void onInit() {
    super.onInit();
    langCode = "en";
    currencyCode = "USD";
    contextMenu = ContextMenu(
        menuItems: [
          ContextMenuItem(
              // id: 1,
              title: "Special",
              action: () async {
                await webViewController?.clearFocus();
              })
        ],
        onCreateContextMenu: (hitTestResult) async {},
        onHideContextMenu: () {},
        onContextMenuActionItemClicked: (contextMenuItemClicked) async {});

    pullToRefreshController = PullToRefreshController(
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  URLRequest makePaymentRequest() {
    final appConfig = Get.find<SplashController>()
        .configModel
        .data!
        .appConfig
        .defaultCurrency;

    return URLRequest(
        url: WebUri(
          "${Config.baseUrl}user/make-payment?currency_code=$appConfig",
        ),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          AppConstants.localizationKey: AppConstants.languages[0].languageCode!,
          'Authorization': 'Bearer ${apiClient.token}'
        });
  }

  Uri successUri() {
    return Uri.parse("${Config.baseUrl}/complete-order");
  }

  Future<void> createPaymentIntent() async {
    final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ' + "",
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'amount': '2000',
        'currency': 'usd',
        'automatic_payment_methods[enabled]': 'true',
      },
    );

    if (response.statusCode == 200) {
      print('Payment Intent created successfully: ${response.body}');
    } else {
      print('Failed to create Payment Intent: ${response.body}');
    }
  }

  progressUpdate(value) {
    progress = value;
    update();
  }

  isLoadingUpdate(value) {
    isLoading = value;
    update();
  }

  isPaymentSuccessUpdate(value) {
    isPaymentSuccess = value;
    update();
  }

  showButtonUpdate(value) {
    showButton = value;
    update();
  }
}
