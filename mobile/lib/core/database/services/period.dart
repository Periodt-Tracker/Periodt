import 'package:drift/drift.dart';
import 'package:periodt/core/database/database.dart';

typedef PeriodQuery = ({int? limit, int? offset});

typedef PeriodBuilder = ({DateTime startDate, DateTime endDate});

typedef PeriodUpdater = ({DateTime? startDate, DateTime? endDate});

const periodQueryLimit = 100;

extension PeriodService on AppDatabase {
  Stream<List<Period>> watchPeriods({int? limit, int? offset}) {
    final fixedLimit = limit ?? periodQueryLimit;
    final fixedOffset = offset ?? 0;

    final statement = select(periods)
      ..limit(fixedLimit, offset: fixedOffset)
      ..orderBy([(period) => OrderingTerm.desc(period.startDate)]);

    return statement.watch();
  }

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
        endDate: Value(data.endDate),
      );

      await into(periods).insert(values);
    });
  }

  Future updatePeriod(int periodId, PeriodUpdater updates) async {
    return transaction(() async {
      final values = PeriodsCompanion(
        startDate: Value.absentIfNull(updates.startDate),
        endDate: Value.absentIfNull(updates.endDate),
      );

      return update(periods)
        ..where((period) => period.periodId.equals(periodId))
        ..write(values);
    });
  }

  Future deletePeriod(int periodId) async {
    return transaction(() async {
      final statement = delete(periods)
        ..where((period) => period.periodId.equals(periodId));

      return await statement.go();
    });
  }
}
