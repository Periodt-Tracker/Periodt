import 'package:app/core/forms/engine/form_status.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/presentation/pages/name/name_field_input.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'name_form_state.freezed.dart';

@freezed
class NameFormState with _$NameFormState {
  const NameFormState._({required this.name, required this.status});

  factory NameFormState.initial(NameDetails? initialDetails) {
    if (initialDetails != null) {
      return const NameFormState._(
        name: NameFieldInput.pure(),
        status: PeriodtFormStatus.initial,
      );
    }

    return const NameFormState._(
      name: NameFieldInput.pure(),
      status: PeriodtFormStatus.initial,
    );
  }

  bool get isValid => name.isValid;

  @override
  final NameFieldInput name;

  @override
  final PeriodtFormStatus status;
}
