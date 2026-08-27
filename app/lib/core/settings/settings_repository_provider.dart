import 'package:app/core/settings/settings_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_repository_provider.g.dart';

@riverpod
SettingsRepository settingsRepository(Ref ref) {
  return FileSettingsRepository();
}
