import 'package:app/features/security/bloc/device_security_bloc.dart';
import 'package:app/features/security/bloc/device_security_event.dart';
import 'package:app/features/security/bloc/security_bloc.dart';
import 'package:app/features/security/presentation/layouts/security_page_layout.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:local_auth/local_auth.dart';

class DeviceSecurityPage extends StatefulWidget {
  const DeviceSecurityPage(this.security, {super.key});

  final SecurityBloc security;

  @override
  State<DeviceSecurityPage> createState() => _DeviceSecurityPageState();
}

class _DeviceSecurityPageState extends State<DeviceSecurityPage> {
  @override
  void initState() {
    super.initState();

    _deviceSecurity = DeviceSecurityBloc(security: widget.security);

    WidgetsBinding.instance.addPostFrameCallback((_) => _tryUnlock());
  }

  late final DeviceSecurityBloc _deviceSecurity;

  void _tryUnlock() {
    _deviceSecurity.add(const AuthenticationRequestedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SecurityPageLayout(
      child: Center(
        child: SizedBox(
          width: 64,
          height: 64,
          child: ElevatedButton(
            onPressed: _tryUnlock,
            style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              padding: EdgeInsets.zero,
              backgroundColor: Colors.white.withOpacity(0.3),
            ),
            child: const FaIcon(
              FontAwesomeIcons.fingerprint,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ),
    );
  }
}
