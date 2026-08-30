import 'package:app/core/forms/engine/skippable_page.dart';
import 'package:app/core/utilities/date.dart';
import 'package:app/features/daily_log/domain/bleeding.dart';

sealed class LogWizardState {
  final DateOnly date;

  const LogWizardState({required this.date});
}

class BleedingLogWizardState extends LogWizardState {
  final OptionalPage<BleedingType> bleeding;

  const BleedingLogWizardState({required super.date, required this.bleeding});
}

class CompletedLogWizardState extends LogWizardState {
  final OptionalPage<BleedingType> bleeding;
  final OptionalPage<String> notes;

  const CompletedLogWizardState({
    required super.date,
    required this.bleeding,
    required this.notes,
  });
}
