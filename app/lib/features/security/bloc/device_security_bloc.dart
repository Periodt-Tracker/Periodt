import 'package:app/features/security/bloc/device_security_event.dart';
import 'package:app/features/security/bloc/device_security_state.dart';
import 'package:app/features/security/bloc/security_bloc.dart';
import 'package:app/features/security/bloc/security_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

class DeviceSecurityBloc
    extends Bloc<DeviceSecurityEvent, DeviceSecurityState> {
  DeviceSecurityBloc({required SecurityBloc security})
    : _security = security,
      super(const DeviceSecurityState.ready()) {
    on<AuthenticationRequestedEvent>(_onAuthenticationRequested);
  }

  final SecurityBloc _security;

  Future<void> _onAuthenticationRequested(
    AuthenticationRequestedEvent event,
    Emitter<DeviceSecurityState> emit,
  ) async {
    final authentication = LocalAuthentication();

    try {
      final authenticated = await authentication.authenticate(
        localizedReason: 'Please authenticate to unlock the app',
      );

      if (authenticated) {
        _security.add(const UnlockedEvent());
      }
    } on LocalAuthException catch (e) {
      switch (e.code) {
        case LocalAuthExceptionCode.authInProgress:
          print('Authentication already in progress');
          break;

        case LocalAuthExceptionCode.biometricLockout:
        case LocalAuthExceptionCode.temporaryLockout:
        case LocalAuthExceptionCode.timeout:
        case LocalAuthExceptionCode.biometricHardwareTemporarilyUnavailable:
          print('Device locked out, waiting for timeout');
          break;

        // if there are no valid credentials to check against we end up in
        // a slightly owkward position where we can either:
        //
        // 1. ask the user to go away and set up their PIN or...
        // 2. just let them in perhaps showing a dialogue about the issue
        //
        // given on most devices in order to set up a PIN, fingerpint, etc,
        // without one at all already set up the user does not need any
        // credentials we don't actually gain any security by blocking them
        // from using the app and just minorly inconvenience them
        //
        // this also works in reverse most devices would require an existing
        // credential to remove another and hence we are no more secure by
        // trying to block against someone removing another person's pin
        // as they could have just unlocked the device in the first place
        //
        // hence we just log the issue and let them in
        //
        case LocalAuthExceptionCode.noCredentialsSet:
          _security.add(const UnlockedEvent());
          break;

        case _:
          print('Unknown error during authentication: $e');
          break;
      }
    }
  }
}
