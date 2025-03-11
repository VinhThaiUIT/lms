import 'message.dart';

class Discussion {
  String? id;
  List<UserChat>? members;
  LastMessage? lastMessage;
  Discussion({this.members, this.id, this.lastMessage});

  factory Discussion.fromJson(String id, Map<String, dynamic> json) {
    List<UserChat> members = [];
    json["members"].forEach((key, value) {
      members.add(UserChat.fromJson(value));
    });

    return Discussion(
      id: id,
      members: members,
      lastMessage:
          LastMessage.fromJson(json['last_message'] as Map<String, dynamic>),
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

class LastMessage {
  String id;
  Message message;
  String createdAt;

  LastMessage({
    required this.id,
    required this.message,
    required this.createdAt,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) => LastMessage(
        id: json['private_message_id'] as String,
        message: Message.fromLMS(json['message'][0] as Map<String, dynamic>),
        createdAt: json['created'] as String,
      );

  Map<String, Object?> toJson() => {
        'private_message_id': id,
        'message': message.toJson(),
        'created': createdAt,
      };
}
