import 'package:app/core/logging/app_logger.dart';
import 'package:app/core/settings/settings.dart';
import 'package:app/core/settings/settings_repository.dart';
import 'package:app/core/settings/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit({required SettingsRepository repository})
    : _repository = repository,
      super(const SettingsState.loading());

  final SettingsRepository _repository;

  Future<void> load() async {
    final settings = await _repository.loadSettings();

    emit(settings);
  }

  Future<void> save(PeriodtSettings settings) async {
    await _repository.saveSettings(settings);

    emit(SettingsState.valid(settings));
  }

  Future<void> update(PeriodtSettings Function(PeriodtSettings) update) async {
    switch (state) {
      case SettingsLoading():
      case SettingsMissing():
      case SettingsInvalid():
        AppLogger.instance.info(
          'SettingsCubit',
          'Cannot update settings while loading or in an invalid state',
        );

      case SettingsValid(:final settings):
        final newSettings = update(settings);
        await save(newSettings);
    }
  }
}
