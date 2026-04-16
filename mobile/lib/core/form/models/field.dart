import 'package:flutter/foundation.dart';
import 'package:periodt/core/widgets/form/validator/base.dart';

@immutable
class PeriodtFieldState<T, E> {
  final T value;
  final bool touched;
  final bool dirty;
  final E? error;

  const PeriodtFieldState({
    required this.value,
    this.error,
    this.touched = false,
    this.dirty = false,
  });

  bool get isValid => error == null;

  bool get isNotValid => !isValid;

  E? get displayError => error;

  PeriodtFieldState<T, E> copyWith({T? value, bool? touched, E? error}) {
    return PeriodtFieldState(
      value: value ?? this.value,
      touched: touched ?? this.touched,
      dirty: true,
      error: error,
    );
  }

  @override
  int get hashCode => Object.hashAll([value, touched, dirty]);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) {
      return false;
    }

    return other is PeriodtFieldState<T, E> &&
        other.value == value &&
        other.touched == touched &&
        other.dirty == dirty;
  }
}

class PeriodtField<T, E> extends ValueNotifier<PeriodtFieldState<T, E>> {
  final List<ValidatorFn<T, E>> validators;

  PeriodtField(T value, {required this.validators})
    : super(PeriodtFieldState(value: value));

  T get field => value.value;

  bool get touched => value.touched;

  bool get isValid => value.isValid;

  E? get displayError => value.displayError;

  E? _runValidators(T? value) {
    for (final validator in validators) {
      final error = validator(value);

      if (error != null) {
        return error;
      }
    }

    return null;
  }

  void setValue(T update) {
    final error = _runValidators(update);

    value = value.copyWith(value: update, error: error);
  }

  void touch() {
    value = value.copyWith(touched: true);
  }
}
