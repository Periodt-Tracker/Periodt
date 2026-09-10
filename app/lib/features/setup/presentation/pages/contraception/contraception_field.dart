import 'package:app/core/forms/engine/field.dart';
import 'package:app/core/forms/engine/validation_result.dart';
import 'package:app/features/setup/domain/contraception_type.dart';

enum ContraceptionFieldError { invalidCombination }

enum Method { pill, hormonalIud, copperIud, none }

typedef Methods = Set<Method>;

class ContraceptionFieldInput
    extends
        PeriodtInput<Set<Method>, ContraceptionType, ContraceptionFieldError> {
  const ContraceptionFieldInput.pure([super.value = const {}]) : super.pure();

  const ContraceptionFieldInput.dirty(super.value) : super.dirty();

  @override
  ValidationResult<ContraceptionType, ContraceptionFieldError> validate(
    Set<Method> value,
  ) {
    if (value.isEmpty) {
      return const Valid(ContraceptionType.none);
    }

    if (value.length == 1) {
      return switch (value.first) {
        Method.pill => const Valid(ContraceptionType.pill),

        Method.hormonalIud => const Valid(ContraceptionType.hormonalIud),

        Method.copperIud => const Valid(ContraceptionType.copperIud),

        Method.none => const Valid(ContraceptionType.none),
      };
    }

    if (value.length == 2) {
      if (value.contains(Method.pill) && value.contains(Method.hormonalIud)) {
        return const Valid(ContraceptionType.hormonalIudAndPill);
      }

      if (value.contains(Method.pill) && value.contains(Method.copperIud)) {
        return const Valid(ContraceptionType.copperIudAndPill);
      }
    }

    return const Invalid(ContraceptionFieldError.invalidCombination);
  }
}
