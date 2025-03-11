import 'package:get/get_connect/http/src/response/response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/provider/client_api.dart';
import '../utils/app_constants.dart';

class CartRepository {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  CartRepository(this.apiClient, this.sharedPreferences);

  Future<Response?> getCartList() async {
    final uid = sharedPreferences.getString(AppConstants.uid) ?? "";
    return apiClient.getData(AppConstants.getCart(uid));
  }

  Future<Response?> addToCart(int id) async {
    final uid = sharedPreferences.getString(AppConstants.uid) ?? "";
    var body = {"course_id": id.toString(), "quantity": "1", "user_id": uid};
    return apiClient.postData(AppConstants.addToCart, body);
  }

  Future<Response?> removeFromCart(int orderItemId) async {
    final uid = sharedPreferences.getString(AppConstants.uid) ?? "";
    var body = {"order_item_id": orderItemId.toString(), "user_id": uid};
    return apiClient.postData(AppConstants.lmsRemoveItemCart, body);
  }

  Future<Response?> updateCompleteCart(String typePayment) async {
    final uid = sharedPreferences.getString(AppConstants.uid) ?? "";
    var body = {"type-payment": typePayment, "user_id": uid};
    return apiClient.postData(AppConstants.updateCompleteCart, body);
  }

  Future<Response?> applyCoupon(
      {required String code, required String type, required String id}) async {
    var body = {'type': type, 'id': id, 'code': code};
    return apiClient.postData(AppConstants.applyCoupon, body);
  }
}
