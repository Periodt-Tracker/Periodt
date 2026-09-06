import 'package:app/core/forms/engine/form_status.dart';
import 'package:app/core/forms/utilities/fold.dart';
import 'package:app/features/setup/domain/period.dart';
import 'package:app/features/setup/presentation/pages/period_metadata/cycle_length_field.dart';
import 'package:app/features/setup/presentation/pages/period_metadata/period_duration_field.dart';
import 'package:app/features/setup/presentation/pages/period_metadata/period_metadata_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PeriodMetadataFormCubit extends Cubit<PeriodMetadataFormState> {
  PeriodMetadataFormCubit({
    required this.onSubmit,
    PeriodMetadata? value,
  }) : super(PeriodMetadataFormState.fromDetails(value));

  final void Function(PeriodMetadata) onSubmit;

  void onCycleLengthChanged(int input) {
    emit(state.copyWith(cycleLength: .dirty(input)));
  }

  void onCycleLengthTouched() {
    emit(state.copyWith(cycleLength: .dirty(state.cycleLength.value)));
  }

  void onPeriodDurationChanged(int input) {
    emit(state.copyWith(periodDuration: .dirty(input)));
  }

  void onPeriodDurationTouched() {
    emit(state.copyWith(periodDuration: .dirty(state.periodDuration.value)));
  }

  void _onValidSubmit(int cycleLength, int periodDuration) {
    final newState = state.copyWith(
      cycleLength: .dirty(state.cycleLength.value),
      periodDuration: .dirty(state.periodDuration.value),
      status: PeriodtFormStatus.success,
    );

    emit(newState);

    final metadata = PeriodMetadata(
      cycleLength: cycleLength,
      periodLength: periodDuration,
    );
    onSubmit.call(metadata);
  }

  void _onInvalidSubmit() {
    final newCycleLength = CycleLengthFieldInput.dirty(state.cycleLength.value);
    final newPeriodDuration = PeriodDurationFieldInput.dirty(
      state.periodDuration.value,
    );

    final newState = state.copyWith(
      cycleLength: newCycleLength,
      periodDuration: newPeriodDuration,
      status: PeriodtFormStatus.failure,
    );

    emit(newState);
  }

  void trySubmit() {
    foldAll2(
      state.cycleLength,
      state.periodDuration,
      valid: _onValidSubmit,
      invalid: _onInvalidSubmit,
    );
  }
}
