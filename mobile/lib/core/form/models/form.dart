import 'package:flutter/foundation.dart';
import 'package:periodt/core/form/models/field.dart';

/// Class which contains methods that help manipulate and manage
/// validity of [FormInput] instances.
class FormHelpers {
  /// Returns a [bool] given a list of [FormInput] indicating whether
  /// the inputs are all valid.
  static bool validate(List<PeriodtField> inputs) {
    return inputs.every((input) => input.isValid);
  }

  /// Returns a [bool] given a list of [FormInput] indicating whether
  /// all the inputs are pure.
  static bool isPure(List<PeriodtField> inputs) {
    return inputs.every((input) => input.touched == false);
  }
}

abstract class PeriodtFormState {
  /// Whether the [FormInput] values are all valid.
  bool get isValid => FormHelpers.validate(fields);

  /// Whether the [FormInput] values are not all valid.
  bool get isNotValid => !isValid;

  /// Whether all of the [FormInput] are pure.
  bool get isPure => FormHelpers.isPure(fields);

  /// Whether at least one of the [FormInput]s is dirty.
  bool get isDirty => !isPure;

  Listenable get listenable => Listenable.merge(fields);

  List<PeriodtField> get fields;
}

abstract class PeriodtFormPage extends PeriodtFormState {
  bool get skippable => false;
}
