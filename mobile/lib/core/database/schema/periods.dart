import 'package:drift/drift.dart';
import 'package:periodt/core/database/schema/base.dart';

class Periods extends Table with TableBase {
  late final IntColumn periodId = integer().named('period_id')();

  late final TextColumn startDate = text().named('start_date')();

  late final IntColumn duration = integer()
      .named('duration')
      .check(duration.isBiggerThanValue(0))();

  late final TextColumn note = text().named('note').nullable()();

  @override
  Set<Column<Object>> get primaryKey => {periodId};
}
