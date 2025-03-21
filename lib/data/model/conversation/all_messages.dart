class AllMessages {
  late Data? data;

  AllMessages({required this.data});

  AllMessages.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null ? Data.fromJson(json['data']) : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['data'] = this.data?.toJson();
    return data;
  }
}

class Data {
  late Messages messages;

  Data({required this.messages});

  Data.fromJson(Map<String, dynamic> json) {
    messages = (json['private_messages'] != null
        ? Messages.fromJson(json['private_messages'])
        : null)!;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['private_messages'] = messages.toJson();
    return data;
  }
}

class Messages {
  List<MessageData>? data;
  bool? hasMoreData;

  Messages({this.data, required this.hasMoreData});

  Messages.fromJson(Map<String, dynamic> json) {
    List<MessageData> data = [];
    json.forEach((key, value) {
      data.add(MessageData.fromJson(value));
    });
    // if (json['data'] != null) {
    //   data = <MessageData>[];
    //   json['data'].forEach((v) {
    //     data!.add(MessageData.fromJson(v));
    //   });
    // }
    hasMoreData = json['has_more_data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['has_more_data'] = hasMoreData;
    return data;
  }
}

class MessageData {
  String? id;
  String? senderName;
  String? senderImage;
  String? receiverName;
  int? receiverId;
  String? receiverImage;
  String? message;
  String? type;
  int? page;
  int? lastPage;
  bool? isFile;
  bool? isImage;
  String? fileType;
  bool? isVideo;
  String? fileSize;
  bool? fileExist;
  String? fileUrl;
  DateTime? createdAt;

  MessageData(
      {this.id,
      this.senderName,
      this.senderImage,
      this.receiverName,
      this.receiverId,
      this.receiverImage,
      this.message,
      this.type,
      this.page,
      this.lastPage,
      this.isFile,
      this.isImage,
      this.fileType,
      this.isVideo,
      this.fileSize,
      this.fileExist,
      this.fileUrl,
      this.createdAt});

  MessageData.fromJson(Map<String, dynamic> json) {
    id = json['private_message_id'];
    senderName = json['sender_name'];
    senderImage = json['sender_image'];
    receiverName = json['receiver_name'];
    receiverId = json['receiver_id'];
    receiverImage = json['receiver_image'];
    message = json['message'][0]["value"];
    type = json['type'];
    page = json['page'];
    lastPage = json['last_page'];
    isFile = json['is_file'];
    isImage = json['is_image'];
    fileType = json['file_type'];
    isVideo = json['is_video'];
    fileSize = json['file_size'];
    fileExist = json['file_exist'];
    fileUrl = json['file_url'];
    createdAt =
        DateTime.fromMicrosecondsSinceEpoch(int.tryParse(json['created']) ?? 0);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['sender_name'] = senderName;
    data['sender_image'] = senderImage;
    data['receiver_name'] = receiverName;
    data['receiver_id'] = receiverId;
    data['receiver_image'] = receiverImage;
    data['message'] = message;
    data['type'] = type;
    data['page'] = page;
    data['last_page'] = lastPage;
    data['is_file'] = isFile;
    data['is_image'] = isImage;
    data['file_type'] = fileType;
    data['is_video'] = isVideo;
    data['file_size'] = fileSize;
    data['file_exist'] = fileExist;
    data['file_url'] = fileUrl;
    data['created_at'] = createdAt;
    return data;
  }
}
