import 'package:app/core/forms/engine/form_status.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/domain/contraception_type.dart';
import 'package:app/features/setup/presentation/pages/contraception/contraception_field.dart';
import 'package:app/features/setup/presentation/pages/contraception/contraception_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContraceptionFormCubit extends Cubit<ContraceptionFormState> {
  ContraceptionFormCubit({required this.onSubmit})
    : super(ContraceptionFormState.initial());

  final void Function(ContraceptionDetails) onSubmit;

  void contraceptionChanged(Set<Method> contraception) {
    final newContraception = ContraceptionFieldInput.dirty(contraception);

    emit(state.copyWith(type: newContraception));
  }

  void _handleValidSubmit(ContraceptionType details) {
    final newState = state.copyWith(
      type: ContraceptionFieldInput.dirty(state.type.value),
      status: PeriodtFormStatus.inProgress,
    );

    emit(newState);
    onSubmit(ContraceptionDetails(contraceptionType: details));
  }

  void _handleInvalidSubmit(_) {
    final newState = state.copyWith(
      type: ContraceptionFieldInput.dirty(state.type.value),
      status: PeriodtFormStatus.failure,
    );

    emit(newState);
  }

  void submit() {
    state.type.fold(valid: _handleValidSubmit, invalid: _handleInvalidSubmit);
  }
}
