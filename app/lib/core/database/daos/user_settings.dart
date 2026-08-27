import 'package:app/core/database/database.dart';
import 'package:app/core/database/schema/user_settings.dart';
import 'package:drift/drift.dart';

part 'user_settings.g.dart';

@DriftAccessor(tables: [UserSettings])
class UserSettingsDao extends DatabaseAccessor<PeriodtDatabase>
    with _$UserSettingsDaoMixin {
  UserSettingsDao(super.db);

  Stream<UserSettingsData?> watchUserSettings() {
    return select(userSettings).watchSingleOrNull();
  }

  Future<UserSettingsData?> getUserSettings() {
    return select(userSettings).getSingleOrNull();
  }

  Future<void> save(UserSettingsCompanion entity) {
    return into(userSettings).insertOnConflictUpdate(entity);
  }
}
