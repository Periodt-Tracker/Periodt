import 'package:app/app/theme/base.dart';
import 'package:app/core/logging/logger.dart';
import 'package:app/features/security/bloc/pin_bloc.dart';
import 'package:app/features/security/bloc/pin_event.dart';
import 'package:app/features/security/bloc/pin_state.dart';
import 'package:app/features/security/bloc/security_bloc.dart';
import 'package:app/features/security/data/repositories/pin_repository.dart';
import 'package:app/features/security/domain/pin.dart';
import 'package:app/features/security/presentation/layouts/pin_layout.dart';
import 'package:app/features/security/presentation/layouts/security_page_layout.dart';
import 'package:app/features/security/presentation/widgets/pin_input.dart';
import 'package:app/features/security/presentation/widgets/pin_lockout_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinPage extends StatelessWidget {
  const PinPage({required this.security, required this.logger, super.key});

  final SecurityBloc security;
  final PeriodtLogger logger;

  void _handlePinEntered(PinSecurityBloc bloc, PinType pin) {
    bloc.add(PinSecurityEvent.pinEntered(pin: pin));
  }

  Widget _buildLoading(PinSecurityBloc bloc) {
    return const Center(child: CircularProgressIndicator(color: Colors.white));
  }

  Widget _buildReadyState(PinSecurityBloc bloc, int attemptsRemaining) {
    return PinLayout(
      title: 'Enter your PIN',
      pinInput: PinInput(
        key: UniqueKey(),
        onPinEntered: (pin) => _handlePinEntered(bloc, pin),
      ),
      child: Text(
        'Attempts remaining: $attemptsRemaining',
        style: TextStyle(color: PeriodtTheme.colorScheme.onPrimary),
      ),
    );
  }

  Widget _buildSetupState(PinSecurityBloc bloc) {
    return PinLayout(
      title: 'Set up your PIN',
      pinInput: PinInput(
        key: UniqueKey(),
        onPinEntered: (pin) => _handlePinEntered(bloc, pin),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Text(
          'Make sure to choose a PIN you will remember. You will need this to open the app in the future.',
          textAlign: TextAlign.center,
          style: TextStyle(color: PeriodtTheme.colorScheme.onPrimary),
        ),
      ),
    );
  }

  Widget _buildConfirmState(PinSecurityBloc bloc) {
    return PinLayout(
      title: 'Confirm your PIN',
      pinInput: PinInput(
        key: UniqueKey(),
        onPinEntered: (pin) => _handlePinEntered(bloc, pin),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Text(
          'Make sure to choose a PIN you will remember. You will need this to open the app in the future.',
          textAlign: TextAlign.center,
          style: TextStyle(color: PeriodtTheme.colorScheme.onPrimary),
        ),
      ),
    );
  }

  Widget _buildLockedState(PinSecurityBloc bloc, DateTime until) {
    return PinLayout(
      title: 'Locked',
      pinInput: const PinInput(enabled: false),
      child: PinLockoutView(
        until: until,
        formatter: (remaining) => Text(
          'Try again in ${_formatRemaining(remaining)}',
          style: TextStyle(color: PeriodtTheme.colorScheme.onPrimary),
        ),
      ),
    );
  }

  String _formatRemaining(Duration remaining) {
    if (remaining.inHours > 0) {
      final hours = remaining.inHours;

      return '$hours ${hours == 1 ? 'hour' : 'hours'}';
    }

    if (remaining.inMinutes > 0) {
      final minutes = remaining.inMinutes;

      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'}';
    }

    // hack: the remaining duration is truncated so things like 0.8 seconds
    // left will be displayed as "0 seconds" if we directly used `.inSeconds`
    // so we always round up
    final milliseconds = remaining.inMilliseconds;
    final seconds = (milliseconds / 1000).ceil();

    return '$seconds ${seconds == 1 ? 'second' : 'seconds'}';
  }

  @override
  Widget build(BuildContext context) {
    const storage = FlutterSecureStorage();

    final repository = SecureStoragePinRepository(secureStorage: storage);

    final pinBloc = PinSecurityBloc(
      repository: repository,
      logger: logger,
      security: security,
    )..add(const PinSecurityEvent.load());

    return SecurityPageLayout(
      child: BlocBuilder<PinSecurityBloc, PinSecurityState>(
        bloc: pinBloc,
        builder: (context, state) {
          return switch (state) {
            PinSecurityLoadingState() => _buildLoading(pinBloc),

            PinSecurityReadyState(:final attemptsRemaining) => _buildReadyState(
              pinBloc,
              attemptsRemaining,
            ),

            PinSecuritySetupState() => _buildSetupState(pinBloc),

            PinSecurityConfirmState() => _buildConfirmState(pinBloc),

            PinSecurityLockedState(:final until) => _buildLockedState(
              pinBloc,
              until,
            ),

            PinSecurityFailureState() => throw UnimplementedError(),
          };
        },
      ),
    );
  }
}
