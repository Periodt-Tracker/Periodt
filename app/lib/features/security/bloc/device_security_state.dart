import 'package:freezed_annotation/freezed_annotation.dart';

part 'device_security_state.freezed.dart';

@freezed
sealed class DeviceSecurityState with _$DeviceSecurityState {
  const factory DeviceSecurityState.ready() = DeviceSecurityReadyState;

  const factory DeviceSecurityState.timedOut({required DateTime until}) =
      DeviceSecurityLockedState;
}
