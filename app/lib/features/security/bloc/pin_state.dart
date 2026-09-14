import 'package:app/features/security/domain/pin.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'pin_state.freezed.dart';

@freezed
sealed class PinSecurityState with _$PinSecurityState {
  const factory PinSecurityState.loading() = PinSecurityLoadingState;

  const factory PinSecurityState.ready({required int attemptsRemaining}) =
      PinSecurityReadyState;

  const factory PinSecurityState.setup() = PinSecuritySetupState;

  const factory PinSecurityState.confirm({required PinType pin}) =
      PinSecurityConfirmState;

  const factory PinSecurityState.timedOut({required DateTime until}) =
      PinSecurityLockedState;

  const factory PinSecurityState.failure({required String message}) =
      PinSecurityFailureState;
}
