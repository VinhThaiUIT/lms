import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_snackbar.dart';
import 'package:opencentric_lms/controller/course_detail_controller.dart';
import 'package:opencentric_lms/data/model/cart_list/cart_list.dart';
import 'package:opencentric_lms/repository/course_detail_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/initial_binding/initial_binding.dart';
import '../data/model/cart_list/calculations.dart';
import '../data/model/cart_list/cart.dart';
import '../data/model/common/course.dart';
import '../repository/cart_repository.dart';
import 'auth_controller.dart';

class CartController extends GetxController implements GetxService {
  bool isCartDataLoading = false;
  List<Course> listCourse = [];
  List<Cart> cartList = [];
  Calculations? calculations;

  //apply coupon
  int selectedCartItemIndex = -1;
  bool isApplyCouponLoading = false;
  final couponInputController = TextEditingController();
  int deletingCartIndex = -1;
  bool isDeletingFromCart = false;

  bool isCartItemDeleting(int index) => index == deletingCartIndex;

  void deletingIndex(int index) {
    deletingCartIndex = index;
    update();
  }

  bool isApplyCouponPressed(int index) {
    return index == selectedCartItemIndex;
  }

  void selectedIndex(int index) {
    selectedCartItemIndex = index;
    update(["cart"]);
  }

  @override
  void onInit() {
    getCartList();
    super.onInit();
  }

  Future<void> clearCartList() async {
    cartList.clear();
    listCourse.clear();
    await getCartList();
    update();
  }

  bool isCartListContainCourseId(int id) {
    return cartList.any((cart) => cart.courseId == id);
  }

  Future<void> getCartList() async {
    isCartDataLoading = true;
    update();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final response =
        await CartRepository(Get.find(), sharedPreferences).getCartList();
    if (response != null && response.statusCode == 200) {
      CartList cart = CartList.fromJson(response.body);
      calculations = cart.data!.calculations;
      cartList.clear();
      cartList.addAll(cart.data!.carts ?? []);
      listCourse.clear();
      listCourse.addAll(cart.data!.listCourse ?? []);
    }
    isCartDataLoading = false;
    update();
  }

  Future<void> addToCart(int id) async {
    // check user is logged in or not.
    //if not, show a message
    if (!Get.find<AuthController>().isLoggedIn()) {
      customSnackBar('login_to_add_this_to_cart'.tr, isError: true);
      return;
    }
    isCartDataLoading = true;
    update();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final response =
        await CartRepository(Get.find(), sharedPreferences).addToCart(id);
    if (response != null) {
      customSnackBar("Add to cart successful", isError: false);
    }
    await getCartList();
    Get.put(CourseDetailController(
            courseDetailsRepository:
                CourseDetailsRepository(apiClient: Get.find())))
        .courseDetail
        ?.data
        .isAddedToCart = true;
    isCartDataLoading = false;
    update();
  }

  Future<void> removeFromCart({required int id}) async {
    isDeletingFromCart = true;
    update();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final response =
        await CartRepository(Get.find(), sharedPreferences).removeFromCart(id);
    // if (response != null) {
    //   customSnackBar(response.body['message'].toString(),
    //       isError: response.statusCode != 200);
    // }

    //now update cart list data again
    final cartResponse =
        await CartRepository(Get.find(), sharedPreferences).getCartList();
    if (cartResponse != null && cartResponse.statusCode == 200) {
      CartList cart = CartList.fromJson(cartResponse.body);
      calculations = cart.data!.calculations;
      cartList.clear();
      cartList.addAll(cart.data!.carts ?? []);
      listCourse.clear();
      listCourse.addAll(cart.data!.listCourse ?? []);
    }

    deletingIndex(-1);
    isDeletingFromCart = false;
    update();
  }

  Future<bool> updateCompleteCart({required String typePayment}) async {
    isDeletingFromCart = true;
    update();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final response = await CartRepository(Get.find(), sharedPreferences)
        .updateCompleteCart(typePayment);
    if (response != null) {
      customSnackBar(response.body['message'].toString(),
          isError: response.statusCode != 200);
    }
    final checkCurrentCourse = listCourse.toList();

    //now update cart list data again
    final cartResponse =
        await CartRepository(Get.find(), sharedPreferences).getCartList();
    if (cartResponse != null && cartResponse.statusCode == 200) {
      CartList cart = CartList.fromJson(cartResponse.body);
      calculations = cart.data!.calculations;
      cartList.clear();
      cartList.addAll(cart.data!.carts ?? []);
      listCourse.clear();
      listCourse.addAll(cart.data!.listCourse ?? []);
    }
    bool checkBoughtMembership = false;
    for (var i = 0; i < checkCurrentCourse.length; i++) {
      if (checkCurrentCourse[i].id == 15 || checkCurrentCourse[i].id == 16) {
        checkBoughtMembership = true;
        break;
      }
    }
    if (checkBoughtMembership) {
      // Reinitialize the bindings
      InitialBinding().dependencies();
    }
    update();
    return checkBoughtMembership;
  }

  Future<void> applyCoupon(
      {required String code, required String type, required String id}) async {
    isApplyCouponLoading = true;
    update();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final response = await CartRepository(Get.find(), sharedPreferences)
        .applyCoupon(code: code, type: type, id: id);
    if (response != null && response.statusCode == 200) {
      customSnackBar(response.body['message'] ?? "", isError: false);
    } else {
      customSnackBar(
          response?.body['message'] ??
              response?.body['errors']['code'].toString(),
          isError: false);
    }
    await getCartList();
    isApplyCouponLoading = false;
    update();
  }
}
