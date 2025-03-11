class Option {
  String answer = '';
  String id = '';
  int isCorrect = 0;

  Option({required this.id, required this.answer, required this.isCorrect});

  Option.fromJson(Map<String, dynamic> value) {
    answer = value['name'];
    id = value['target_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = answer;
    data['target_id'] = id;

    return data;
  }
}
