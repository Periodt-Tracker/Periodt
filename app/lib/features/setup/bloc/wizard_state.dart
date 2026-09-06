import 'package:app/core/utilities/date.dart';
import 'package:app/features/setup/domain/contraception_type.dart';
import 'package:app/features/setup/domain/iud.dart';
import 'package:app/features/setup/domain/period.dart';
import 'package:app/features/setup/domain/pill.dart';
import 'package:flutter/material.dart';

const maxSteps = 6;

const noContraceptionSteps = 5;
const pillSteps = 4;
const hormonalIudSteps = 4;
const copperIudSteps = 6;

sealed class SetupWizardState {
  double get progress;

  const SetupWizardState();
}

sealed class CompletedSetupWizardState extends SetupWizardState {
  final NameDetails name;
  final BirthdayDetails birthday;

  const CompletedSetupWizardState({required this.name, required this.birthday});

  @override
  double get progress => 1;
}

@immutable
class NameDetails {
  final String name;

  const NameDetails({required this.name});
}

@immutable
class BirthdayDetails {
  final DateOnly birthday;

  const BirthdayDetails({required this.birthday});
}

@immutable
class ContraceptionDetails {
  final ContraceptionType contraceptionType;

  const ContraceptionDetails({required this.contraceptionType});
}

@immutable
class LastPeriodDetails {
  final List<PeriodDetails> lastPeriods;

  const LastPeriodDetails({required this.lastPeriods});
}

class NamePageState extends SetupWizardState {
  final NameDetails? name;

  const NamePageState({this.name});

  @override
  final double progress = 1 / maxSteps;
}

class BirthdayPageState extends SetupWizardState {
  final NameDetails name;
  final BirthdayDetails? birthday;

  const BirthdayPageState({required this.name, this.birthday});

  @override
  final double progress = 2 / maxSteps;
}

class ContraceptionPageState extends SetupWizardState {
  final NameDetails name;
  final BirthdayDetails birthday;
  final ContraceptionDetails? contraception;

  const ContraceptionPageState({
    required this.name,
    required this.birthday,
    this.contraception,
  });

  @override
  final double progress = 3 / maxSteps;
}

class NoContraceptionPeriodPageState extends SetupWizardState {
  final NameDetails name;
  final BirthdayDetails birthday;
  final LastPeriodDetails? lastPeriods;

  const NoContraceptionPeriodPageState({
    required this.name,
    required this.birthday,
    this.lastPeriods,
  });

  @override
  final double progress = 4 / noContraceptionSteps;
}

class NoContraceptionPeriodMetadataPageState extends SetupWizardState {
  final NameDetails name;
  final BirthdayDetails birthday;
  final LastPeriodDetails lastPeriods;
  final PeriodMetadata? metadata;

  const NoContraceptionPeriodMetadataPageState({
    required this.name,
    required this.birthday,
    required this.lastPeriods,
    this.metadata,
  });

  @override
  final double progress = 5 / noContraceptionSteps;
}

class NoContraceptionCompletedState extends CompletedSetupWizardState {
  final LastPeriodDetails lastPeriods;
  final PeriodMetadata metadata;

  const NoContraceptionCompletedState({
    required super.name,
    required super.birthday,
    required this.lastPeriods,
    required this.metadata,
  });
}

class PillDetailsPageState extends SetupWizardState {
  final NameDetails name;
  final BirthdayDetails birthday;
  final ContraceptivePillDetails? pillDetails;

  const PillDetailsPageState({
    required this.name,
    required this.birthday,
    this.pillDetails,
  });

  @override
  final double progress = 4 / pillSteps;
}

class PillCompletedState extends CompletedSetupWizardState {
  final ContraceptivePillDetails pillDetails;

  const PillCompletedState({
    required super.name,
    required super.birthday,
    required this.pillDetails,
  });
}

class HormonalIudDetailsPageState extends SetupWizardState {
  final NameDetails name;
  final BirthdayDetails birthday;
  final IudDetails? iudDetails;

  const HormonalIudDetailsPageState({
    required this.name,
    required this.birthday,
    this.iudDetails,
  });

  @override
  final double progress = 4 / pillSteps;
}

class HormonalIudCompletedState extends CompletedSetupWizardState {
  final IudDetails iudDetails;

