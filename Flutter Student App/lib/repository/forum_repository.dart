import 'package:opencentric_lms/data/model/forum/forum_model.dart';
import 'package:opencentric_lms/data/model/forum/forum_topic_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/model/forum/topic_model.dart';
import '../data/provider/client_api.dart';
import '../utils/app_constants.dart';

class ForumRepository {
  final ApiClient apiClient;
  ForumRepository(this.apiClient);

  Future<List<ForumModel>> getForum() async {
    List<ForumModel> listForum = [];
    final res = await apiClient.getData(AppConstants.getForum);
    final mapRes = res.body['data'] as Map<String, dynamic>;
    mapRes.forEach((key, value) {
      listForum.add(ForumModel.fromJson(value as Map<String, dynamic>));
    });

    return listForum;
  }

  Future<List<ForumModel>> getForumOffline() async {
    List<ForumModel> listForum = [];
    final res = await apiClient.getData(AppConstants.lmsGetForumsOffline);
    final mapRes = res.body['forums'] as Map<String, dynamic>;
    mapRes.forEach((key, value) {
      listForum.add(ForumModel.fromJson(value as Map<String, dynamic>));
    });

    return listForum;
  }

  Future<List<ForumTopicModel>> getListTopic(String forumId) async {
    List<ForumTopicModel> list = [];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(AppConstants.uid);
    var body = {
      "forum_id": forumId,
      "user_id": uid,
    };
    final res = await apiClient.getData(
      AppConstants.getListTopic,
      body: body,
    );
    final mapRes = res.body['data'] as Map<String, dynamic>;

    mapRes.forEach((key, value) {
      list.add(ForumTopicModel.fromJson(value as Map<String, dynamic>));
    });
    print('Get lsit topic function --- forum repo');
    return list;
  }

  Future<TopicModel> getTopic(String topicId) async {
    final res = await apiClient.getData(
      AppConstants.getTopic(topicId),
    );
    print('Get topic function --- forum repo');
    final mapRes = res.body['data'];
    TopicModel topic = TopicModel.fromJson(mapRes as Map<String, dynamic>);
    return topic;
  }

  Future<void> createForum(
      String subject, String forumId, String bodyString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(AppConstants.uid);
    var body = {
      "subject": subject,
      "body": bodyString,
      "forum_id": forumId,
      "user_id": uid,
    };
    await apiClient.postData(
      AppConstants.createForum,
      body,
    );
  }

  Future<void> createComment(
      String subject, String forumId, String bodyString) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString(AppConstants.uid);
    var body = {
      "subject": subject,
      "comment_body": bodyString,
      "forum_id": forumId,
      "user_id": uid
    };
    await apiClient.postData(
      AppConstants.createComment,
      body,
    );
  }
}
