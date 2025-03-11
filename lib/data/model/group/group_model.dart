// ignore_for_file: public_member_api_docs, sort_constructors_first
class GroupModel {
  String id;
  String name;
  String description;

  GroupModel({
    required this.id,
    required this.name,
    required this.description,
  });

  factory GroupModel.fromJson(Map<String, dynamic> json) {
    return GroupModel(
      id: json['id'][0]['value'],
      name: json['label'][0]['value'],
      description: json['field_description'][0]['value'] ?? "",
    );
  }
}
