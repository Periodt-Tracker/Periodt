import 'package:app/core/forms/engine/form_status.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/domain/period.dart';
import 'package:app/features/setup/presentation/pages/period/period_form_state.dart';
import 'package:app/features/setup/presentation/pages/period/periods_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PeriodFormCubit extends Cubit<PeriodFormState> {
  PeriodFormCubit({required this.onSubmit}) : super(PeriodFormState.initial());

  final void Function(LastPeriodDetails) onSubmit;

  void onLastPeriodsChanged(List<PeriodDetails> input) {
    final newPeriods = LastPeriodsFieldInput.dirty(input);

    emit(state.copyWith(periods: newPeriods));
  }

  void onPeriodAdded(PeriodDetails period) {
    final periods = [...state.periods.value, period];
    final newPeriods = LastPeriodsFieldInput.dirty(periods);

    emit(state.copyWith(periods: newPeriods));
  }

  void onLastPeriodsTouched() {
    final newPeriods = LastPeriodsFieldInput.dirty(state.periods.value);

    emit(state.copyWith(periods: newPeriods));
  }

  void _onValidSubmit(List<PeriodDetails> lastPeriods) {
    final details = LastPeriodDetails(lastPeriods: lastPeriods);

    onSubmit.call(details);
  }

  void _onInvalidSubmit(_) {
    final newPeriods = LastPeriodsFieldInput.dirty(state.periods.value);

    final newState = state.copyWith(
      periods: newPeriods,
      status: PeriodtFormStatus.inProgress,
    );

    emit(newState);
  }

  void trySubmit() {
    state.periods.fold(valid: _onValidSubmit, invalid: _onInvalidSubmit);
  }
}
