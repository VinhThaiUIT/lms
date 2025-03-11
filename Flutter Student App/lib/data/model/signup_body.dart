import 'dart:io';

class SignUpBody {
  String? uName;
  String? email;
  String? pass;
  int? language;
  // training add more field
  String? firstName;
  String? lastName;
  String? phone;
  File? avatar;


  SignUpBody({
    this.uName,
    this.email = '',
    this.pass = '',
    this.language = 0,
    // training
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.avatar,
  });

  SignUpBody.fromJson(Map<String, dynamic> json) {
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = {'value': uName};
    data['mail'] = {'value': email};
    data['pass'] = {'value': pass};
    // training add more field
    data['field_first_name'] = {'value': firstName};
    data['field_last_name'] = {'value': lastName};
    data['field_phone_number'] = {'value': phone};
    data['files'] = {'value' : avatar};
    if (language == 0) {
      data['field_langcode_app'] = {'value': 'en'};
    } else {
      data['field_langcode_app'] = {'value': 'vi'};
    }

    return data;
  }

  Map<String, dynamic> toJsonForPhone() {
    final Map<String, dynamic> data = <String, dynamic>{};
    return data;
  }
}
