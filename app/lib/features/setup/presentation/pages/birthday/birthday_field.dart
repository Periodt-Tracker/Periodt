import 'package:app/core/forms/engine/field.dart';
import 'package:app/core/forms/engine/validation_result.dart';
import 'package:app/core/utilities/date.dart';
import 'package:clock/clock.dart';

enum BirthdayFieldError { inFuture, required, tooOld }

class BirthdayFieldInput
    extends PeriodtInput<DateTime?, DateOnly, BirthdayFieldError> {
  const BirthdayFieldInput.pure([super.value]) : super.pure();

  const BirthdayFieldInput.dirty(super.value) : super.dirty();

  @override
  ValidationResult<DateOnly, BirthdayFieldError> validate(DateTime? value) {
    if (value == null) {
      return const Invalid(BirthdayFieldError.required);
    }

    final now = clock.now();

    if (value.isAfter(now)) {
      return const Invalid(BirthdayFieldError.inFuture);
    }

    final dateOnly = DateOnly.fromDateTime(value);
    return Valid(dateOnly);
  }
}
