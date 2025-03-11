import 'message.dart';

class DiscussionDetail {
  int? id;
  List<UserChat>? members;
  String? subject;
  List<PrivateMessage>? privateMessage;
  DiscussionDetail({this.members, this.id, this.subject, this.privateMessage});

  factory DiscussionDetail.fromJson(Map<String, dynamic> json) {
    List<UserChat> members = [];
    json["members"].forEach((key, value) {
      members.add(UserChat.fromJson(value));
    });
    List<PrivateMessage> privateMessage = [];
    json["private_messages"].forEach((key, value) {
      privateMessage.add(PrivateMessage.fromJson(value));
    });

    return DiscussionDetail(
      id: json['id'],
      members: members,
      subject: json['subject'],
      privateMessage: privateMessage,
    );
  }

  Map<String, Object?> toJson() => {
        'data': members?.map((e) => e.toJson()).toList(),
      };
}

class UserChat {
  String userId;
  String userName;
  String email;

  UserChat({
    required this.userId,
    required this.userName,
    required this.email,
  });

  factory UserChat.fromJson(Map<String, Object?> json) => UserChat(
        userId: json['user_id'] as String,
        userName: json['name'] as String,
        email: json['email'] as String,
      );

  Map<String, Object?> toJson() => {
        'user_id': userId,
        'uname': userName,
        'email': email,
      };
}

class PrivateMessage {
  String id;
  List<Message> message;
  String createdAt;

  PrivateMessage({
    required this.id,
    required this.message,
    required this.createdAt,
  });

  factory PrivateMessage.fromJson(Map<String, dynamic> json) => PrivateMessage(
        id: json['private_message_id'] as String,
        message: (json['message'] as List)
            .map((e) => Message.fromLMS(e as Map<String, dynamic>))
            .toList(),
        createdAt: json['created'] as String,
      );

  Map<String, Object?> toJson() => {
        'private_message_id': id,
        'message': message.map((e) => e.toJson()).toList(),
        'created': createdAt,
      };
}
