import 'dart:io';

class Validators {
  
  static String? requiredField(String? value, {String fieldName = "هذا الحقل"}) {
    if (value == null || value.trim().isEmpty) {
      return "$fieldName is required";
    }
    return null;
  }
  static String? requiredFile(File? file) {
    if (file == null) {
      return "This file is required";
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "email is required";
    }

    const emailRegex =
        r"""^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$""";

    if (!RegExp(emailRegex).hasMatch(value.trim())) {
      return "email is not valid";
    }

    return null;
  }

  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "password is required";
    }

    if (value.length < 8) {
      return "password should be at least 8 charachters";
    }

    return null;
  }

  static String? confirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return "please confirm you password";
    }

    if (value != password) {
      return "password doesn't match";
    }

    return null;
  }

  // static String? phone(String? value) {
  //   if (value == null || value.trim().isEmpty) {
  //     return "phone is required";
  //   }

  //   if (!RegExp(r"^01[0-2,5]{1}[0-9]{8}$").hasMatch(value)) {
  //     return "phone is not valid";
  //   }

  //   return null;
  // }

  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Username is required";
    }

    if (value.trim().length < 2) {
      return "Username should be at least 2 characters";
    }

    return null;
  }
  
  
  static String? mustBeNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "This field is requried";
    }

  if (double.tryParse(value) == null || double.tryParse(value)! <= 0 ) {
    return "The field should be number";
  }

    return null;
  }
}
