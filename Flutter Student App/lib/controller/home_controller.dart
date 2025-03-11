import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/error_dialog.dart';
import 'package:opencentric_lms/data/model/course_not_purchased_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/common/course.dart';
import '../data/model/home_data_model/home_data_model.dart';
import '../repository/home_repository.dart';
import '../utils/app_constants.dart';
import '../utils/enum.dart';

class HomeController extends GetxController implements GetxService {
  HomeController({required this.homeRepository});

  final HomeRepository homeRepository;
  HomeDataModel? _homeModel;
  HomeDataModel? get homeModel => _homeModel;
  AppState _appState = AppState.loading;
  AppState get appState => _appState;

  int? _currentIndex = 0;
  int? get currentIndex => _currentIndex;
  final List<Course> _latestCourseList = [];
  List<Course>? get latestCourseList => _latestCourseList;

  bool _isLoadingMoreData = false;
  bool get isLoadingMoreData => _isLoadingMoreData;
  final List<Course> _listMyCourse = [];
  List<Course>? get listMyCourse => _listMyCourse;
  @override
  void onInit() {
    getHomeData();
    getLatestCourseList();
    super.onInit();
  }

  Future<void> getHomeData() async {
    // _isLoading = true;
    // _homeModel == null;
    // update();
    // final response = await homeRepository.getHomeData();
    // if (response != null && response.statusCode == 200) {
    //   if (response.body['success'] == true) {
    //     HomeDataModel data = HomeDataModel.fromJson(response.body);
    //     _homeModel = data;
    //   } else {
    //     customSnackBar(response.body['message']);
    //   }
    // } else {
    //   customSnackBar(response?.body?['message']);
    // }
    // _isLoading = false;
    // update();
  }

  Future<void> getCourseNotPurchase() async {
    try {
      _appState = AppState.loading;
      update();
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      final uid = sharedPreferences.getString(AppConstants.uid) ?? "";
      final response = await homeRepository.getCourseNotPurchase(uid);

      if (response != null && response.statusCode == 200) {

        final data = response.body['data'];
        List<Course> listCourse = [];
        if (data is List) {
          listCourse = [];
        } else {
          listCourse =
              List<Course>.from((data as Map<String, dynamic>).values.map((e) {
            return Course.fromJsonCourseDetail(e);
          }));
        }
        _appState = AppState.loaded;
        _listMyCourse.clear();
        _listMyCourse.addAll(listCourse);
        update();
      }
    } catch (e) {
      _appState = AppState.error;
      update();
      ErrorDialog.show(Get.context, getCourseNotPurchase);
    }
  }

  Future<void> getLatestCourseList() async {
    // final response = await homeRepository.getLatestCourse(_pageNumber);
    // if (response != null && response.statusCode == 200) {
    //   LatestCourseList list = LatestCourseList.fromJson(response.body);
    //   _latestCourseList.addAll(list.data!.courses!);
    //   if (list.data!.courses!.isNotEmpty) {
    //     _pageNumber++;
    //   }
    //   update();
    // }
  }

  Future<void> paginate() async {
    _isLoadingMoreData = true;
    update();
    await getLatestCourseList();
    _isLoadingMoreData = false;
    update();
  }

  void setCurrentIndex(int index, bool notify) {
    _currentIndex = index;
    if (notify) {
      update();
    }
  }
}
