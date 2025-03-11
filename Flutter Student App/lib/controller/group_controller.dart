import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/loading_dialog.dart';
import 'package:opencentric_lms/controller/user_controller.dart';
import 'package:opencentric_lms/repository/group_repository.dart';

import '../data/model/group/group_detail_model.dart';
import '../data/model/group/group_model.dart';

class GroupController extends GetxController implements GetxService {
  GroupController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingGroupDetail = false;
  bool get isLoadingGroupDetail => _isLoadingGroupDetail;
  List<GroupModel> listGroup = [];
  GroupDetailModel? groupModel;
  bool isJoined = false;
  bool isRequest = false;
  getGroup() async {
    _isLoading = true;
    update();
    final res = await GroupRepository(Get.find()).getGroup();
    listGroup = res;
    _isLoading = false;
    update();
  }

  getGroupDetail(String groupId) async {
    _isLoadingGroupDetail = true;
    groupModel = await GroupRepository(Get.find()).getGroupDetail(groupId);

    final name = Get.find<UserController>().userData?.name ?? "";
    final index =
        groupModel?.listMember.indexWhere((e) => e.name == name) ?? false;
    if (index != -1) {
      isJoined = true;
    } else {
      isJoined = false;
    }

    isRequest = await checkIsRequestJoinGroup(groupId);
    _isLoadingGroupDetail = false;
    update();
  }

  requestJoinGroup(String groupId) async {
    LoadingDialog.show(Get.context!);
    await GroupRepository(Get.find()).requestJoinGroup(groupId);
    await getGroupDetail(groupId);
    LoadingDialog.hide(Get.context!);
  }

  Future<bool> checkIsRequestJoinGroup(String groupId) async {
    return await GroupRepository(Get.find()).checkIsRequestJoinGroup(groupId);
  }

  adminUpdateRequest(String groupId, String status) async {
    LoadingDialog.show(Get.context!);
    await GroupRepository(Get.find()).adminUpdateRequest(groupId, status);
    LoadingDialog.hide(Get.context!);
    getGroupDetail(groupId);
  }

  lmsGroupRemoveMember(String groupId) async {
    LoadingDialog.show(Get.context!);
    await GroupRepository(Get.find()).lmsGroupRemoveMember(groupId);
    LoadingDialog.hide(Get.context!);
    getGroupDetail(groupId);
  }

  addGroupMember(String groupId) async {
    LoadingDialog.show(Get.context!);
    await GroupRepository(Get.find()).addGroupMember(groupId);
    LoadingDialog.hide(Get.context!);
    getGroupDetail(groupId);
  }

  checkAdmin() async {
    final value = await GroupRepository(Get.find()).checkAdminGroup();
    return value;
  }

  inviteMember(String groupId, String userEmail) async {
    final value =
        await GroupRepository(Get.find()).inviteMember(groupId, userEmail);
    return value;
  }
}
