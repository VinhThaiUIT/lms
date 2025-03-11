import 'package:get/get_connect/http/src/response/response.dart';
import 'package:opencentric_lms/data/provider/client_api.dart';
import 'package:opencentric_lms/utils/app_constants.dart';

class MembershipRepository {
  final ApiClient apiClient;
  MembershipRepository(this.apiClient);

  Future<Response?> getMemberShip() async {
    return apiClient.getData(AppConstants.getMembership);
  }
}
