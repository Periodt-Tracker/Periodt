import 'package:hooks_riverpod/legacy.dart';
import 'package:periodt/core/security/state.dart';
import 'package:periodt/core/settings/models.dart';
import 'package:periodt/core/settings/notifier.dart';

class SecurityNotifier extends StateNotifier<SecurityState> {
  SecurityNotifier(super.state);

  static bool _authenticatedByDefault(SecurityMethod method) {
    switch (method) {
      case SecurityMethod.pin:
      case SecurityMethod.device:
        return false;
      case SecurityMethod.none:
        return true;
    }
  }

  factory SecurityNotifier.initial(SecurityMethod method) {
    final authenticated = _authenticatedByDefault(method);
    final state = SecurityState(authenticated: authenticated);

    return SecurityNotifier(state);
  }

  void unlock() {
    state = state.copyWith(authenticated: true);
  }

  void lock() {
    state = state.copyWith(authenticated: false);
  }
}

final securityNotifier = StateNotifierProvider<SecurityNotifier, SecurityState>(
  (ref) {
    final settings = ref.watch(settingsNotifier);

    return SecurityNotifier.initial(settings.security.method);
  },
);
