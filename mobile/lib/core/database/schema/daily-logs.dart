import 'package:drift/drift.dart';
import 'package:periodt/core/database/schema/base.dart';

class DailyLog extends Table with TableBase {
  late final IntColumn logId = integer().named("log_id")();

  late final TextColumn date = text().named("date").unique()(); // ISO-8601

  late final TextColumn note = text().named("note").nullable()();

  @override
  Set<Column<Object>> get primaryKey => {logId};
}

class BleedingLog extends Table with TableBase {
  late final IntColumn logId = integer()
      .named("log_id")
      .references(DailyLog, #logId, onDelete: KeyAction.cascade)();

  late final IntColumn bleedingLevel = integer()
      .named("bleeding_level")
      .check(bleedingLevel.isBetweenValues(0, 5))();

  late final BoolColumn spotting = boolean().named("spotting")();

  late final BoolColumn clots = boolean().named("clots")();

  @override
  Set<Column<Object>> get primaryKey => {logId};
}

class DischargeLog extends Table with TableBase {
  late final IntColumn logId = integer()
      .named("log_id")
      .references(DailyLog, #logId, onDelete: KeyAction.cascade)();

  late final TextColumn colour = text().named("colour")();

  late final TextColumn consistency = text().named("consistency")();

  late final TextColumn odor = text().named("odor")();

  @override
  Set<Column<Object>> get primaryKey => {logId};
}

class MoodLog extends Table {
  late final IntColumn logId = integer()
      .named("log_id")
      .references(DailyLog, #logId, onDelete: KeyAction.cascade)();

  late final TextColumn moodType = text().named("mood_type")();

  @override
  Set<Column<Object>> get primaryKey => {logId};
}

class SexLog extends Table {
  late final IntColumn logId = integer()
      .named("log_id")
      .references(DailyLog, #logId, onDelete: KeyAction.cascade)();

  late final TextColumn sexType = text().named("sex_type")();

  @override
  Set<Column<Object>> get primaryKey => {logId};
}
