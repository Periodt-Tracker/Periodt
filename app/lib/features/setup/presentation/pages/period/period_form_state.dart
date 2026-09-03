import 'package:app/core/forms/engine/form_status.dart';
import 'package:app/features/setup/presentation/pages/period/periods_field.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'period_form_state.freezed.dart';

@freezed
class PeriodFormState with _$PeriodFormState {
  const PeriodFormState._({required this.periods, required this.status});

  factory PeriodFormState.initial() {
    return const PeriodFormState._(
      periods: LastPeriodsFieldInput.pure(),
      status: PeriodtFormStatus.initial,
    );
  }

  @override
  final LastPeriodsFieldInput periods;

  @override
  final PeriodtFormStatus status;
}
