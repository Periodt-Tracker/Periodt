import 'package:app/core/forms/engine/field.dart';

class FormHelpers {
  /// Returns a [bool] given a list of [FormzInput] indicating whether
  /// the inputs are all valid.
  static bool validate(List<DynamicPeriodtInput> inputs) {
    return inputs.every((input) => input.isValid);
  }

  /// Returns a [bool] given a list of [FormzInput] indicating whether
  /// all the inputs are pure.
  static bool isPure(List<DynamicPeriodtInput> inputs) {
    return inputs.every((input) => input.isPure);
  }
}
