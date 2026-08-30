import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:periodt/core/settings/models.dart';
import 'package:periodt/core/settings/notifier.dart';
import 'package:periodt/features/settings/widgets/settings_group.dart';
import 'package:periodt/features/settings/widgets/settings_radio.dart';
import 'package:periodt/features/settings/widgets/settings_toggle.dart';

class SecuritySettingsScreen extends ConsumerWidget {
  const SecuritySettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = GoRouter.of(context);
    final settings = ref.watch(settingsNotifier.select((s) => s.security));

    void updateSecurityMethod(SecurityMethod? method) {
      if (method == null) {
        return;
      }

      if (method == SecurityMethod.pin) {
        // pin set-up is responsible for actually enabling pin authentication
        // to reduce the odds of enabling it without a pin.
        navigator.push("/pin-setup");
        return;
      }

      final notifier = ref.read(settingsNotifier.notifier);
      notifier.updateSecuritySettings((s) => s.copyWith(method: method));
    }

    // althought this should be a toggle it's more important we reflect the
    // current state of the UI over the actual value of the toggle incase
    // they become de-synched for any reason.
    //
    void setLockOnResume(bool value) {
      final notifier = ref.read(settingsNotifier.notifier);

      notifier.updateSecuritySettings((s) => s.copyWith(lockOnResume: value));
    }

    // again favour the state of the UI over the actual value
    //
    void setPrivacyScreen(bool value) {
      final notifier = ref.read(settingsNotifier.notifier);

      notifier.updateSecuritySettings((s) => s.copyWith(privacyScreen: value));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Security")),
      body: ListView(
        children: [
          SettingsRadioGroup<SecurityMethod>(
            value: settings.method,
            values: {
              SecurityMethod.none: RadioTileOptions(
                title: "None",
                description: "No security method, anyone can access the app",
              ),
              SecurityMethod.pin: RadioTileOptions(
                title: "PIN",
                description: "Require a 4-digit PIN to access the app",
              ),
              SecurityMethod.device: RadioTileOptions(
                title: "Biometric",
                description:
                    "Use fingerprint or face recognition to access the app",
              ),
            },
            onChanged: updateSecurityMethod,
          ),
          SettingsGroup(
            children: [
              SettingToggleTile(
                title: "Lock on Resume",
                value: settings.lockOnResume,
                onChanged: setLockOnResume,
                disabled: settings.method == SecurityMethod.none,
              ),
              SettingToggleTile(
                title: "Privacy Screen",
                value: settings.privacyScreen,
                onChanged: setPrivacyScreen,
                disabled: settings.method == SecurityMethod.none,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
