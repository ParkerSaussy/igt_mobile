import 'package:get/get.dart';

import 'label_key.dart';

class TextFieldValidation {
// EMAIL VALIDATION
  static validateEmail(String value) {
    if (value.isEmpty) {
      return LabelKeys.blankEmail.tr;
    }
    if (value.isEmail == false) {
      return LabelKeys.invalidEmail.tr;
    }
    return;
  }

  // PASSWORD VALIDATION
  static validatePassword(String value) {
    if (value.trim().isEmpty) {
      return LabelKeys.blankPassword.tr;
    }
    if (value.trim().length < 8) {
      return LabelKeys.inCorrectPassword.tr;
    }
    return;
  }

  // CONFORM PASSWORD VALIDATION
  static validateConformPassword(String value, oldPassword) {
    if (value.trim().isEmpty) {
      return LabelKeys.blankConfirmNewPassword.tr;
    }
    if (value.trim().length < 8) {
      return LabelKeys.inCorrectPassword.tr;
    }
    if (value != oldPassword) {
      return LabelKeys.inCorrectConfirmAndNewPassword.tr;
    }
    return;
  }

  // MOBILE NUMBER VALIDATION
  static validatePhoneNumber(String value) {
    if (value.trim().isEmpty) {
      return LabelKeys.blankMobileNumber.tr;
    }
    if (!GetUtils.isPhoneNumber(value)) {
      return LabelKeys.invalidMobileNumber.tr;
    }
    return;
  }

  // FIRST NAME VALIDATION
  static validateFirstName(String value) {
    if (value.trim().isEmpty) {
      return LabelKeys.blankFirstName.tr;
    }
    return;
  }

  // LAST NAME VALIDATION
  static validateLastName(String value) {
    if (value.trim().isEmpty) {
      return LabelKeys.blankLastName.tr;
    }
    return;
  }

  // FIRST NAME VALIDATION
  static validateUserName(String value) {
    if (value.trim().isEmpty) {
      return LabelKeys.blankUserName.tr;
    }
    return;
  }
}
