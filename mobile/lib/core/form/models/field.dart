import 'package:flutter/foundation.dart';
import 'field_state.dart';

/// A function that takes a value of type [T] and returns an error of type [E]
/// if the value is invalid, or `null` if it is valid.
typedef ValidatorFn<T, E> = E? Function(T? value);

/// A reactive form field that manages its own state, validation, and lifecycle.
///
/// Extends [ValueNotifier] so that individual UI components can listen to
/// granular changes without rebuilding the entire form.
class PeriodtField<T, E> extends ValueNotifier<PeriodtFieldState<T, E>> {
  /// The list of validation functions to run against the field's value.
  final List<ValidatorFn<T, E>> validators;

  /// Creates a new [PeriodtField] with an initial [value].
  ///
  /// Validators are run immediately upon initialization so that the initial
  /// validity state is accurate before any user interaction.
  PeriodtField(T value, {this.validators = const []})
    : super(PeriodtFieldState(value: value)) {
    _validate(value);
  }

  /// Convenience getter for the underlying field value.
  T get field => value.value;

  /// Convenience getter indicating if the field has been touched.
  bool get touched => value.touched;

  /// Convenience getter indicating if the field is currently valid.
  bool get isValid => value.isValid;

  /// Convenience getter for the displayable error (returns null if untouched).
  E? get displayError => value.displayError;

  /// Runs all validators against the provided [update] and updates the state.
  ///
  /// Breaks on the first validator that returns an error.
  void _validate(T update) {
    E? newError;
    for (final validator in validators) {
      newError = validator(update);
      if (newError != null) break;
    }

    value = value.copyWith(
      value: update,
      dirty: true,
      error: newError ?? ClearError(),
    );
  }

  /// Updates the field's value and triggers validation.
  void setValue(T update) {
    _validate(update);
  }

  /// Marks the field as touched, allowing validation errors to be displayed.
  void touch() {
    if (!value.touched) {
      value = value.copyWith(touched: true);
    }
  }
}
