import 'package:app/core/forms/engine/field.dart';
import 'package:app/core/forms/engine/validation_result.dart';

enum NameFieldError { empty, tooShort, tooLong }

class NameFieldInput extends PeriodtInput<String, String, NameFieldError> {
  const NameFieldInput.pure([super.value = '']) : super.pure();

  const NameFieldInput.dirty(super.value) : super.dirty();

  @override
  ValidationResult<String, NameFieldError> validate(String value) {
    if (value.isEmpty) {
      return const Invalid(NameFieldError.empty);
    } else if (value.length < 2) {
      return const Invalid(NameFieldError.tooShort);
    } else if (value.length > 50) {
      return const Invalid(NameFieldError.tooLong);
    }

    return Valid(value);
  }
}
