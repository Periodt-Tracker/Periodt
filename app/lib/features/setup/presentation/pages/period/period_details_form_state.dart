import 'package:app/core/forms/engine/form_status.dart';
import 'package:app/features/setup/presentation/pages/period/period_details_field.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'period_details_form_state.freezed.dart';

@freezed
class PeriodDetailsFormState with _$PeriodDetailsFormState {
  const PeriodDetailsFormState._({required this.details, required this.status});

  factory PeriodDetailsFormState.initial() {
    return const PeriodDetailsFormState._(
      details: PeriodDetailsFieldInput.pure(),
      status: PeriodtFormStatus.initial,
    );
  }

  @override
  final PeriodDetailsFieldInput details;

  @override
  final PeriodtFormStatus status;
}
