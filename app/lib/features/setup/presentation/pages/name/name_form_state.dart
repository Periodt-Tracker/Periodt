import 'package:app/core/forms/engine/form_status.dart';
import 'package:app/features/setup/presentation/pages/name/name_field_input.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'name_form_state.freezed.dart';

@freezed
class NameFormState with _$NameFormState {
  const NameFormState._({required this.name, required this.status});

  factory NameFormState.dirty({required String name}) {
    return NameFormState._(
      name: NameFieldInput.dirty(name),
      status: PeriodtFormStatus.initial,
    );
  }

  factory NameFormState.initial({NameFieldInput? initialName}) {
    return NameFormState._(
      name: initialName ?? const NameFieldInput.pure(),
      status: PeriodtFormStatus.initial,
    );
  }

  @override
  final NameFieldInput name;

  @override
  final PeriodtFormStatus status;
}
