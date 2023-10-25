import 'package:flutter/cupertino.dart';

class Validators {

  static final FormFieldValidator<String> EMAIL_VALIDATOR = (value) {
    if (value.length < 4 || !value.contains("@") || !value.contains(".")) {
      return "A valid email must be provided";
    }

    return null;
  };

  static final FormFieldValidator<String> PASSWORD_VALIDATOR = (value) {
    if (value.length < 6) {
      return "Password must be more than 6 characters";
    } else
    if (!value.contains(RegExp("[^A-Za-z0-9]"))) {
      return "Password must contain a special character";
    } else if (!value.contains(RegExp("[0-9]"))) {
      return "Password must contain a number";
    }

    return null;
  };

  static final FormFieldValidator<String> NOT_EMPTY_VALIDATOR = (value) {
    if (value.isEmpty) {
      return "Field must not be empty";
    }
    return null;
  };

}