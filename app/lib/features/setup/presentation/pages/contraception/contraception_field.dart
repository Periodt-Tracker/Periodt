import 'package:app/core/forms/engine/field.dart';
import 'package:app/core/forms/engine/validation_result.dart';
import 'package:app/features/setup/domain/contraception_type.dart';

enum ContraceptionFieldError { invalidCombination }

enum Method { pill, hormonalIud, copperIud }

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
    return switch (value) {
      const {Method.pill} => const Valid(ContraceptionType.pill),

      const {Method.hormonalIud} => const Valid(ContraceptionType.hormonalIud),

      const {Method.copperIud} => const Valid(ContraceptionType.copperIud),

      const {Method.hormonalIud, Method.pill} => const Valid(
        ContraceptionType.hormonalIudAndPill,
      ),

      const {Method.copperIud, Method.pill} => const Valid(
        ContraceptionType.copperIudAndPill,
      ),

      const {} => const Valid(ContraceptionType.none),

      _ => const Invalid(ContraceptionFieldError.invalidCombination),
    };
  }
}
