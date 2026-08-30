import 'package:freezed_annotation/freezed_annotation.dart';

part 'field.freezed.dart';

@freezed
abstract class FormField<T> with _$FormField<T> {
  const FormField._();

  const factory FormField({
    T? value,
    @Default([]) List<String? Function(T?)> validators,
    @Default(false) bool touched,
    @Default(false) bool dirty,
  }) = _FormField<T>;

  String? error() {
    for (final validator in validators) {
      final result = validator(value);

      if (result != null) {
        return result;
      }
    }

    return null;
  }

  bool isValid() {
    final result = error();

    return result == null;
  }

  FormField<T> setValue(T? value) => copyWith(value: value, dirty: true);

  FormField<T> touch() => copyWith(touched: true, dirty: true);
}
