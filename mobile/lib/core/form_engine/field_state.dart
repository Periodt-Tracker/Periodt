import 'package:flutter/material.dart';
import 'package:periodt/core/utilities/optional.dart';

@immutable
class PeriodtFieldState<Type, Error> {
  final Type value;

  final bool touched;

  final bool dirty;

  final Error? error;

  const PeriodtFieldState({
    required this.value,
    this.error,
    this.touched = false,
    this.dirty = false,
  });

  bool get isValid => error == null;

  bool get isError => !isValid;

  Error? get displayError => touched ? error : null;

  PeriodtFieldState<Type, Error> copyWith({
    Type? value,
    bool? touched,
    bool? dirty,
    Optional<Error>? error,
  }) {
    return PeriodtFieldState(
      value: value ?? this.value,
      touched: touched ?? this.touched,
      dirty: dirty ?? this.dirty,
      error: error == null ? this.error : error.value,
    );
  }

  @override
  int get hashCode => Object.hash(value, touched, dirty, error);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PeriodtFieldState<Type, Error> &&
        other.value == value &&
        other.touched == touched &&
        other.dirty == dirty &&
        other.error == error;
  }
}
