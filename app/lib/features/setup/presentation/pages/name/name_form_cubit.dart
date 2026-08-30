import 'package:app/core/forms/engine/form_status.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/presentation/pages/name/name_field_input.dart';
import 'package:app/features/setup/presentation/pages/name/name_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NameFormCubit extends Cubit<NameFormState> {
  NameFormCubit({required this.onSubmit, NameDetails? initialDetails})
    : super(NameFormState.initial(initialDetails));

  final void Function(NameDetails) onSubmit;

  void nameChanged(String name) {
    final newName = NameFieldInput.dirty(name);

    emit(state.copyWith(name: newName));
  }

  void nameTouched() {
    final newName = NameFieldInput.dirty(state.name.value);

    emit(state.copyWith(name: newName));
  }

  void _handleValid(String name) {
    final newState = state.copyWith(
      name: NameFieldInput.dirty(name),
      status: PeriodtFormStatus.inProgress,
    );

    emit(newState);

    final details = NameDetails(name: name);
    onSubmit(details);
  }

  void _handleInvalid(_) {
    final newState = state.copyWith(
      name: NameFieldInput.dirty(state.name.value),
      status: PeriodtFormStatus.failure,
    );

    emit(newState);
  }

  void trySubmit() {
    state.name.fold(
      valid: _handleValid,
      invalid: _handleInvalid,
    );
  }
}
