// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:opencentric_lms/components/custom_snackbar.dart';
import 'package:opencentric_lms/components/error_dialog.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';
import 'package:opencentric_lms/data/model/signup_body.dart';
import 'package:opencentric_lms/repository/auth_repo.dart';

import '../core/initial_binding/initial_binding.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  // final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool? _acceptTerms = false;
  bool get isLoading => _isLoading;
  bool? get acceptTerms => _acceptTerms;


  // upload avatar for sign in
  File? _avatar;
  File? get avatarController => _avatar;
  ///TextEditingController for signUp screen
  //
  var firstnameController = TextEditingController();
  //
  var usernameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var passwordController = TextEditingController();
  // training
  String? get getPass  => passwordController.value.text;
  //
  var confirmPasswordController = TextEditingController();
  dynamic countryDialCodeForSignup;

  ///textEditingController for signIn screen
  var signInEmailController = TextEditingController();
  var signInPasswordController = TextEditingController();
  dynamic countryDialCodeForSignIn;

  ///TextEditingController for forgot password
  var contactNumberController = TextEditingController();
  final String _mobileNumber = '';

  String get mobileNumber => _mobileNumber;

  ///TextEditingController for new pass screen
  var newPasswordController = TextEditingController();
  var confirmNewPasswordController = TextEditingController();

  ///TextEditingController for change pass screen
  final currentPasswordControllerForChangePasswordScreen =
      TextEditingController();
  final newPasswordControllerForChangePasswordScreen = TextEditingController();
  final confirmPasswordControllerForChangePasswordScreen =
      TextEditingController();

  int languageCode = 0;

  @override
  void onInit() {
    super.onInit();
    usernameController.text = '';
    lastNameController.text = '';
    emailController.text = '';
    phoneController.text = '';
    passwordController.text = '';
    confirmPasswordController.text = '';
    contactNumberController.text = '';
    newPasswordController.text = '';
    confirmNewPasswordController.text = '';
    contactNumberController.text = '';
    signInEmailController.text = getUserNumber();
    signInPasswordController.text = getUserPassword();
  }

  clear() {
    usernameController.clear();
    lastNameController.clear();
    emailController.clear();
    phoneController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    contactNumberController.clear();
    newPasswordController.clear();
    confirmNewPasswordController.clear();
    currentPasswordControllerForChangePasswordScreen.clear();
    newPasswordControllerForChangePasswordScreen.clear();
    confirmPasswordControllerForChangePasswordScreen.clear();
  }

  fetchUserNamePassword() {
    signInEmailController.text = getUserNumber();
    signInPasswordController.text = getUserPassword();
  }

  _hideKeyboard() => FocusManager.instance.primaryFocus?.unfocus();

  bool _isValidPassword() {
    return passwordController.value.text ==
        confirmPasswordController.value.text;
  }
