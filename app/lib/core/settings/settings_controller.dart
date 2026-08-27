import 'package:app/core/settings/settings.dart';
import 'package:app/core/settings/settings_repository.dart';
import 'package:app/core/settings/settings_repository_provider.dart';
import 'package:app/core/settings/settings_state.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'settings_controller.g.dart';

@riverpod
class SettingsController extends _$SettingsController {
  late final SettingsRepository _repository;

  @override
  SettingsState build() {
    _repository = ref.read(settingsRepositoryProvider);
    return const SettingsState.loading();
  }

  Future<void> load() async {
    state = await _repository.loadSettings();
  }

  Future<void> save(PeriodtSettings settings) async {
    await _repository.saveSettings(settings);

    state = SettingsState.valid(settings);
  }
}
