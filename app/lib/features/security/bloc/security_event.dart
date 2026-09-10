import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_event.freezed.dart';

@freezed
sealed class SecurityEvent with _$SecurityEvent {
  const SecurityEvent._();

  const factory SecurityEvent.settingsUpdated() = SettingsUpdatedEvent;

  const factory SecurityEvent.locked() = LockedEvent;

  const factory SecurityEvent.appResumed() = AppResumedEvent;

  const factory SecurityEvent.unlocked() = UnlockedEvent;
}
