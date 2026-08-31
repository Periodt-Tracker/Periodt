import 'package:app/core/settings/settings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

@freezed
sealed class SettingsState with _$SettingsState {
  const factory SettingsState.loading() = SettingsLoading;

  const factory SettingsState.missing() = SettingsMissing;

  const factory SettingsState.invalid(Object reason) = SettingsInvalid;

  const factory SettingsState.valid(PeriodtSettings settings) = SettingsValid;
}
