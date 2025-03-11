import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/group/group_detail_model.dart';
import '../data/model/group/group_model.dart';
import '../data/provider/client_api.dart';
import '../utils/app_constants.dart';

class GroupRepository {
  final ApiClient apiClient;
  GroupRepository(this.apiClient);

  Future<List<GroupModel>> getGroup() async {
    List<GroupModel> listForum = [];
    final res = await apiClient.getData(AppConstants.getGroup);
    final mapRes = res.body['data'] as Map<String, dynamic>;
    mapRes.forEach((key, value) {
      listForum.add(GroupModel.fromJson(value as Map<String, dynamic>));
    });

    return listForum;
  }

  Future<GroupDetailModel> getGroupDetail(String groupId) async {
    final res = await apiClient.getData(
      AppConstants.getGroupDetail(groupId),
    );
    final mapRes = res.body['data'];
    GroupDetailModel group =
        GroupDetailModel.fromJson(mapRes as Map<String, dynamic>);
    return group;
  }

  Future<void> requestJoinGroup(String groupId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(AppConstants.uid);
    var body = {
      "user_id": uid,
      "group_id": groupId,
    };
    await apiClient.postData(
      AppConstants.requestJoinGroup,
      body,
    );
  }

  Future<void> adminUpdateRequest(String groupId, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(AppConstants.uid);
    var body = {
      "group_id": groupId,
      "user_id": uid,
      "user_change_status": status,
    };
    await apiClient.postData(
      AppConstants.adminUpdateRequest,
      body,
    );
  }

  Future<void> lmsGroupRemoveMember(String groupId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(AppConstants.uid);
    var body = {
      "group_id": groupId,
      "user_id": uid,
    };
    await apiClient.postData(
      AppConstants.lmsGroupRemoveMember,
      body,
    );
  }

  Future<void> addGroupMember(String groupId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(AppConstants.uid);
    var body = {
      "group_id": groupId,
      "user_id": uid,
    };
    await apiClient.postData(
      AppConstants.addGroupMember,
      body,
    );
  }

  Future<void> inviteMember(String groupId, String userEmail) async {
    var body = {
      "group_id": groupId,
      "user_email": userEmail,
    };
    await apiClient.postData(
      AppConstants.addGroupMember,
      body,
    );
  }

  Future<bool> checkAdminGroup() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString(AppConstants.uid);
      var body = {
        "type": "check_request_membership_permission",
        "user_id": uid,
      };
      final res = await apiClient.postData(
        AppConstants.checkAdminGroup,
        body,
      );
      final isAdmin = res.body['result'] ?? false;
      return isAdmin;
    } catch (e) {
      return false;
    }
  }

  Future<bool> checkIsRequestJoinGroup(String groupId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString(AppConstants.uid);
      var body = {
        "group_id": groupId,
      };
      final res = await apiClient.getData(
        AppConstants.getListRequestJoinGroup,
        body: body,
      );
      final listRequest = res.body['data'];
      bool isRequest = false;
      if (listRequest is Map<String, dynamic>) {
        listRequest.forEach((key, value) {
          if (key == uid) {
            isRequest = true;
            return;
          }
        });
      }
      return isRequest;
    } catch (e) {
      return false;
    }
  }
}
