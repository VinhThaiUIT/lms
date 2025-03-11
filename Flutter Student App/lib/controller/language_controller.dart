import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/data/model/response/language_model.dart';
import 'package:opencentric_lms/repository/language_repo.dart';
import 'package:opencentric_lms/utils/app_constants.dart';

class LanguageController extends GetxController implements GetxService {
  LanguageController({required this.languageRepo});
  final LanguageRepo languageRepo;
  int _selectIndex = 0;
  int get selectIndex => _selectIndex;

  void setSelectIndex(int index) {
    _selectIndex = index;
    update();
  }

  List<LanguageModel> _languages = [];
  List<LanguageModel> get languages => _languages;

  void searchLanguage(String query, BuildContext context) {
    if (query.isEmpty) {
      _languages.clear();
      _languages = AppConstants.languages;
      update();
    } else {
      _selectIndex = -1;
      _languages = [];

      for (var product in AppConstants.languages) {
        if (product.languageName!.toLowerCase().contains(query.toLowerCase())) {
          _languages.add(product);
        }
      }
      update();
    }
  }

  void initializeAllLanguages(BuildContext context) {
    if (_languages.isEmpty) {
      _languages.clear();
      _languages = AppConstants.languages;
    }
  }
}
