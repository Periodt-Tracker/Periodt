import 'package:app/core/logging/logger.dart';
import 'package:app/core/settings/settings.dart';
import 'package:app/features/security/bloc/security_bloc.dart';
import 'package:app/features/security/bloc/security_state.dart';
import 'package:app/features/security/presentation/pages/methods/device_security_page.dart';
import 'package:app/features/security/presentation/pages/methods/pin_page.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecurityPage extends StatelessWidget {
  const SecurityPage({
    required this.logger,
    required this.settings,
    required this.child,
    super.key,
  });

  final Widget child;
  final PeriodtSettings settings;
  final PeriodtLogger logger;

  Widget _methodPage(SecurityBloc bloc, SecurityMethod method) {
    return switch (method) {
      SecurityMethod.pin => PinPage(security: bloc, logger: logger),
      SecurityMethod.device => DeviceSecurityPage(bloc),
    };
  }

  @override
  Widget build(BuildContext context) {
    final security = SecurityBloc(settings);

    return BlocBuilder<SecurityBloc, SecurityState>(
      bloc: security,
      builder: (context, state) {
        return switch (state) {
          SecurityLocked(:final method) => _methodPage(security, method),
          SecurityLoading() => const Text('Loading...'),
          SecurityUnlocked() => child,
        };
      },
    );
  }
}
