import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_event.freezed.dart';

@freezed
sealed class SecurityEvent with _$SecurityEvent {
  const SecurityEvent._();

  const factory SecurityEvent.pinEntered(String pin) = PinEnteredEvent;

  const factory SecurityEvent.pinSet(String pin) = PinSetEvent;

  const factory SecurityEvent.deviceEntered() = DeviceEnteredEvent;

  const factory SecurityEvent.settingsUpdated() = SettingsUpdatedEvent;
}
