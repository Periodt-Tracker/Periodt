import 'package:app/features/security/domain/pin.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_event.freezed.dart';

@freezed
sealed class PinSecurityEvent with _$PinSecurityEvent {
  const factory PinSecurityEvent.pinEntered({required PinType pin}) =
      PinEnteredEvent;

  const factory PinSecurityEvent.load() = LoadPinEvent;

  const factory PinSecurityEvent.lockoutExpired() = PinLockoutExpiredEvent;
}
