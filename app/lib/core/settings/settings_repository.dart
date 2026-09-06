import 'dart:convert';
import 'dart:io';

import 'package:app/core/settings/settings.dart';
import 'package:app/core/settings/settings_state.dart';
import 'package:path_provider/path_provider.dart';

abstract interface class SettingsRepository {
  Future<SettingsState> loadSettings();

  Future<void> saveSettings(PeriodtSettings settings);
}

class FailingSettingsRepository implements SettingsRepository {
  @override
  Future<SettingsState> loadSettings() async {
    return SettingsState.missing();
  }

  @override
  Future<void> saveSettings(PeriodtSettings settings) async {}
}

class MockSettingsRepository implements SettingsRepository {
  @override
  Future<SettingsState> loadSettings() async {
    return const SettingsState.valid(PeriodtSettings());
  }

  @override
  Future<void> saveSettings(PeriodtSettings settings) async {}
}

class FileSettingsRepository implements SettingsRepository {
  Future<File> get _file async {
    final directory = await getApplicationDocumentsDirectory();

    return File('${directory.path}/settings.json');
  }

  Future<SettingsState> loadSettings() async {
    return SettingsState.missing();
  }

  Future<void> saveSettings(PeriodtSettings settings) async {
    final file = await _file;
    await file.writeAsString(jsonEncode(settings.toJson()));
  }
}
