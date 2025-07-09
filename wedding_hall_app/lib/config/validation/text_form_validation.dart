import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import 'regux.dart';

class TextFormValidation {
  static bool nullOrEmpty(String? value) => value == null || value.isEmpty;

  static String? isNullOrEmptyValidator(
    BuildContext context, {
    required String? value,
  }) {
    if (nullOrEmpty(value)) {
      return S.of(context).fieldMustNotBeNull;
    }
    return null;
  }

  static String? emailValidator(
    BuildContext context, {
    required String? value,
  }) {
    if (nullOrEmpty(value)) {
      return S.of(context).emailMustNotBeEmpty;
    }
    if (!Regux.emailRegExp.hasMatch(value!)) {
      return S.of(context).enterValidEmail;
    }
    return null;
  }

  static String? verifyCodeValidator(
    BuildContext context, {
    required String? value,
    required int maxLength,
  }) {
    if (nullOrEmpty(value)) {
      return S.of(context).fieldMustNotBeNull;
    }
    if (value!.length < maxLength) {
      return S.of(context).verifcationCodeIsNotCompleted;
    }
    return null;
  }

  static String? passwordValidate(
    BuildContext context, {
    required String? value,
  }) {
    if (nullOrEmpty(value)) {
      return S.of(context).passwordMustNotBeEmpty;
    }
    if (value!.length < 8) {
      return S.of(context).passwordMoreThanEightCharacters;
    }
    if (!Regux.capital.hasMatch(value)) {
      return S.of(context).passwordMustHaveOneCapitalLetter;
    }
    if (!Regux.small.hasMatch(value)) {
      return S.of(context).passwordMustHaveOneSmallLetter;
    }
    if (!Regux.number.hasMatch(value)) {
      return S.of(context).passwordMustHaveOneNumber;
    }
    if (!Regux.special.hasMatch(value)) {
      return S.of(context).passwordMustHaveoneSpecialCharacters;
    }
    return null;
  }

  static String? confirmPasswordValidation(
    BuildContext context, {
    required String password,
    required String confirmPassword,
  }) {
    if (nullOrEmpty(confirmPassword)) {
      return S.of(context).confirmPasswordMustNoBeEmpty;
    }
    if (password != confirmPassword) {
      return S.of(context).passwordNotMatch;
    }
    return null;
  }
}
