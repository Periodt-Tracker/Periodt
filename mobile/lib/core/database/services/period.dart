import 'package:drift/drift.dart';
import 'package:periodt/core/database/database.dart';

typedef PeriodQuery = ({int? limit, int? offset});

typedef PeriodBuilder = ({String startDate, int duration});

typedef PeriodUpdater = ({String? startDate, int? duration});

const periodQueryLimit = 100;

extension PeriodService on AppDatabase {
  Future<List<Period>> getPeriods({int? limit, int? offset}) async {
    final fixedLimit = limit ?? periodQueryLimit;
    final fixedOffset = offset ?? 0;

    final statement = select(periods)
      ..limit(fixedLimit, offset: fixedOffset)
      ..orderBy([(period) => OrderingTerm.desc(period.startDate)]);

    return statement.get();
  }

  Future addPeriod(PeriodBuilder data) async {
    return await transaction(() async {
      final values = PeriodsCompanion(
        startDate: Value(data.startDate),
        duration: Value(data.duration),
      );

      await into(periods).insert(values);
    });
  }

  Future updatePeriod(int periodId, PeriodUpdater updates) async {
    return transaction(() async {
      final values = PeriodsCompanion(
        startDate: Value.absentIfNull(updates.startDate),
        duration: Value.absentIfNull(updates.duration),
      );

      return update(periods)
        ..where((period) => period.periodId.equals(periodId))
        ..write(values);
    });
  }

  Future deletePeriod(int periodId) async {
    return transaction(() async {
      return delete(periods)
        ..where((period) => period.periodId.equals(periodId))
        ..go();
    });
  }
}
