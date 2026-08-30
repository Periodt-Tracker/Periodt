import 'package:app/app/app_phase.dart';
import 'package:app/core/settings/settings_controller.dart';
import 'package:app/core/settings/settings_state.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_controller.g.dart';

@riverpod
class AppController extends _$AppController {
  @override
  AppPhase build() {
    ref.listen(settingsControllerProvider, _onSettingsChanged);

    return const AppPhase.startup();
  }

  void _onSettingsChanged(SettingsState? _, SettingsState settings) {
    switch (settings) {
      case SettingsLoading():
        state = const AppPhase.startup();

      case SettingsMissing():
      case SettingsInvalid():
        state = const AppPhase.setup();

      case SettingsValid(:final settings):
        state = AppPhase.ready(settings);
    }
  }
}
