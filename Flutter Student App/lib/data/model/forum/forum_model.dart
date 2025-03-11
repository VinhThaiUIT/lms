// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:opencentric_lms/data/model/forum/forum_topic_model.dart';

import 'forum_comment_model.dart';

class ForumModel {
  String id;
  String name;
  String description;
  String parents;
  String numberTopics;
  int numPosts;
  LastPost lastPost;
  List<ForumTopicModel> listForumTopic;
  List<ForumCommentModel> listComment;

  ForumModel({
    required this.id,
    required this.name,
    required this.description,
    required this.parents,
    required this.numberTopics,
    required this.numPosts,
    required this.lastPost,
    required this.listForumTopic,
    required this.listComment,
  });

  factory ForumModel.fromJson(Map<String, dynamic> json) {
    List<ForumTopicModel> listForumTopic = [];
    if (json['topics'] != null) {
      if (json['topics'] is List) {
        final listRes = json['topics'] as List;
        for (var element in listRes) {
          listForumTopic
              .add(ForumTopicModel.fromJson(element as Map<String, dynamic>));
        }
      } else if (json['topics'] is Map) {
        final mapRes = json['topics'] as Map<String, dynamic>;
        mapRes.forEach((key, value) {
          listForumTopic
              .add(ForumTopicModel.fromJson(value as Map<String, dynamic>));
        });
      }
    }
    List<ForumCommentModel> listComment = [];
    if (json['comments'] != null) {
      if (json['comments'] is List) {
        final listRes = json['comments'] as List;
        for (var element in listRes) {
          listComment
              .add(ForumCommentModel.fromJson(element as Map<String, dynamic>));
        }
      } else if (json['comments'] is Map) {
        final mapRes = json['comments'] as Map<String, dynamic>;
        mapRes.forEach((key, value) {
          listComment
              .add(ForumCommentModel.fromJson(value as Map<String, dynamic>));
        });
      }
    }
    return ForumModel(
      id: json['tid'][0]['value'],
      name: json['name'][0]['value'],
      description: json['description'][0]['value'] ?? "",
      parents: json['parents'][0],
      numberTopics: json['num_topics'] is int
          ? json['num_topics'].toString()
          : json['num_topics'],
      numPosts: json['num_posts'],
      lastPost: LastPost.fromJson(json['last_post']),
      listForumTopic: listForumTopic,
      listComment: listComment,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tid': [
        {'value': id}
      ],
      'name': [
        {'value': name}
      ],
      'description': [
        {'value': description}
      ],
      'parents': [parents],
      'num_topics': numberTopics,
      'num_posts': numPosts,
      'last_post': lastPost.toJson(),
      'topics': listForumTopic.map((e) => e.toJson()).toList(),
      'comments': listComment.map((e) => e.toJson()).toList(),
    };
  }
}

class LastPost {
  String name;
  String uid;
  String created;
  LastPost({
    required this.name,
    required this.uid,
    required this.created,
  });

  factory LastPost.fromJson(Map<String, dynamic> json) {
    return LastPost(
      name: json['name'] ?? "",
      uid: json['uid'] ?? "",
      created: json['created'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'uid': uid,
      'created': created,
    };
  }
}