// upload image use for custom signUp screen (training)
  Future<void> choosePicture() async{
    final ImagePicker picker = ImagePicker();
    final XFile? imagePicker = await picker.pickImage(source: ImageSource.gallery);
    if (imagePicker != null) {
      _avatar = File(imagePicker.path);
      update();
    }
  }
  int checkStrengthPassword(pass) {
    RegExp lv1 = RegExp(r'^[a-zA-Z0-9]');
    RegExp lv2 = RegExp(r'^[a-zA-Z0-9]!@#$%^&*');
    int strength = 0;
    if (pass!.length >= 6) {
      strength++;
    }
    if (pass!.length >= 6 && lv1.hasMatch(pass!)) {
      strength++;
    }
    if (pass!.length >= 6 && lv2.hasMatch(pass!)) {
      strength++;
    }
    return strength;
  }
  //
  Future<void> registration() async {
    try {
      _hideKeyboard();
      _isLoading = true;
      update();
      SignUpBody signUpBody = SignUpBody(
        uName: usernameController.value.text,
        email: emailController.value.text,
        pass: passwordController.value.text,
        // training add more field
        firstName: firstnameController.value.text,
        lastName: lastNameController.value.text,
        phone: phoneController.value.text,
        avatar: avatarController,
        //
        language: languageCode,
      );
      if (!_isValidPassword()) {
        customSnackBar('password_missmatch'.tr);
        _isLoading = false;
        update();
        return;
      }
      Response? response = await authRepo.registration(signUpBody);
      if (response != null && response.statusCode == 200) {
        usernameController.clear();
        emailController.clear();
        //
        phoneController.clear();
        firstnameController.clear();
        lastNameController.clear();
        //
        confirmPasswordController.clear();
        passwordController.clear();
        Get.offAllNamed(RouteHelper.getSignInRoute("fromSplash"));
        customSnackBar(
            "Registration successful, please view your registration email to verify your account",
            isError: false);
      } else {
        customSnackBar(response?.statusText ?? "Error", isError: true);
      }

      _isLoading = false;
      update();
    } catch (e) {
      _isLoading = false;
      update();
      ErrorDialog.show(Get.context, registration);
    }
  }

  Future<void> login() async {
    try {
      _hideKeyboard();
      _isLoading = true;
      update();
      Response? response = await authRepo.login(
          email: signInEmailController.text.trim(),
          password: signInPasswordController.value.text);
      if (response != null && response.statusCode == 200) {
        // Extract and save the session cookie
        String? setCookie = response.headers?['set-cookie'];
        if (setCookie != null) {
          // Optionally, you can parse the cookie string to extract the session cookie value
          String sessionCookie = setCookie.split(';')[0];
          await authRepo.saveCookie(sessionCookie);
        }
        String token = response.body['access_token'];
        await authRepo.saveUserToken(token);
        String csrfToken = response.body['csrf_token'];
        await authRepo.saveUserCsrfToken(csrfToken);
        String logoutToken = response.body['logout_token'];
        await authRepo.saveLogoutToken(logoutToken);
        // Decode the JWT
        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        String uid = decodedToken['drupal']['uid'];
        await authRepo.saveUserUid(uid);
        signInEmailController.clear();
        passwordController.clear();
        //
        print("user id: ${uid}");
        //
        Get.offAllNamed(RouteHelper.getMainRoute("0"));
      } else {
        customSnackBar(response?.statusText ?? "Error", isError: true);
      }
      _isLoading = false;
      update();
    } catch (e) {
      _isLoading = false;
      update();
      ErrorDialog.show(Get.context, login);
    }
  }

  Future<void> logout() async {
    try {
      _hideKeyboard();
      _isLoading = true;
      update();
      await authRepo.logout();

      // Reinitialize the bindings
      InitialBinding().dependencies();
      _isLoading = false;
      update();
    } catch (e) {
      _isLoading = false;
      update();
      customSnackBar(e.toString(), isError: true);
    }
  }

  //forgot password
  Future<void> forgetPassword() async {
    try {
      if (emailController.value.text.isEmpty) return;
      _hideKeyboard();
      _isLoading = true;
      update();
      Response? response =
          await authRepo.forgetPassword(emailController.value.text);
      if (response!.statusCode == 200) {
        customSnackBar("Forgot password successful, verify email is sent",
            isError: false);
        Get.offAllNamed(RouteHelper.getSignInRoute("fromSplash"));
      } else {
        if (response.statusCode == 422) {
          customSnackBar(response.body['data']['email'][0].toString());
        } else {
          customSnackBar(response.body['message']);
        }
      }
      _isLoading = false;
      update();
    } catch (e) {
      _isLoading = false;
      update();
      ErrorDialog.show(Get.context, login);
    }
  }

  //verify OTP for forgot password
  Future<void> verifyOTPForForgotPassword(String email) async {
    _hideKeyboard();
    _isLoading = true;
    update();
    String otp = verificationCode;
    Response? response = await authRepo.verifyOTPForForgotPassword(email, otp);
    if (response != null && response.body['success'] == true) {
      Get.toNamed(RouteHelper.newPasswordScreen);
    } else {
      if (response!.statusCode == 422) {
        customSnackBar(response.body['data']['email'][0].toString());
      } else {
        customSnackBar(response.body['message']);
      }
    }
    _isLoading = false;
    update();
  }

  //reset password
  Future<void> resetPassword() async {
    _hideKeyboard();
    _isLoading = true;
    update();
    String password =
        currentPasswordControllerForChangePasswordScreen.value.text;
    String confirmPassword =
        confirmPasswordControllerForChangePasswordScreen.value.text;

    Response? response = await authRepo.resetPassword(
      currentPassword: password,
      newPassword: confirmPassword,
    );
    if (response != null && response.statusCode == 200) {
      currentPasswordControllerForChangePasswordScreen.clear();
      confirmPasswordControllerForChangePasswordScreen.clear();
      verificationCode == "";
      emailController.clear();
      passwordController.clear();
      Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.changePassword));
      customSnackBar("Change password successfully, please login again",
          isError: false);
    } else {
      if (response!.statusCode == 422) {
        customSnackBar(response.body['data']['password'][0].toString());
      } else {
        customSnackBar(response.body['message']);
      }
    }
    _isLoading = false;
    update();
  }

  Future<void> updateToken() async {
    await authRepo.updateToken();
  }

  Future<void> verifyPhoneOtp(String phoneNumber) async {
    _isLoading = true;
    update();
    String otp = verificationCode;
    Response? response = await authRepo.verifyPhoneOTP(phoneNumber, otp);
    if (response != null && response.body['success']) {
      RouteHelper.getSignInRoute(RouteHelper.signIn);
      customSnackBar(response.body['message'], isError: false);
    } else {
      customSnackBar(response?.body['message']);
    }
    _isLoading = false;
    update();
  }

  Future<void> resendPhoneOTP(String phoneNumber) async {
    Response? response = await authRepo.resendPhoneOTP(phoneNumber);
    if (response != null && response.body['success'] == true) {
      customSnackBar(response.body['message'], isError: false);
    }
  }

  //login
  Future<void> getPhoneLoginOTP() async {
    String phoneNumber = phoneController.value.text;
    if (phoneNumber.isEmpty) return;
    _isLoading = true;
    update();
    Response? response = await authRepo.getPhoneLoginOTP(phoneNumber);
    if (response != null && response.statusCode == 200) {
      if (response.body['success'] == true) {
        Get.toNamed(RouteHelper.verificationScreen,
            arguments: {'number': phoneController.value.text, 'isLogin': true});
        phoneController.clear();
      }
      customSnackBar(response.body['message'], isError: false);
    } else {
      customSnackBar(response?.body['data']['phone'][0].toString());
    }
    _isLoading = false;
    update();
  }

  Future<void> verifyLoginPhoneOtp(String phoneNumber) async {
    _isLoading = true;
    update();
    String otp = verificationCode;
    Response? response = await authRepo.verifyLoginPhoneOTP(phoneNumber, otp);
    if (response != null && response.body['success']) {
      String token = response.body['data']['token'];
      authRepo.saveUserToken(token);
      // await authRepo.updateToken();
      Get.offAllNamed(RouteHelper.getMainRoute("0"));
    } else {
      customSnackBar(response?.body['data']['phone'][0].toString() ??
          response?.body['data']['otp'][0].toString());
    }
    _isLoading = false;
    update();
  }

  Future<void> verifyEmailOTP(String email) async {
    _isLoading = true;
    update();
    Response? response =
        await authRepo.verifyEmailOTP(email, _verificationCode);
    if (response != null && response.body['success']) {
      String token = response.body['data']['token'];
      authRepo.saveUserToken(token);
      // await authRepo.updateToken();
      usernameController.clear();
      lastNameController.clear();
      emailController.clear();
      passwordController.clear();
      confirmPasswordController.clear();
      Get.offAllNamed(RouteHelper.getMainRoute("0"));
    } else {
      customSnackBar(response?.body['message']);
    }
    _isLoading = false;
    update();
  }

  Future<bool> resendEmailOTP(String email) async {
    Response? response = await authRepo.resendEmailOTP(email);
    if (response != null && response.body['success'] == true) {
      customSnackBar(response.body['message'], isError: false);
      return true;
    }
    customSnackBar(response?.body['message'], isError: false);
    return false;
  }

  Future appleAuth() async {}

  String _verificationCode = '';
  String _otp = '';
  String get otp => _otp;
  String get verificationCode => _verificationCode;

  void updateVerificationCode(String query) {
    _verificationCode = query;
    if (_verificationCode.isNotEmpty) {
      _otp = _verificationCode;
    }
    update();
  }

  bool _isActiveRememberMe = false;
  bool get isActiveRememberMe => _isActiveRememberMe;

  void toggleTerms() {
    _acceptTerms = !_acceptTerms!;
    update();
  }

  void toggleRememberMe() {
    _isActiveRememberMe = !_isActiveRememberMe;
    update();
  }

  bool isLoggedIn() {
    return authRepo.isLoggedIn();
  }

  bool clearSharedData() {
    return authRepo.clearSharedData();
  }

  void saveUserNumberAndPassword(String number, String password) {
    authRepo.saveUserNumberAndPassword(number, password);
  }

  String getUserNumber() {
    return authRepo.getUserNumber();
  }

  String getUserPassword() {
    return authRepo.getUserPassword();
  }

  Future<bool> clearUserNumberAndPassword() async {
    return authRepo.clearUserNumberAndPassword();
  }

  String getUserToken() {
    return authRepo.getUserToken();
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // GoogleSignIn? _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? googleAccount;
  GoogleSignInAuthentication? auth;

  Future<void> socialLogin() async {}

  //facebook auth
  Future<void> facebookAuth() async {
    _isLoading = true;
    update();
    try {} catch (e) {
      customSnackBar(e.toString());
      _isLoading = false;
      update();
    }

    _isLoading = false;
    update();
  }

  Future<void> googleLogout() async {
    googleAccount = (await _googleSignIn.signOut())!;
    auth = await googleAccount!.authentication;
  }

  Future<void> facebookLogout() async {}
}
