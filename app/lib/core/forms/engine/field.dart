import 'package:app/core/forms/engine/validation_result.dart';
import 'package:flutter/material.dart';

typedef DynamicPeriodtInput = PeriodtInput<dynamic, dynamic, dynamic>;

@immutable
abstract class PeriodtInput<RawValue, Value, E> {
  const PeriodtInput._({required this.value, required this.touched});

  const PeriodtInput.pure(RawValue value)
    : this._(value: value, touched: false);

  const PeriodtInput.dirty(RawValue value)
    : this._(value: value, touched: true);

  final RawValue value;
  final bool touched;

  bool get isPure => !touched;
  bool get isDirty => touched;

  ValidationResult<Value, E> get _result => validate(value);

  E? get error => switch (_result) {
    Invalid(:final error) => error,
    Valid() => null,
  };

  Value? get transformed => switch (_result) {
    Valid(:final value) => value,
    Invalid() => null,
  };

  /// Error only if the field has been touched — mirrors formz's displayError,
  /// kept separate from `error` since some UI wants "is it valid" without "should I show it yet".
  E? get displayError => touched ? error : null;

  bool get isError => error != null;
  bool get isValid => !isError;

  /// Safer than `transformed!` at a call site — the branch you're in is the proof.
  T? fold<T>({
    required T Function(Value value) valid,
    required void Function(E error) invalid,
  }) {
    switch (_result) {
      case Valid(:final value):
        return valid(value);
      case Invalid(:final error):
        invalid(error);
        return null;
    }
  }

  ValidationResult<Value, E> validate(RawValue value);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other.runtimeType == runtimeType &&
          other is PeriodtInput<RawValue, Value, E> &&
          other.value == value &&
          other.touched == touched);

  @override
  int get hashCode => Object.hash(runtimeType, value, touched);
}
