

import 'package:flutter/material.dart';

abstract class Validation<T> {
  const Validation();
  String? validate(BuildContext context, T? value);
}

abstract class ValidationPassword<T> {
  const ValidationPassword();
  String? validate(BuildContext context, T? password, T? confirm);
}

class RequiredValidation<T> extends Validation<T> {
  const RequiredValidation();
  @override
  String? validate(BuildContext context, T? value) {
    if(value == null) {
      return 'The field is required';
    }
    if(value is String && (value as String).isEmpty) {
      return 'The field is required';
    }
    return null;
  }
}

class EmailValidation<T> extends Validation<String> {
  const EmailValidation();
  @override 
  String? validate(BuildContext context, String? value) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$';
    final emailRegex = RegExp(pattern);
    if(value == null) return null;
    if(!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }
}
class PhoneValidation<T> extends Validation<String> {
  const PhoneValidation();
  @override 
  String? validate(BuildContext context, String? value) {
    String pattern = r'(^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$)';
    final emailRegex = RegExp(pattern);
    if(value == null) return null;
    if(!emailRegex.hasMatch(value)) {
      return 'Please enter a valid phone';
    }
    return null;
  }
}


class Validator {
  Validator._();
  static FormFieldValidator<T> apply<T>(
    BuildContext context,
    List<Validation<T>> validations
  ) {
    return (T? value) {
      for(final validation in validations) {
        final error = validation.validate(context, value);
        if(error != null) return error;
      }
      return null;
    };
  }
}