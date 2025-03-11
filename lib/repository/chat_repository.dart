import 'dart:io';

import 'package:get/get_connect/http/src/response/response.dart';
import 'package:opencentric_lms/core/helper/help_me.dart';
import 'package:opencentric_lms/data/model/conversation/all_messages.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:opencentric_lms/data/model/conversation/discussion.dart';
import 'package:opencentric_lms/data/model/conversation/discussion_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/provider/client_api.dart';
import '../utils/app_constants.dart';

class ChatRepository {
  final ApiClient apiClient;
  ChatRepository(this.apiClient);

  //get discussion list
  Future<List<Discussion>> getDiscussion() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(AppConstants.uid);
    var body = {
      'user_id': uid,
    };
    final res =
        await apiClient.getData(AppConstants.listDiscussion, body: body);
    if (res.statusCode == 200) {
      if (res.body['data'] == null) {
        return [];
      }
      if (res.body['data']['list_message'] == null) {
        return [];
      }
      final mapRes = res.body['data']['list_message'] as Map<String, dynamic>;
      List<Discussion> discussionList = [];
      mapRes.forEach((key, value) {
        discussionList.add(Discussion.fromJson(key, value));
      });

      return discussionList;
    } else {
      return [];
    }
  }

  Future<DiscussionDetail> getListChat(String chatId) async {
    var body = {
      'private_message_id': chatId,
    };
    final res = await apiClient.getData(AppConstants.getListChat, body: body);
    final mapRes = res.body['data'] as Map<String, dynamic>;
    return DiscussionDetail.fromJson(mapRes);
  }

  Future<String> createMessage(List<String> listUserId, String message) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(AppConstants.uid);
    listUserId.add(uid ?? "");
    var body = {
      'list_user_id': listUserId,
      "own_id": uid,
      "message": message,
    };
    final res =
        await apiClient.postData(AppConstants.lmsPostPrivateMessage, body);
    if (res.body['data'] != null) {
      return res.body['data']['private_message_id'];
    } else {
      return "";
    }
  }

  Future<Response?> getConversationList() async {
    return await apiClient.getData(AppConstants.instructorsList);
  }

  //send message
  Future<Response> sendMessage(
      {required String receiverId,
      types.ImageMessage? imageMessage,
      types.FileMessage? fileMessage,
      types.TextMessage? textMessage}) async {
    var body = <String, dynamic>{};
    if (textMessage != null) {
      body = {'receiver_id': receiverId, 'msg': textMessage.text};
    } else if (imageMessage != null) {
      body = {'receiver_id': receiverId, 'file': imageMessage.uri};
      printLog("------image message uri: ${imageMessage.uri}");
    } else if (fileMessage != null) {
      body = {'receiver_id': receiverId, 'file': fileMessage.uri};
    }

    return await apiClient.postData(AppConstants.sendMessage, body);
  }

  Future<List<MessageData>?> getAllMessages(
      {required int discussionId, int page = 1}) async {
    var body = {
      "private_message_id": discussionId,
    };
    final response =
        await apiClient.getData(AppConstants.getListChat, body: body);
    return AllMessages.fromJson(response.body).data?.messages.data ?? [];
  }

  Future<Response> sendFile(
      {required File file, required String receiverId}) async {
    return await apiClient.postMultipartDataConversation(
        AppConstants.sendMessage, file, receiverId);
  }
}
