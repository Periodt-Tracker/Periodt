import 'package:app/core/forms/engine/form_status.dart';
import 'package:app/features/setup/presentation/pages/contraception/contraception_field.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'contraception_form_state.freezed.dart';

@freezed
class ContraceptionFormState with _$ContraceptionFormState {
  const ContraceptionFormState._({required this.type, required this.status});

  factory ContraceptionFormState.initial() {
    return const ContraceptionFormState._(
      type: ContraceptionFieldInput.pure(),
      status: PeriodtFormStatus.initial,
    );
  }

  @override
  final ContraceptionFieldInput type;

  @override
  final PeriodtFormStatus status;
}
