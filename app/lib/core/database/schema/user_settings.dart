import 'package:app/core/database/utilities/table_base.dart';
import 'package:drift/drift.dart';

@DataClassName('UserSettingsData')
class UserSettings extends Table with TableBase {
  late final userSettingsId = integer()
      .named('user_settings_id')
      .withDefault(const Constant(1))();

  late final name = text().named('name').withLength(min: 1, max: 255)();
  late final age = integer().named('age')();
  late final locale = text().named('locale').withLength(min: 2, max: 10)();

  @override
  String get tableName => 'user_settings';

  @override
  Set<Column> get primaryKey => {userSettingsId};
}
