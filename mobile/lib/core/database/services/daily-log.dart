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
}
