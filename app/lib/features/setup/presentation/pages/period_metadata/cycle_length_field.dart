import 'package:app/core/forms/engine/field.dart';
import 'package:app/core/forms/engine/validation_result.dart';

const maxCycleLength = 90;
const minCycleLength = 10;

enum CycleLengthFieldError { required, tooShort, tooLong }

class CycleLengthFieldInput
    extends PeriodtInput<int?, int, CycleLengthFieldError> {
  const CycleLengthFieldInput.pure([super.value]) : super.pure();

  const CycleLengthFieldInput.dirty(super.value) : super.dirty();

  @override
  ValidationResult<int, CycleLengthFieldError> validate(int? value) {
    if (value == null) {
      return const Invalid(CycleLengthFieldError.required);
    }

    if (value < minCycleLength) {
      return const Invalid(CycleLengthFieldError.tooShort);
    }
    if (value > maxCycleLength) {
      return const Invalid(CycleLengthFieldError.tooLong);
    }

    return Valid(value);
  }
}
