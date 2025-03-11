class Faq {
	int? id;
	String? question;
	String? answer;

	Faq({this.id, this.question, this.answer});

	factory Faq.fromJson(Map<String, dynamic> json) => Faq(
				id: json['id'] as int?,
				question: json['field_question'][0]['value'] as String?,
				answer: json['field_answer'][0]['value'] as String?,
			);

	Map<String, Object?> toJson() => {
				'id': id,
				'field_question': question,
				'field_answer': answer,
			};
}
