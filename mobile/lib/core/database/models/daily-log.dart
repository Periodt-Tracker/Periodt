import 'package:periodt/core/database/database.dart';

class FullDailyLog {
  FullDailyLog({
    required this.log,
    this.bleeding,
    this.sex,
    this.discharge,
    this.mood,
  });

  final DailyLogData log;
  final BleedingLogData? bleeding;
  final SexLogData? sex;
  final DischargeLogData? discharge;
  final MoodLogData? mood;
}

class DailyLogBuilder {
  final String date;
  final BleedingLogBuilder? bleeding;
  final SexLogBuilder? sex;
  final DischardgeLogBuilder? discharge;
  final MoodLogBuilder? mood;

  DailyLogBuilder({
    required this.date,
    this.bleeding,
    this.sex,
    this.discharge,
    this.mood,
  });
}

class BleedingLogBuilder {
  final int bleedingLevel;
  final bool spotting;
  final bool clots;

  BleedingLogBuilder({
    required this.bleedingLevel,
    required this.spotting,
    required this.clots,
  });
}

class SexLogBuilder {
  final String sexType;

  SexLogBuilder({required this.sexType});
}

class DischardgeLogBuilder {
  final String colour;
  final String consistency;
  final String odor;

  DischardgeLogBuilder({
    required this.colour,
    required this.consistency,
    required this.odor,
  });
}

class MoodLogBuilder {
  final String moodType;

  MoodLogBuilder({required this.moodType});
}
