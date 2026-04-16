import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:periodt/core/settings/models.dart';
import 'package:periodt/core/settings/repository.dart';

class SettingsNotifier extends StateNotifier<PeriodtSettings> {
  final SettingsRepository _repository = SettingsRepository();

  SettingsNotifier() : super(PeriodtSettings()) {
    _load();
  }

  Future<void> _load() async {
    state = await _repository.loadSettings() ?? PeriodtSettings();
  }

  Future completeSetup() async {
    state = state.copyWith(setupComplete: true);

    await _repository.saveSettings(state);
  }

  Future resetSetup() async {
    state = state.copyWith(setupComplete: false);

    await _repository.saveSettings(state);
  }

  Future<void> updateSettings(PeriodtSettings newSettings) async {
    state = newSettings;

    await _repository.saveSettings(state);
  }

  Future updateTrackedSettings(Function(TrackedSymptomsSettings) update) async {
    final newTrackedSettings = update(state.trackedSymptoms);
    state = state.copyWith(trackedSymptoms: newTrackedSettings);

    await _repository.saveSettings(state);
  }

  Future updateDeveloperSettings(Function(DeveloperSettings) update) async {
    final newDeveloperSettings = update(state.developer);
    state = state.copyWith(developer: newDeveloperSettings);

    await _repository.saveSettings(state);
  }

  Future<void> updateSecuritySettings(Function(SecuritySettings) update) async {
    final newSecuritySettings = update(state.security);
    state = state.copyWith(security: newSecuritySettings);

    await _repository.saveSettings(state);
  }
}

final settingsNotifier =
    StateNotifierProvider<SettingsNotifier, PeriodtSettings>(
      (ref) => SettingsNotifier(),
    );
