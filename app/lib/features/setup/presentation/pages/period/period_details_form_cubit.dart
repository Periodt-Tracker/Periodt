import 'package:app/core/forms/engine/form_status.dart';
import 'package:app/features/setup/domain/period.dart';
import 'package:app/features/setup/presentation/pages/period/period_details_field.dart';
import 'package:app/features/setup/presentation/pages/period/period_details_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PeriodDetailsFormCubit extends Cubit<PeriodDetailsFormState> {
  PeriodDetailsFormCubit({required this.onSubmit})
    : super(PeriodDetailsFormState.initial());

  final void Function(PeriodDetails) onSubmit;

  void onDetailsChanged(List<DateTime> input) {
    final newDetails = PeriodDetailsFieldInput.dirty(input);

    emit(state.copyWith(details: newDetails));
  }

  void onDetailsTouched() {
    final newDetails = PeriodDetailsFieldInput.dirty(state.details.value);

    emit(state.copyWith(details: newDetails));
  }

  void _onValidSubmit(PeriodDetails details) {
    final newState = state.copyWith(
      details: PeriodDetailsFieldInput.dirty(state.details.value),
      status: PeriodtFormStatus.success,
    );

    emit(newState);

    onSubmit.call(details);
  }

  void _onInvalidSubmit(_) {
    final newDetails = PeriodDetailsFieldInput.dirty(state.details.value);

    final newState = state.copyWith(
      details: newDetails,
      status: PeriodtFormStatus.failure,
    );

    emit(newState);
  }

  void trySubmit() {
    state.details.fold(valid: _onValidSubmit, invalid: _onInvalidSubmit);
  }
}
