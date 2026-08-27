import 'package:app/core/forms/engine/field.dart';
import 'package:app/core/forms/engine/validation_result.dart';
import 'package:app/core/utilities/date.dart';

enum BirthdayFieldError { inFuture, required, tooOld }

class BirthdayFieldInput
    extends PeriodtInput<DateOnly?, DateOnly, BirthdayFieldError> {
  const BirthdayFieldInput.pure([super.value]) : super.pure();

  const BirthdayFieldInput.dirty(super.value) : super.dirty();

  @override
  ValidationResult<DateOnly, BirthdayFieldError> validate(DateOnly? value) {
    if (value == null) {
      return const Invalid(BirthdayFieldError.required);
    }

    final now = DateOnly.now();

    if (value.isAfter(now)) {
      return const Invalid(BirthdayFieldError.inFuture);
    }

    return Valid(value);
  }
}
