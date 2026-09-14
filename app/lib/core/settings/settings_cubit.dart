import 'package:app/core/logging/bloc/logging_cubit.dart';
import 'package:app/core/logging/logger.dart';
import 'package:app/core/settings/settings.dart';
import 'package:app/core/settings/settings_repository.dart';
import 'package:app/core/settings/settings_state.dart';

class SettingsCubit extends LoggingCubit<SettingsState> {
  SettingsCubit({
    required SettingsRepository repository,
    required super.logger,
  }) : _repository = repository,
       super(const SettingsState.loading(), name: name);

  static const name = 'SettingsCubit';

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
        logger.info(
          'Attempted to update settings while in an invalid state',
          fields: {'state': state},
        );

      case SettingsValid(:final settings):
        final newSettings = update(settings);
        await save(newSettings);
    }
  }
}
