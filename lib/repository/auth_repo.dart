import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/data/model/signup_body.dart';
import 'package:opencentric_lms/data/model/social_login_body.dart';
import 'package:opencentric_lms/data/provider/client_api.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response?> registration(SignUpBody signUpBody) async {
    return await apiClient.postData(
        AppConstants.registerUrl, signUpBody.toJson());
  }

  Future<Response?> registerWithPhoneNumber(SignUpBody body) async {
    return await apiClient.postData(
        AppConstants.registerWithPhone, body.toJsonForPhone());
  }

  Future<Response?> login(
      {required String email, required String password}) async {
    apiClient.updateHeader(null, AppConstants.languageCode);
    return await apiClient
        .postData(AppConstants.loginUrl, {"name": email, "pass": password});
  }

  Future<Response?> logout() async {
    final token = sharedPreferences.getString(AppConstants.logoutToken);
    return await apiClient.postData(AppConstants.logout(token ?? ''), {});
  }

  Future<Response?> loginWithSocialMedia(
      SocialLogInBody socialLogInBody) async {
    Map<String, String> mainHeaders = {
      'Content-Type': 'application/json; charset=UTF-8',
    };
    return await apiClient.postData(
        AppConstants.socialLoginUrl, socialLogInBody.toJson(),
        headers: mainHeaders);
  }

  Future<Response?> registerWithSocialMedia(
      SocialLogInBody socialLogInBody) async {
    return await apiClient.postData(
        AppConstants.socialRegisterUrl, socialLogInBody.toJson());
  }

  Future<Response?> updateToken() async {
    String? deviceToken;
    if (GetPlatform.isIOS) {
      FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
          alert: true, badge: true, sound: true);
      NotificationSettings settings =
          await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        deviceToken = await _saveDeviceToken();
      }
    } else {
      deviceToken = await _saveDeviceToken();
    }

    return await apiClient.postData(
        AppConstants.tokenUrl, {"_method": "put", "fcm_token": deviceToken});
  }

  Future<String?> _saveDeviceToken() async {
    String? deviceToken = '@';
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {
      //
    }
    if (deviceToken != null) {}
    return deviceToken;
  }

  Future<Response?> forgetPassword(String email) async {
    return await apiClient
        .postData(AppConstants.forgotPassword, {'user_name': email});
  }

  Future<Response?> verifyOTPForForgotPassword(String email, String otp) async {
    return await apiClient.postData(
        AppConstants.verifyOTPForForgotPassword, {'email': email, 'otp': otp});
  }

  Future<Response?> resetPassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final uid = sharedPreferences.getString(AppConstants.uid);
    if (uid != null) {
      var body = {
        "pass": [
          {"existing": currentPassword, "value": newPassword}
        ]
      };
      return await apiClient.patchData(AppConstants.resetPassword(uid), body);
    }
    return null;
  }

  Future<Response?> verifyPhoneOTP(String phoneNumber, String otp) async {
    return await apiClient.postData(
        AppConstants.verifyPhoneOTP, {'phone': phoneNumber, 'otp': otp});
  }

  Future<Response?> resendPhoneOTP(String phoneNumber) async {
    return await apiClient
        .postData(AppConstants.resendPhoneOTP, {'phone': phoneNumber});
  }

  // login
  Future<Response?> getPhoneLoginOTP(String phoneNumber) async {
    return await apiClient
        .postData(AppConstants.getPhoneLoginOTP, {'phone': phoneNumber});
  }

  Future<Response?> verifyLoginPhoneOTP(String phoneNumber, String otp) async {
    return await apiClient.postData(
        AppConstants.verifyLoginPhoneOTP, {'phone': phoneNumber, 'otp': otp});
  }

  Future<Response?> verifyEmailOTP(String email, String otp) async {
    return await apiClient
        .postData(AppConstants.verifyEmailOTP, {"email": email, "otp": otp});
  }

  Future<Response?> resendEmailOTP(String email) async {
    return await apiClient
        .postData(AppConstants.resendEmailOTP, {'email': email});
  }

  Future<Response?> verifyPhone(String phone, String otp) async {
    return await apiClient
        .postData(AppConstants.verifyPhoneUrl, {"phone": phone, "otp": otp});
  }

  Future<bool?> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(
        token, sharedPreferences.getString(AppConstants.languageCode));
    return await sharedPreferences.setString(AppConstants.token, token);
  }

  Future<bool?> saveUserUid(String token) async {
    apiClient.updateHeader(
        null, sharedPreferences.getString(AppConstants.languageCode));
    return await sharedPreferences.setString(AppConstants.uid, token);
  }

  Future<bool?> saveUserCsrfToken(String token) async {
    apiClient.updateHeader(
        null, sharedPreferences.getString(AppConstants.languageCode));
    return await sharedPreferences.setString(AppConstants.csrfToken, token);
  }

  Future<bool?> saveLogoutToken(String token) async {
    apiClient.updateHeader(
        null, sharedPreferences.getString(AppConstants.languageCode));
    return await sharedPreferences.setString(AppConstants.logoutToken, token);
  }

  Future<bool?> saveCookie(String cookie) async {
    apiClient.updateHeader(
        null, sharedPreferences.getString(AppConstants.languageCode));
    return await sharedPreferences.setString(AppConstants.cookie, cookie);
  }

  String getUserToken() {
    return sharedPreferences.getString(AppConstants.token) ?? "";
  }

  String getUserUid() {
    return sharedPreferences.getString(AppConstants.uid) ?? "";
  }

  bool isLoggedIn() {
    return sharedPreferences.containsKey(AppConstants.token);
  }

  ///user address and language code should not be deleted
  bool clearSharedData() {
    sharedPreferences.remove(AppConstants.token);
    sharedPreferences.remove(AppConstants.csrfToken);
    sharedPreferences.remove(AppConstants.uid);
    sharedPreferences.remove(AppConstants.cookie);
    sharedPreferences.remove(AppConstants.logoutToken);
    apiClient.token = null;
    apiClient.updateHeader(null, AppConstants.languageCode);
    return true;
  }

  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try {
      await sharedPreferences.setString(AppConstants.userPassword, password);
      await sharedPreferences.setString(AppConstants.userNumber, number);
    } catch (e) {
      rethrow;
    }
  }

  String getUserNumber() {
    return sharedPreferences.getString(AppConstants.userNumber) ?? "";
  }

  String getUserPassword() {
    return sharedPreferences.getString(AppConstants.userPassword) ?? "";
  }

  bool isNotificationActive() {
    return sharedPreferences.getBool(AppConstants.notification) ?? true;
  }

  Future<bool> clearUserNumberAndPassword() async {
    await sharedPreferences.remove(AppConstants.userPassword);
    await sharedPreferences.remove(AppConstants.userCountryCode);
    return await sharedPreferences.remove(AppConstants.userNumber);
  }
}
