// ignore_for_file: public_member_api_docs, sort_constructors_first
class ForumCommentModel {
  String id;
  String subject;
  String body;
  String created;

  ForumCommentModel({
    required this.id,
    required this.subject,
    required this.body,
    required this.created,
  });

  factory ForumCommentModel.fromJson(Map<String, dynamic> json) {
    return ForumCommentModel(
      id: json['cid'][0]['value'],
      subject: json['subject'][0]['value'],
      body: json['comment_body'][0]['value'] ?? "",
      created: json['created'][0]['value'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cid': [
        {'value': id}
      ],
      'subject': [
        {'value': subject}
      ],
      'comment_body': [
        {'value': body}
      ],
      'created': [
        {'value': created}
      ],
    };
  }
}
