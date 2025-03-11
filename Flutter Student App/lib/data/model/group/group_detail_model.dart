// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../forum/forum_topic_model.dart';
import '../forum/topic_model.dart';

class GroupDetailModel {
  String id;
  String name;
  String description;
  List<TopicModel> listForumTopic;
  List<Member> listMember = [];
  GroupDetailModel({
    required this.id,
    required this.name,
    required this.description,
    required this.listForumTopic,
    required this.listMember,
  });

  factory GroupDetailModel.fromJson(Map<String, dynamic> json) {
    List<TopicModel> listTopic = [];
    final mapRes = json['forums'] as Map<String, dynamic>;

    mapRes.forEach((key, value) {
      listTopic.add(TopicModel.fromJson(value as Map<String, dynamic>));
    });
    List<Member> list = [];
    final mapResMember = json['members'] as Map<String, dynamic>;

    mapResMember.forEach((key, value) {
      list.add(Member.fromJson(value as Map<String, dynamic>));
    });

    return GroupDetailModel(
      id: json['id'][0]['value'],
      name: json['label'][0]['value'],
      description: json['field_description'][0]['value'] ?? "",
      listForumTopic: listTopic,
      listMember: list,
    );
  }
}

class Member {
  String id;
  String name;

  Member({
    required this.id,
    required this.name,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      id: json['uid'][0]['value'] ?? "",
      name: json['name'][0]['value'] ?? "",
    );
  }
}
