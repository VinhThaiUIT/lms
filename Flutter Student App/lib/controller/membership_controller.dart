import 'package:get/get.dart';
import 'package:opencentric_lms/data/model/membership/membership_model.dart';

import '../repository/membership_repository.dart';

class MembershipController extends GetxController implements GetxService {
  List<MembershipModel> listMembership = [];
  bool isLoading = true;
  @override
  void onInit() {
    getMembership();
    super.onInit();
  }

  Future<void> getMembership() async {
    isLoading = true;
    update();
    final response = await MembershipRepository(Get.find()).getMemberShip();
    if (response != null && response.statusCode == 200) {
      listMembership = (response.body as List)
          .map((e) => MembershipModel.fromJson(e))
          .toList();
    }
    isLoading = false;
    update();
  }
}
