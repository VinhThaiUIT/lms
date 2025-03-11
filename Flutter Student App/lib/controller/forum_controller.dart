import 'dart:convert';
import 'package:get/get.dart';
import 'package:opencentric_lms/components/custom_snackbar.dart';
import 'package:opencentric_lms/components/loading_dialog.dart';
import 'package:opencentric_lms/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/forum/forum_model.dart';
import '../data/model/forum/forum_topic_model.dart';
import '../data/model/forum/topic_model.dart';
import '../network_service.dart';
import '../repository/forum_repository.dart';

class ForumController extends GetxController implements GetxService {
  ForumController();
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isLoadingForumDetail = false;
  bool get isLoadingForumDetail => _isLoadingForumDetail;

  bool _isLoadingTopicDetail = false;
  bool get isLoadingTopicDetail => _isLoadingTopicDetail;

  List<ForumModel> listForum = [];
  List<ForumTopicModel> listTopic = [];
  TopicModel? topic;
  String? forumId;
  // training
  Future<void> handleRefresh() async{
    getForum();
    saveForumOffline();
  }
  //
  getForum() async {
    _isLoading = true;
    final response = await ForumRepository(Get.find()).getForum();

    listForum = response;

    // store list of forum in shared preference
    _isLoading = false;
    update();
  }

  saveForumOffline() async {
    final response = await ForumRepository(Get.find()).getForumOffline();

    List<ForumModel> list = response;

    // store list of forum in shared preference
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setStringList(
        'forum', list.map((e) => json.encode(e.toJson())).toList());
    _isLoading = false;
    update();
  }

  getForumOffline() async {
    _isLoading = true;

    // get list of forum from shared preference
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final forumList = sharedPreferences.getStringList('forum');
    if (forumList != null) {
      listForum =
          forumList.map((e) => ForumModel.fromJson(json.decode(e))).toList();
    }

    _isLoading = false;
    update();
  }

  getListTopic(String forumId) async {
    this.forumId = forumId;
    final isConnected = await NetworkService().checkInternetConnection();
    if (!isConnected) {
      _isLoadingForumDetail = true;
      listTopic = listForum
          .firstWhere((element) => element.id == forumId)
          .listForumTopic;
      _isLoadingForumDetail = false;
      update();
    } else {
      _isLoadingForumDetail = true;
      final response = await ForumRepository(Get.find()).getListTopic(forumId);
      listTopic = response;
      _isLoadingForumDetail = false;
      update();
    }
  }

  getTopic(String topicId) async {
    _isLoadingTopicDetail = true;
    final isConnected = await NetworkService().checkInternetConnection();
    if (!isConnected) {
      final forumTopic = listForum
          .firstWhere(
              (e) => e.listForumTopic.any((element) => element.id == topicId))
          .listForumTopic
          .firstWhere((element) => element.id == topicId);
      final forumComment = listForum
          .firstWhere(
              (e) => e.listForumTopic.any((element) => element.id == topicId))
          .listComment;
      topic = TopicModel(
        id: forumTopic.id,
        title: forumTopic.title,
        body: forumTopic.body,
        created: forumTopic.created,
        forumId: forumId ?? "",
        listComment: forumComment,
      );
    } else {
      final response = await ForumRepository(Get.find()).getTopic(topicId);
      topic = response;
    }

    _isLoadingTopicDetail = false;
    update();
  }

  createForum(String subject, String forumId, String body) async {
    final isConnected = await NetworkService().checkInternetConnection();
    if (!isConnected) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString(AppConstants.createForumOffline,
          json.encode({'subject': subject, 'forumId': forumId, 'body': body}));
      customSnackBar("Your topic will be posted when you are online",
          isError: false);
    } else {
      LoadingDialog.show(Get.context!);
      await ForumRepository(Get.find()).createForum(subject, forumId, body);
      LoadingDialog.hide(Get.context!);
      getForum();
      getListTopic(forumId);
      Get.back();
    }
  }

  createComment(
      String subject, String forumId, String body, String topic) async {
    final isConnected = await NetworkService().checkInternetConnection();
    if (!isConnected) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      await sharedPreferences.setString(
          AppConstants.createCommentOffline,
          json.encode({
            'subject': subject,
            'topic': topic,
            'body': body,
            'forumId': forumId
          }));
      customSnackBar("Your topic will be posted when you are online",
          isError: false);
    } else {
      LoadingDialog.show(Get.context!);

      await ForumRepository(Get.find()).createComment(subject, topic, body);
      LoadingDialog.hide(Get.context!);
    }

    // Get.back();
    getTopic(topic);
    getListTopic(forumId);
    getForum();
  }
}
