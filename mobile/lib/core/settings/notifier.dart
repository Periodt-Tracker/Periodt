import 'package:flutter_riverpod/legacy.dart';
import 'package:periodt/core/settings/models.dart';
import 'package:periodt/core/settings/repository.dart';

class SettingsNotifier extends StateNotifier<PeriodtSettings> {
  final SettingsRepository repository = SettingsRepository();

  SettingsNotifier() : super(PeriodtSettings()) {
    _load();
  }

  Future<void> _load() async {
    state = await repository.loadSettings() ?? PeriodtSettings();
  }

  Future completeSetup() async {
    state = state.copyWith(setupComplete: true);

    await repository.saveSettings(state);
  }

  Future<void> updateSettings(PeriodtSettings newSettings) async {
    state = state.copyWith();

    await repository.saveSettings(state);
  }

  Future<void> updateSecurity(SecuritySettings security) async {
    state = state.copyWith(security: security);

    await repository.saveSettings(state);
  }
}

final settingsNotifier =
    StateNotifierProvider<SettingsNotifier, PeriodtSettings>(
      (ref) => SettingsNotifier(),
    );
