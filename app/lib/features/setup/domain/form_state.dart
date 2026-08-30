import 'package:app/core/utilities/date.dart';
import 'package:flutter/material.dart';

sealed class SetupFormState {
  const SetupFormState();
}

@immutable
class NameInfo {
  final String name;

  const NameInfo({required this.name});
}

class NamePageState extends SetupFormState {
  const NamePageState();
}

class ContraceptionPageState extends SetupFormState {
  final NameInfo name;

  const ContraceptionPageState({required this.name});
}

@immutable
class PeriodInfo {
  final DateOnly startDate;
  final DateOnly endDate;

  const PeriodInfo({required this.startDate, required this.endDate});
}

@immutable
class RecentPeriodInfo {
  final List<PeriodInfo> periods;

  const RecentPeriodInfo({required this.periods});
}

class PeriodPageState extends SetupFormState {
  final NameInfo name;

  const PeriodPageState({required this.name});
}

@immutable
class PeriodMetaInfo {
  final int cycleLength;
  final int periodLength;

  const PeriodMetaInfo({required this.cycleLength, required this.periodLength});
}

class PeriodMetaPageState extends SetupFormState {
  final NameInfo name;
  final RecentPeriodInfo recentPeriods;

  const PeriodMetaPageState({required this.name, required this.recentPeriods});
}

sealed class PillRegimen {
  const PillRegimen();
}

class ContinuousPillRegimen extends PillRegimen {
  const ContinuousPillRegimen();
}

class OnOffPillRegimen extends PillRegimen {
  final int daysOn;
  final int daysOff;
  final DateOnly startDate;

  const OnOffPillRegimen({
    required this.daysOn,
    required this.daysOff,
    required this.startDate,
  });
}

@immutable
class PillInfo {
  final String name;
  final PillRegimen regimen;
  final bool blocksOvulation;
  final DateOnly? startDate;

  const PillInfo({
    required this.name,
    required this.regimen,
    required this.blocksOvulation,
    this.startDate,
  });
}

class PillPageState extends SetupFormState {
  final NameInfo name;

  const PillPageState({required this.name});
}

@immutable
class PeriodRouteState {
  final NameInfo name;
  final RecentPeriodInfo recentPeriods;
  final PeriodMetaInfo periodMeta;

  const PeriodRouteState({
    required this.name,
    required this.recentPeriods,
    required this.periodMeta,
  });
}

@immutable
class PillRouteState {
  final NameInfo name;
  final PillInfo pill;

  const PillRouteState({required this.name, required this.pill});
}

sealed class CompletedSetup extends SetupFormState {
  NameInfo get name;
}
