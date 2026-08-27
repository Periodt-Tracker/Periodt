import 'package:app/core/forms/engine/field.dart';
import 'package:app/core/forms/engine/form_helpers.dart';

mixin PeriodtFormMixin<T> {
  /// Whether the [FormzInput] values are all valid.
  bool get isValid => FormHelpers.validate(inputs);

  /// Whether the [FormzInput] values are not all valid.
  bool get isNotValid => !isValid;

  /// Whether all of the [FormzInput] are pure.
  bool get isPure => FormHelpers.isPure(inputs);

  /// Whether at least one of the [FormzInput]s is dirty.
  bool get isDirty => !isPure;

  /// Returns all [FormzInput] instances.
  ///
  /// Override this and give it all [FormzInput]s in your class that should be
  /// validated automatically.
  List<DynamicPeriodtInput> get inputs;
}
