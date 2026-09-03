import 'package:app/core/forms/engine/field.dart';
import 'package:app/core/forms/engine/validation_result.dart';
import 'package:app/features/setup/domain/period.dart';

enum LastPeriodsFieldError {
  invalidPeriodLength,
  invalidCycleLength,
  intersectingPeriods,
}

bool periodsIntersect(PeriodDetails a, PeriodDetails b) {
  return a.start.isBefore(b.end) && b.start.isBefore(a.end);
}

class LastPeriodsFieldInput
    extends
        PeriodtInput<
          List<PeriodDetails>,
          List<PeriodDetails>,
          LastPeriodsFieldError
        > {
  const LastPeriodsFieldInput.pure([super.value = const []]) : super.pure();

  const LastPeriodsFieldInput.dirty(super.value) : super.dirty();

  @override
  ValidationResult<List<PeriodDetails>, LastPeriodsFieldError> validate(
    List<PeriodDetails> value,
  ) {
    for (var i = 0; i < value.length - 1; i++) {
      for (var j = i + 1; j < value.length; j++) {
        if (periodsIntersect(value[i], value[j])) {
          return const Invalid(LastPeriodsFieldError.intersectingPeriods);
        }
      }
    }

    return Valid(value);
  }
}
