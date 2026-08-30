import 'package:flutter/material.dart';
import 'package:periodt/core/utilities/date_only.dart';
import 'package:periodt/core/utilities/range.dart';
import 'package:reactive_forms/reactive_forms.dart';

class SetupFormData {
  final String username;

  final Range<int> cycleLength;

  final Range<int> periodLength;

  final Range<DateOnly> lastPeriod;

  SetupFormData({
    required this.username,
    required this.cycleLength,
    required this.periodLength,
    required this.lastPeriod,
  });
}

class UserForm {
  final username = FormControl<String>(
    validators: [
      Validators.required,
      Validators.minLength(2),
      Validators.maxLength(128),
    ],
  );

  FormGroup build() => FormGroup({'username': username});
}

class CycleLengthForm {}

class SetupForm {
  final userPage = UserForm();

  late final form = FormGroup({'user': userPage.build()});
}
