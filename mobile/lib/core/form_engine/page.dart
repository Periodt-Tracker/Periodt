import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:periodt/core/form_engine/field.dart';

abstract class PeriodtWizardPage extends ChangeNotifier {
  bool _previousValidState = false;

  PeriodtWizardPage() {
    for (var field in fields) {
      field.addListener(_onFieldChanged);
    }

    _previousValidState = isValid;
  }

  List<PeriodtField> get fields;

  void _onFieldChanged() {
    final currentValidState = isValid;

    // Because we dont notify listeners of the actual errors on each
    // field change, as long as only the overall validity of the page
    // changes, we notify listeners.
    //
    if (_previousValidState != currentValidState) {
      _previousValidState = currentValidState;
      notifyListeners();
    }
  }

  /// Returns `true` if every field on this page is valid.
  bool get isValid => fields.every((field) => field.isValid);

  /// Returns `true` if no fields on this page have been touched.
  bool get isPure => fields.every((field) => !field.isTouched);

  /// Returns `true` if at least one field on this page has been touched.
  bool get isDirty => !isPure;

  void touchAll() {
    for (var field in fields) {
      field.touch();
    }

    notifyListeners();
  }

  @override
  void dispose() {
    for (var field in fields) {
      field.removeListener(_onFieldChanged);
      field.dispose();
    }
    super.dispose();
  }
}
