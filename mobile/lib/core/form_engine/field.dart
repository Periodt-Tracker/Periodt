import 'package:flutter/material.dart';
import 'package:periodt/core/form_engine/field_state.dart';
import 'package:periodt/core/utilities/optional.dart';

/// A function that takes a value of type [T] and returns an error of type [E]
/// if the value is invalid, or `null` if it is valid.
///
typedef ValidatorFn<T, E> = E? Function(T? value);

/// A reactive form field that manages its own state, validation, and lifecycle.
///
/// Extends [ValueNotifier] so that individual UI components can listen to
/// granular changes without rebuilding the entire form.
///
abstract class PeriodtField<T, E> extends ChangeNotifier {
  /// The list of validation functions to run against the field's value.
  final List<ValidatorFn<T, E>> validators;

  PeriodtFieldState<T, E> _state;

  PeriodtField(T value, {this.validators = const []})
    : _state = PeriodtFieldState(value: value) {
    _validate(value);
  }

  T get value => _state.value;

  bool get isTouched => _state.touched;

  bool get isPure => !_state.dirty;

  bool get isValid => _state.error == null;

  bool get isError => !isValid;

  E? get error => _state.error;

  E? get displayError => _state.touched ? _state.error : null;

  /// Runs all validators against the provided [update] and updates the state.
  ///
  /// Breaks on the first validator that returns an error.
  void _validate(T update) {
    E? newError;

    for (final validator in validators) {
      newError = validator(update);
      if (newError != null) break;
    }

    _state = _state.copyWith(
      value: update,
      dirty: true,
      error: Optional.of(newError),
    );
  }

  void setValue(T update) {
    _validate(update);

    notifyListeners();
  }

  void touch() {
    if (_state.touched) {
      return;
    }

    _state = _state.copyWith(touched: true);
    notifyListeners();
  }
}
