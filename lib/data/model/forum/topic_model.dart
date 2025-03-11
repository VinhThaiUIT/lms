// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'forum_comment_model.dart';

class TopicModel {
  String id;
  String title;
  String body;
  String created;
  String forumId;
  List<ForumCommentModel> listComment;

  TopicModel({
    required this.id,
    required this.title,
    required this.body,
    required this.created,
    required this.forumId,
    required this.listComment,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['nid'][0]['value'],
      title: json['title'][0]['value'],
      body: json['body'][0]['value'] ?? "",
      created: json['created'][0]['value'],
      forumId: json['taxonomy_forums'][0]['target_id'],
      listComment: json['comments'] != null
          ? (json['comments'] as List)
              .map((e) => ForumCommentModel.fromJson(e))
              .toList()
          : [],
    );
  }
}
