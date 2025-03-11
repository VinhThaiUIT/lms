import 'package:get/get.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import 'package:image_picker/image_picker.dart';
import 'package:opencentric_lms/data/model/user_info_model.dart';
import 'package:opencentric_lms/data/model/user_model/user_data.dart';
import 'package:opencentric_lms/data/provider/client_api.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  UserRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response?> getUser(String uid) {
    return apiClient.getData(AppConstants.user(uid));
  }

  Future<Response?> getProfile(String uid) {
    return apiClient.getData(AppConstants.profile(uid));
  }

  Future<Response?> updateProfile(
    String uid,
    String firstName,
    String lastName, {
    String? fieldPhoneNumber,
    String? fieldGender,
    String? fieldDateOfBirth,
    String? fieldRole,
    String? userPictureBase64,
  }) {
    Map<String, dynamic> body = {
      "field_first_name": firstName,
      "field_last_name": lastName,
    };
    if (fieldPhoneNumber != null) {
      body["field_phone_number"] = fieldPhoneNumber;
    }
    if (fieldGender != null) {
      body["field_gender"] = fieldGender;
    }
    if (fieldDateOfBirth != null) {
      body["field_date_of_birth"] = fieldDateOfBirth;
    }
    // store role to field_role in body respond
    if (fieldRole != null) {
      body["field_role"] = fieldRole;
    }
    //
    if (userPictureBase64 != null) {
      body["user_picture"] = {
        "data_endcode_base64": userPictureBase64,
        "alt": "user picture",
        "title": "Picture Profile",
        "file_name": "user_picture.png"
      };
    }


    return apiClient.patchData(AppConstants.profile(uid), body);
  }

  String getUserUid() {
    return sharedPreferences.getString(AppConstants.uid) ?? "";
  }

  Future<Response?> editProfile(UserData user, XFile? image) async {
    // Map<String, dynamic> body = {};
    // body['data']['attributes'].addAll({
    //   'field_first_name': 'admin1',
    //   'field_last_name': 'admin1',
    // });

    return await apiClient.patchData(
        'https://language.dev.weebpal.com/jsonapi/profile/student?filter[uid.meta.drupal_internal__target_id]=1',
        {
          "data": {
            "type": "profile--student",
            "id": "1", // Replace with the actual profile ID
            "attributes": {
              "drupal_internal__profile_id": 20,
              "drupal_internal__revision_id": 20,
              "revision_created": "2024-08-21T06:17:56+00:00",
              "revision_log_message": null,
              "status": true,
              "is_default": true,
              "data": null,
              "created": "2024-08-21T06:17:56+00:00",
              "changed": "2024-08-21T06:17:56+00:00",
              "field_description": null,
              "field_first_name": "John",
              "field_full_name": null,
              "field_last_name": "Doe"
            }
          }
        });
  }

  Map<String, dynamic> editUserData(
      Map<String, dynamic> userData, Map<String, dynamic> updates) {
    userData['data']['attributes'].addAll(updates);
    return userData;
  }

  //old
  Future<Response> getUserInfo() async {
    return await apiClient.getData(AppConstants.customerInfoUrl);
  }

  // Future<Response> updateProfile(
  //     UserInfoModel userInfoModel, XFile? data) async {
  //   Map<String, String> body = {};
  //   body.addAll(<String, String>{
  //     '_method': 'put',
  //     'first_name': userInfoModel.fName!,
  //     'last_name': userInfoModel.lName!,
  //     'email': userInfoModel.email!,
  //     'phone': userInfoModel.phone!,
  //   });
  //   return await apiClient.postMultipartData(AppConstants.updateProfileUrl,
  //       body, data != null ? [MultipartBody('profile_image', data)] : [], null);
  // }

  Future<Response> updateAccountInfo(UserInfoModel userInfoModel) async {
    Map<String, String> body = {};
    body.addAll(<String, String>{
      '_method': 'put',
      'first_name': userInfoModel.fName!,
      'last_name': userInfoModel.lName!,
      'email': userInfoModel.email!,
      'phone': userInfoModel.phone!,
      'password': userInfoModel.password!,
      'confirm_password': userInfoModel.confirmPassword!,
    });
    return await apiClient.putData(AppConstants.updateProfileUrl, body);
  }

  Future<Response> changePassword(UserInfoModel userInfoModel) async {
    return await apiClient.postData(AppConstants.updateProfileUrl, {
      'phone_or_email': userInfoModel.fName,
      'otp': userInfoModel.lName,
      'password': userInfoModel.email,
      'confirm_password': userInfoModel.phone
    });
  }

  Future<Response> deleteUser() async {
    return await apiClient.getData(AppConstants.deleteAccount);
  }
}
