import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_security_event.freezed.dart';

@freezed
sealed class DeviceSecurityEvent with _$DeviceSecurityEvent {
  const factory DeviceSecurityEvent.authenticationRequested() =
      AuthenticationRequestedEvent;
}
