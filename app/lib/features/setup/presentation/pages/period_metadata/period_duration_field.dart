import 'package:app/core/forms/engine/field.dart';
import 'package:app/core/forms/engine/validation_result.dart';

enum PeriodDurationFieldError { required, tooShort, tooLong }

class PeriodDurationFieldInput
    extends PeriodtInput<int?, int, PeriodDurationFieldError> {
  const PeriodDurationFieldInput.pure([super.value]) : super.pure();

  const PeriodDurationFieldInput.dirty(super.value) : super.dirty();

  @override
  ValidationResult<int, PeriodDurationFieldError> validate(int? value) {
    if (value == null) {
      return const Invalid(PeriodDurationFieldError.required);
    }

    if (value < 1) {
      return const Invalid(PeriodDurationFieldError.tooShort);
    }

    if (value > 18) {
      return const Invalid(PeriodDurationFieldError.tooLong);
    }

    return Valid(value);
  }
}
