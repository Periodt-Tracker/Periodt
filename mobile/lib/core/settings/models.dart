import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@JsonEnum()
enum SecurityMethod { none, pin, device }

@JsonEnum()
enum RequestedSetting { ask, active, disabled }

@freezed
abstract class SecuritySettings with _$SecuritySettings {
  const factory SecuritySettings({
    @Default(SecurityMethod.none) SecurityMethod method,
    @Default(false) bool privacyScreen,
    @Default(false) bool lockOnResume,
  }) = _SecuritySettings;

  factory SecuritySettings.fromJson(Map<String, dynamic> json) =>
      _$SecuritySettingsFromJson(json);
}

@freezed
abstract class TrackedSymptomsSettings with _$TrackedSymptomsSettings {
  const factory TrackedSymptomsSettings({
    @Default(true) bool bleeding,
    @Default(true) bool discharge,
    @Default(true) bool mood,
    @Default(true) bool sensations,
    @Default(true) bool digestion,
    @Default(false) bool energy,
    @Default(false) bool body,
    @Default(false) bool sex,
  }) = _TrackedSymptomsSettings;

  factory TrackedSymptomsSettings.fromJson(Map<String, dynamic> json) =>
      _$TrackedSymptomsSettingsFromJson(json);
}

@freezed
abstract class NotificationSettings with _$NotificationSettings {
  const factory NotificationSettings({
    @Default(RequestedSetting.ask) RequestedSetting enabled,
  }) = _NotifcationSettings;

  factory NotificationSettings.fromJson(Map<String, dynamic> json) =>
      _$NotificationSettingsFromJson(json);
}

@freezed
abstract class UserSettings with _$UserSettings {
  const factory UserSettings({
    @Default(null) String? name,
    @Default("en") String locale,
    @Default(null) int? age,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}

@freezed
abstract class PeriodtSettings with _$PeriodtSettings {
  const factory PeriodtSettings({
    @Default(1) int version,
    @Default(false) bool setupComplete,
    @Default(UserSettings()) user,
    @Default(SecuritySettings()) SecuritySettings security,
    @Default(NotificationSettings()) NotificationSettings notifications,
  }) = _PeriodtSettings;

  factory PeriodtSettings.fromJson(Map<String, dynamic> json) =>
      _$PeriodtSettingsFromJson(json);
}
