import 'package:drift/drift.dart';
import 'package:periodt/core/database/database.dart';
import 'package:periodt/core/database/models/daily-log.dart';
import 'package:periodt/core/utilities/date.dart';

typedef DailyLogQuery = ({
  DateTime? from,
  DateTime? to,
  int? limit,
  int? offset,
});

const periodQueryLimit = 100;

extension DailyLogService on AppDatabase {
  Future<List<FullDailyLog>> getDailyLogs({
    DateTime? from,
    DateTime? to,
    int? limit,
    int? offset,
    bool? reverse,
  }) async {
    final fixedLimit = limit ?? periodQueryLimit;
    final fixedOffset = offset ?? 0;

    final statement =
        select(dailyLog).join([
            leftOuterJoin(
              bleedingLog,
              bleedingLog.logId.equalsExp(dailyLog.logId),
            ),
            leftOuterJoin(sexLog, sexLog.logId.equalsExp(dailyLog.logId)),
            leftOuterJoin(moodLog, moodLog.logId.equalsExp(dailyLog.logId)),
            leftOuterJoin(
              dischargeLog,
              dischargeLog.logId.equalsExp(dailyLog.logId),
            ),
          ])
          ..limit(fixedLimit, offset: fixedOffset)
          ..orderBy([OrderingTerm.desc(dailyLog.date)]);

    if (from != null) {
      final fromIso = DateUtils.toIsoDate(from);
      statement.where(dailyLog.date.isBiggerThanValue(fromIso));
    }

    if (to != null) {
      final toIso = DateUtils.toIsoDate(to);
      statement.where(dailyLog.date.isSmallerOrEqualValue(toIso));
    }

    return statement.map((row) {
      return FullDailyLog(
        log: row.readTable(dailyLog),
        bleeding: row.readTableOrNull(bleedingLog),
        sex: row.readTableOrNull(sexLog),
        mood: row.readTableOrNull(moodLog),
        discharge: row.readTableOrNull(dischargeLog),
      );
    }).get();
  }

  Future createDailyLog(DailyLogBuilder builder) async {
    return await transaction(() async {
      final logValues = DailyLogCompanion(date: Value(builder.date));
      final logId = await into(dailyLog).insert(logValues);

      final bleeding = builder.bleeding;

      if (bleeding != null) {
        final companion = BleedingLogCompanion.insert(
          logId: Value(logId),
          bleedingLevel: bleeding.bleedingLevel,
          clots: bleeding.clots,
          spotting: bleeding.spotting,
        );

        await into(bleedingLog).insert(companion);
      }

      final sex = builder.sex;

      if (sex != null) {
        final companion = SexLogCompanion.insert(
          logId: Value(logId),
          sexType: sex.sexType,
        );

        await into(sexLog).insert(companion);
      }

      final discharge = builder.discharge;

      if (discharge != null) {
        final values = DischargeLogCompanion.insert(
          logId: Value(logId),
          colour: discharge.colour,
          consistency: discharge.consistency,
          odor: discharge.odor,
        );

        await into(dischargeLog).insert(values);
      }

      final mood = builder.mood;

      if (mood != null) {
        final companions = MoodLogCompanion.insert(
          logId: Value(logId),
          moodType: mood.moodType,
        );

        await into(moodLog).insert(companions);
      }

      return logId;
    });
  }

  Future deleteDailyLog(String date) async {
    return await transaction(() async {
      final statement = delete(dailyLog)
        ..where((table) => table.date.equals(date));

      return await statement.go();
    });
  }
}
