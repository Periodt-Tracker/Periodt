import 'package:flutter/foundation.dart';

/// A sentinel value used to explicitly represent the removal of an error.
///
/// This allows [PeriodtFieldState.copyWith] to distinguish between a missing
/// `error` parameter (meaning "keep the current error") and an explicit request
/// to clear the error (meaning "set the error to null").
class ClearError {}

/// An internal default sentinel value used in [PeriodtFieldState.copyWith].
class Default {
  const Default();
}

/// Represents the immutable state of a single form field at a given moment in time.
@immutable
class PeriodtFieldState<T, E> {
  /// The current value of the field.
  final T value;

  /// Whether the user has interacted with the field (e.g., blurred or typed).
  /// Used to determine if validation errors should be displayed to the user.
  final bool touched;

  /// Whether the field's value has been modified since initialization.
  final bool dirty;

  /// The current validation error for this field, if any.
  final E? error;

  /// Creates a new [PeriodtFieldState].
  const PeriodtFieldState({
    required this.value,
    this.error,
    this.touched = false,
    this.dirty = false,
  });

  /// Returns `true` if the field currently has no validation errors.
  bool get isValid => error == null;

  /// Returns `true` if the field currently has a validation error.
  bool get isNotValid => !isValid;

  /// Returns the error only if the field has been touched.
  /// This prevents showing errors to the user before they've interacted with the field.
  E? get displayError => touched ? error : null;

  /// Creates a copy of this state with the given fields replaced with the new values.
  PeriodtFieldState<T, E> copyWith({
    T? value,
    bool? touched,
    bool? dirty,
    Object? error = const Default(),
  }) {
    return PeriodtFieldState(
      value: value ?? this.value,
      touched: touched ?? this.touched,
      dirty: dirty ?? this.dirty,
      // If error is explicitly ClearError, set to null.
      // If it wasn't passed (Default), keep the old error.
      // Otherwise, cast the new error to E?.
      error: error is ClearError
          ? null
          : (error != const Default() ? error as E? : this.error),
    );
  }

  @override
  int get hashCode => Object.hash(value, touched, dirty, error);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PeriodtFieldState<T, E> &&
        other.value == value &&
        other.touched == touched &&
        other.dirty == dirty &&
        other.error == error;
  }
}
