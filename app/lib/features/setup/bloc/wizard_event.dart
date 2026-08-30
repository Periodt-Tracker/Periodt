import 'package:app/core/utilities/date.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/domain/contraception_type.dart';
import 'package:app/features/setup/domain/iud.dart';
import 'package:app/features/setup/domain/period.dart';
import 'package:app/features/setup/domain/pill.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'wizard_event.freezed.dart';

@freezed
sealed class SetupWizardEvent with _$SetupWizardEvent {
  const factory SetupWizardEvent.nameSubmitted({required NameDetails name}) =
      NameSubmitted;

  const factory SetupWizardEvent.dateOfBirthSubmitted({
    required BirthdayDetails birthday,
  }) = DateOfBirthSubmitted;

  const factory SetupWizardEvent.contraceptionSubmitted({
    required ContraceptionType type,
  }) = ContraceptionSubmitted;

  const factory SetupWizardEvent.onPeriodsSubmitted({
    required LastPeriodDetails lastPeriods,
  }) = OnPeriodsSubmitted;

  const factory SetupWizardEvent.onPeriodMetadataSubmitted({
    required PeriodMetadata metadata,
  }) = OnPeriodMetadataSubmitted;

  const factory SetupWizardEvent.onPillDetailsSubmitted({
    required ContraceptivePillDetails pillDetails,
  }) = OnPillDetailsSubmitted;

  const factory SetupWizardEvent.onIudDetailsSubmitted({
    required IudDetails iudDetails,
  }) = OnIudDetailsSubmitted;
}
