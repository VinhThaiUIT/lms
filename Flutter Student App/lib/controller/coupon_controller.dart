import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_snackbar.dart';
import 'package:opencentric_lms/data/model/coupon_list/coupon_list.dart';
import 'package:opencentric_lms/repository/coupon_repository.dart';

class CouponController extends GetxController implements GetxService {
  bool isCouponListLoading = false;
  CouponList? couponList;

  Future<void> getCouponList() async {
    isCouponListLoading = true;
    update();
    final response = await CouponRepository(Get.find()).getCouponList();
    if (response != null && response.statusCode == 200) {
      if (response.body['success'] == true) {
        CouponList list = CouponList.fromJson(response.body);
        couponList = list;
      }
    }
    isCouponListLoading = false;
    update();
  }

  Future<void> copyCodeToClipBoard(String code) async {
    Clipboard.setData(ClipboardData(text: code)).then((value) {
      customSnackBar('copied_to_clipboard'.tr, isError: false);
    });
  }
}
