import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_state.freezed.dart';

@freezed
sealed class SecurityState with _$SecurityState {
  const SecurityState._();

  const factory SecurityState.locked() = SecurityLocked;

  const factory SecurityState.pinRequired() = PinRequired;

  const factory SecurityState.pinLoading() = PinLoading;

  const factory SecurityState.pinMissing() = PinMissing;

  const factory SecurityState.deviceLoginRequired() = DeviceLoginRequired;

  const factory SecurityState.authenticated() = Authenticated;
}
