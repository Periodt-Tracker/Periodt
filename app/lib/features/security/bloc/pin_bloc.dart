import 'dart:async';
import 'dart:math';

import 'package:app/core/logging/bloc/logging_bloc.dart';
import 'package:app/core/utilities/result.dart';
import 'package:app/features/security/bloc/pin_event.dart';
import 'package:app/features/security/bloc/pin_state.dart';
import 'package:app/features/security/bloc/security_bloc.dart';
import 'package:app/features/security/bloc/security_event.dart';
import 'package:app/features/security/data/repositories/pin_repository.dart';
import 'package:app/features/security/domain/pin.dart';
import 'package:clock/clock.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const int maxPinAttempts = 3;
const Duration timeoutDuration = Duration(seconds: 30);

class PinSecurityBloc extends LoggingBloc<PinSecurityEvent, PinSecurityState> {
  PinSecurityBloc({
    required this.repository,
    required this.security,
    required super.logger,
  }) : super(const PinSecurityState.loading(), name: name) {
    on<PinEnteredEvent>(_onPinEntered);
    on<LoadPinEvent>(_onLoad);
    on<PinLockoutExpiredEvent>(_onLockoutExpired);
  }

  static const name = 'PinSecurityBloc';

  final SecurityBloc security;
  final PinRepository repository;

  Timer? _lockoutTimer;

  Future<void> _onLoad(
    LoadPinEvent event,
    Emitter<PinSecurityState> emit,
  ) async {
    final result = await repository.isPinSetup();

    switch (result) {
      case Ok(value: true):
        emit(const PinSecurityState.ready(attemptsRemaining: maxPinAttempts));

      case Ok(value: false):
        emit(const PinSecurityState.setup());

      case Err(:final error):
        emit(PinSecurityState.failure(message: error.toString()));
    }
  }

  Future<void> _onPinEntered(
    PinEnteredEvent event,
    Emitter<PinSecurityState> emit,
  ) async {
    final update = switch (state) {
      PinSecurityFailureState() || PinSecurityLoadingState() => null,

      PinSecurityReadyState(:final attemptsRemaining) =>
        await _handlePinVerification(event.pin, attemptsRemaining),

      PinSecuritySetupState() => PinSecurityState.confirm(pin: event.pin),

      PinSecurityConfirmState(:final pin) => await _handlePinConfirmation(
        pin,
        event.pin,
      ),

      PinSecurityLockedState(:final until) => await _handleLockedState(
        event.pin,
        until,
      ),
    };

    if (update != null) {
      emit(update);
    }
  }

  Future<void> _onLockoutExpired(
    PinLockoutExpiredEvent event,
    Emitter<PinSecurityState> emit,
  ) async {
    emit(const PinSecurityState.ready(attemptsRemaining: maxPinAttempts));
  }

  Future<PinSecurityState?> _handlePinConfirmation(
    PinType first,
    PinType second,
  ) async {
    if (first.value != second.value) {
      return const PinSecurityState.setup();
    }

    final result = await repository.setPin(first);

    switch (result) {
      // fix: on a successful pin reprication we might as well just unlock
      // the app rather than asking for the same pin a third time
      case Ok():
        security.add(const SecurityEvent.unlocked());
        return null;

      case Err(:final error):
        return PinSecurityState.failure(message: error.toString());
    }
  }

  Future<PinSecurityState?> _handleLockedState(
    PinType pin,
    DateTime until,
  ) async {
    final now = clock.now();

    if (now.isBefore(until)) {
      return null;
    }

    return _handlePinVerification(pin, maxPinAttempts);
  }

  Future<PinSecurityState?> _handlePinVerification(
    PinType pin,
    int attemptsRemaining,
  ) async {
    final result = await repository.verifyPin(pin);

    switch (result) {
      case Ok(value: true):
        security.add(const SecurityEvent.unlocked());
        return null;

      case Ok(value: false):
        if (attemptsRemaining <= 1) {
          final until = clock.fromNowBy(timeoutDuration);
          _startLockoutTimer(until);

          return PinSecurityState.timedOut(until: until);
        }

        return PinSecurityState.ready(attemptsRemaining: attemptsRemaining - 1);

      case Err(:final error):
        return PinSecurityState.failure(message: error.toString());
    }
  }

  void _startLockoutTimer(DateTime until) {
    final existingTimer = _lockoutTimer;

    if (existingTimer != null) {
      existingTimer.cancel();
    }

    final duration = until.difference(clock.now());

    _lockoutTimer = Timer(duration, () {
      add(const PinSecurityEvent.lockoutExpired());
    });
  }

  Duration lockoutDuration(int level) {
    final seconds = 30 * (1 << (level - 1));

    return Duration(
      seconds: min(seconds, const Duration(hours: 1).inSeconds),
    );
  }
}
