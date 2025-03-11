import 'package:get/get_connect/http/src/response/response.dart';
import 'package:opencentric_lms/data/provider/client_api.dart';
import 'package:opencentric_lms/utils/app_constants.dart';

class FaqRepo {
  final ApiClient apiClient;
  FaqRepo({required this.apiClient});

  Future<Response?> getFaq() async {
    return apiClient.getData(AppConstants.getFaq);
  }


}