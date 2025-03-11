import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:opencentric_lms/components/custom_snackbar.dart';
import 'package:opencentric_lms/core/helper/route_helper.dart';

import 'package:opencentric_lms/data/model/user_model/user_data.dart';

import 'package:opencentric_lms/data/provider/checker_api.dart';
import 'package:opencentric_lms/repository/user_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/app_constants.dart';
import 'auth_controller.dart';
import 'cart_controller.dart';
import 'localization_controller.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  UserController({required this.userRepo});

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  // get input in screen
  var roleController = TextEditingController();
  //
  List genderList = ["Male", "Female"];
  String? selectGender;
  UserData? userData;

  File? _selectedImage;
  XFile? _selectedImageFile;
  File? get selectedImageUri => _selectedImage;
  XFile? get selectedImageFile => _selectedImageFile;
  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  bool isLoading = false;
  String uid = '';
  Future<void> getUserProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? token = sharedPreferences.getString(AppConstants.token);
    if (token == null) {
      userData = null;
      isLoading = false;
      update();
      return;
    }
    isLoading = true;
    update();
    uid = userRepo.getUserUid();
    final response = await userRepo.getUser(uid);
    userData = UserData();

    if (response != null && response.statusCode == 200) {
      List listUser = response.body["data"];
      if (listUser.isNotEmpty) {
        userData?.uid = uid;

        userData?.name =
            (listUser[0]['name'] != null && listUser[0]['name'].isNotEmpty)
                ? listUser[0]['name'][0]['value'] ?? ''
                : '';

        userData?.email =
            (listUser[0]['mail'] != null && listUser[0]['mail'].isNotEmpty)
                ? listUser[0]['mail'][0]['value'] ?? ''
                : '';

        userData?.phone = (listUser[0]['field_phone_number'] != null &&
                listUser[0]['field_phone_number'].isNotEmpty)
            ? listUser[0]['field_phone_number'][0]['value'] ?? ''
            : '';

        userData?.gender = (listUser[0]['field_gender'] != null &&
                listUser[0]['field_gender'].isNotEmpty)
            ? listUser[0]['field_gender'][0]['value'] ?? ''
            : '';

        userData?.dateOfBirth = (listUser[0]['field_date_of_birth'] != null &&
                listUser[0]['field_date_of_birth'].isNotEmpty)
            ? listUser[0]['field_date_of_birth'][0]['value'] ?? ''
            : '';

        userData?.roles = (listUser[0]['field_role'] != null && 
        listUser[0]['field_role'].isNotEmpty)
        ? listUser[0]['field_role'][0]['value'] ?? ''
        : '';

        emailController.text = userData?.email ?? 'email_address'.tr;
        phoneController.text = userData?.phone ?? 'phone_number'.tr;
        addressController.text = 'address'.tr;
        selectedDate = userData?.dateOfBirth ?? '';
        if (userData?.gender == null) {
          selectGender = genderList[0];
        } else {
          if (userData?.gender == "male") {
            selectGender = genderList[0];
          } else {
            selectGender = genderList[1];
          }
        }

        userData?.image = (listUser[0]['user_picture'] != null &&
                listUser[0]['user_picture'].isNotEmpty &&
                listUser[0]['user_picture']['picture_url'] != null)
            ? listUser[0]['user_picture']['picture_url']
            : '';

        userData?.firstName = (listUser[0]['field_first_name'] != null &&
                listUser[0]['field_first_name'].isNotEmpty)
            ? listUser[0]['field_first_name'][0]['value'] ?? ''
            : '';

        userData?.lastName = (listUser[0]['field_last_name'] != null &&
                listUser[0]['field_last_name'].isNotEmpty)
            ? listUser[0]['field_last_name'][0]['value'] ?? ''
            : '';

        userData?.profileId = (listUser[0]['profile_id'] != null &&
                listUser[0]['profile_id'].isNotEmpty)
            ? listUser[0]['profile_id'][0]['value'] ?? ''
            : '';

        userData?.roles =
            (listUser[0]['roles'] != null && listUser[0]['roles'].isNotEmpty)
                ? listUser[0]['roles'].last['target_id'] ?? ''
                : '';

        firstNameController.text = userData?.firstName ?? '';
        lastNameController.text = userData?.lastName ?? '';

        // set language
        final currentLanguageCode =
            sharedPreferences.getString(AppConstants.languageCode);
        final languageCode = currentLanguageCode ??
            ((listUser[0]['path'] != null && listUser[0]['path'].isNotEmpty)
                ? listUser[0]['path'][0]['langcode'] ?? ''
                : '');
        if (languageCode == "vi") {
          Get.find<LocalizationController>().setLanguage(Locale(
              AppConstants.languages[1].languageCode!,
              AppConstants.languages[1].countryCode));
          Get.find<LocalizationController>()
              .setSelectIndex(1, shouldUpdate: true);
        } else {
          Get.find<LocalizationController>().setLanguage(Locale(
              AppConstants.languages[0].languageCode!,
              AppConstants.languages[0].countryCode));
          Get.find<LocalizationController>()
              .setSelectIndex(0, shouldUpdate: true);
        }
      }
    } else if (response != null && response.statusCode == 403) {
      Get.find<AuthController>().clearSharedData();
      Get.find<CartController>().clearCartList();
      Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.splash));
    }

    isLoading = false;
    update();
  }

  void pickImage() async {
    XFile? image;
    image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      _selectedImage = File(image.path);
      _selectedImageFile = image;
    }
    update();
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1900, 1),
        lastDate: DateTime(2100));
    if (picked != null) {
      final f = DateFormat('yyyy-MM-dd');
      selectedDate = f.format(picked);
    }
    update();
  }

  void changeGenderSelection(String newValue) {
    selectGender = newValue;
    update();
  }

  Future<void> editProfile() async {
    isLoading = true;
    update();
    final uid = userRepo.getUserUid();
    final response = await userRepo.updateProfile(
      uid,
      firstNameController.text,
      lastNameController.text,
      fieldPhoneNumber: phoneController.text,
      // add field role for user
      fieldRole: roleController.text,
      //
      fieldGender: selectGender?.toLowerCase() ?? 'male',
      fieldDateOfBirth: selectedDate,
      userPictureBase64: _selectedImageFile != null
          ? base64Encode(await _selectedImageFile!.readAsBytes())
          : null,
    );

    if (response != null && response.statusCode == 200) {
      await getUserProfile();
      Get.back();
      customSnackBar('your_profile_update_successfully'.tr, isError: false);
    } else {}
    isLoading = false;
    update();
  }

//old
  Future removeUser() async {
    update();
    Response response = await userRepo.deleteUser();
    if (response.statusCode == 200) {
      customSnackBar('your_account_remove_successfully'.tr);
      Get.find<AuthController>().clearSharedData();
      Get.find<CartController>().clearCartList();
      Get.offAllNamed(RouteHelper.getSignInRoute(RouteHelper.profile));
    } else {
      Get.back();
      ApiChecker.checkApi(response);
    }
  }
}
