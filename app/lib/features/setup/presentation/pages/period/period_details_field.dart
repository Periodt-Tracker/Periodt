import 'package:app/core/forms/engine/field.dart';
import 'package:app/core/forms/engine/validation_result.dart';
import 'package:app/core/utilities/date.dart';
import 'package:app/features/setup/domain/period.dart';

enum LastPeriodsFieldError {
  tooFewDates,
  tooManyDates,
  invertedDates,
  required,
}

class PeriodDetailsFieldInput
    extends PeriodtInput<List<DateTime>, PeriodDetails, LastPeriodsFieldError> {
  const PeriodDetailsFieldInput.pure([super.value = const []]) : super.pure();

  const PeriodDetailsFieldInput.dirty(super.value) : super.dirty();

  @override
  ValidationResult<PeriodDetails, LastPeriodsFieldError> validate(
    List<DateTime> value,
  ) {
    if (value.isEmpty) {
      return const Invalid(LastPeriodsFieldError.required);
    }

    if (value.length < 2) {
      return const Invalid(LastPeriodsFieldError.tooFewDates);
    }

    if (value.length > 2) {
      return const Invalid(LastPeriodsFieldError.tooManyDates);
    }

    final startDate = DateOnly.fromDateTime(value.first);
    final endDate = DateOnly.fromDateTime(value.last);

    if (startDate.isAfter(endDate)) {
      return const Invalid(LastPeriodsFieldError.invertedDates);
    }

    final details = PeriodDetails(start: startDate, end: endDate);

    return Valid(details);
  }
}
