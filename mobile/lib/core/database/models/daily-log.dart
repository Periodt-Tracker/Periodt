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
