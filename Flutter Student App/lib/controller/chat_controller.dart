import 'package:get/get.dart';
import 'package:opencentric_lms/components/loading_dialog.dart';
import 'package:opencentric_lms/data/model/conversation/all_messages.dart';
import 'package:opencentric_lms/data/model/conversation/chat_list.dart';
import 'package:opencentric_lms/repository/chat_repository.dart';

import '../data/model/conversation/discussion.dart';
import '../data/model/conversation/discussion_detail.dart';

class ChatController extends GetxController implements GetxService {
  bool isLoadingInstructorsList = false;
  List<ConversationUser> chatList = [];

  final List<MessageData> _messageList = [];
  List<MessageData> get messageList => _messageList;

  bool isLoadingDiscussion = true;
  final List<Discussion> _listDiscussion = [];
  List<Discussion> get listDiscussion => _listDiscussion;

  bool isLoadingDiscussionDetail = true;
  DiscussionDetail? discussionDetail;

  getListDiscussion() async {
    isLoadingDiscussion = true;
    final response = await ChatRepository(Get.find()).getDiscussion();
    _listDiscussion.clear();
    _listDiscussion.addAll(response.toList());
    isLoadingDiscussion = false;
    update();
  }

  getDiscussionDetail(String id) async {
    isLoadingDiscussionDetail = true;
    final response = await ChatRepository(Get.find()).getListChat(id);
    discussionDetail = response;
    isLoadingDiscussionDetail = false;
    update();
  }

  Future<String> createMessage(
    List<String> listUserId,
    String message,
  ) async {
    LoadingDialog.show(Get.context!);
    final response =
        await ChatRepository(Get.find()).createMessage(listUserId, message);
    if (response.isNotEmpty) {
      await getDiscussionDetail(response);
    }
    LoadingDialog.hide(Get.context!);
    update();

    return response;
  }

  Future<void> getInstructorsList() async {
    isLoadingInstructorsList = true;
    update();
    final response = await ChatRepository(Get.find()).getConversationList();
    if (response != null && response.statusCode == 200) {
      ChatList data = ChatList.fromJson(response.body);
      chatList.clear();
      chatList.addAll(data.data!);
    }

    isLoadingInstructorsList = false;
    update();
  }
}