  const HormonalIudCompletedState({
    required super.name,
    required super.birthday,
    required this.iudDetails,
  });
}

class CopperIudDetailsPageState extends SetupWizardState {
  final NameDetails name;
  final BirthdayDetails birthday;
  final IudDetails? iudDetails;

  const CopperIudDetailsPageState({
    required this.name,
    required this.birthday,
    this.iudDetails,
  });

  @override
  final double progress = 4 / copperIudSteps;
}

class CopperIudPeriodsPageState extends SetupWizardState {
  final NameDetails name;
  final BirthdayDetails birthday;
  final IudDetails iudDetails;
  final List<PeriodDetails>? lastPeriods;

  const CopperIudPeriodsPageState({
    required this.name,
    required this.birthday,
    required this.iudDetails,
    this.lastPeriods,
  });

  @override
  // TODO: implement progress
  double get progress => 0;
}

class CopperIudPeriodMetadataPageState extends SetupWizardState {
  final NameDetails name;
  final BirthdayDetails birthday;
  final IudDetails iudDetails;
  final LastPeriodDetails lastPeriods;
  final PeriodMetadata? metadata;

  const CopperIudPeriodMetadataPageState({
    required this.name,
    required this.birthday,
    required this.iudDetails,
    required this.lastPeriods,
    this.metadata,
  });

  @override
  // TODO: implement progress
  double get progress => 0;
}

class CopperIudCompletedState extends CompletedSetupWizardState {
  final IudDetails iudDetails;
  final LastPeriodDetails lastPeriods;
  final PeriodMetadata metadata;

  const CopperIudCompletedState({
    required super.name,
    required super.birthday,
    required this.iudDetails,
    required this.lastPeriods,
    required this.metadata,
  });

  @override
  // TODO: implement progress
  double get progress => 0;
}

class CopperIudAndPillIudDetailsPageState extends SetupWizardState {
  final NameDetails name;
  final BirthdayDetails birthday;
  final IudDetails? iudDetails;

  const CopperIudAndPillIudDetailsPageState({
    required this.name,
    required this.birthday,
    this.iudDetails,
  });

  @override
  // TODO: implement progress
  double get progress => 0;
}

class CopperIudAndPillPillDetailsPageState extends SetupWizardState {
  final NameDetails name;
  final BirthdayDetails birthday;
  final IudDetails iudDetails;
  final ContraceptivePillDetails? pillDetails;

  const CopperIudAndPillPillDetailsPageState({
    required this.name,
    required this.birthday,
    required this.iudDetails,
    this.pillDetails,
  });

  @override
  // TODO: implement progress
  double get progress => 0;
}

class CopperIudAndPillCompletedState extends CompletedSetupWizardState {
  final IudDetails iudDetails;
  final ContraceptivePillDetails pillDetails;

  const CopperIudAndPillCompletedState({
    required super.name,
    required super.birthday,
    required this.iudDetails,
    required this.pillDetails,
  });

  @override
  // TODO: implement progress
  double get progress => 0;
}

class HormonalIudAndPillIudDetailsPageState extends SetupWizardState {
  final NameDetails name;
  final BirthdayDetails birthday;
  final IudDetails? iudDetails;

  const HormonalIudAndPillIudDetailsPageState({
    required this.name,
    required this.birthday,
    this.iudDetails,
  });

  @override
  // TODO: implement progress
  double get progress => 0;
}

class HormonalIudAndPillPillDetailsPageState extends SetupWizardState {
  final NameDetails name;
  final BirthdayDetails birthday;
  final IudDetails iudDetails;
  final ContraceptivePillDetails? pillDetails;

  const HormonalIudAndPillPillDetailsPageState({
    required this.name,
    required this.birthday,
    required this.iudDetails,
    this.pillDetails,
  });

  @override
  // TODO: implement progress
  double get progress => 0;
}

class HormonalIudAndPillCompletedState extends CompletedSetupWizardState {
  final IudDetails iudDetails;
  final ContraceptivePillDetails pillDetails;

  const HormonalIudAndPillCompletedState({
    required super.name,
    required super.birthday,
    required this.iudDetails,
    required this.pillDetails,
  });

  @override
  // TODO: implement progress
  double get progress => 0;
}
