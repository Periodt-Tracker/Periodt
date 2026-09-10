import 'package:app/core/settings/settings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'security_state.freezed.dart';

@freezed
sealed class SecurityState with _$SecurityState {
  const SecurityState._();

  const factory SecurityState.loading() = SecurityLoading;

  const factory SecurityState.locked(SecurityMethod method) = SecurityLocked;

  const factory SecurityState.unlocked() = SecurityUnlocked;
}
