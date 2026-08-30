import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:periodt/core/settings/models.dart';
import 'package:periodt/core/settings/notifier.dart';
import 'package:periodt/features/settings/widgets/settings_group.dart';
import 'package:periodt/features/settings/widgets/settings_toggle.dart';

class CycleSettingsScreen extends ConsumerWidget {
  const CycleSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final symptoms = ref.watch(settingsNotifier);

    void toggleSymptom(Function(TrackedSymptomsSettings) toggle) {
      ref.read(settingsNotifier.notifier).updateTrackedSettings(toggle);
    }

    return Scaffold(
      appBar: AppBar(title: const Text("My Cycle")),
      body: ListView(
        children: [
          SettingsGroup(
            children: [
              SettingToggleTile(
                title: "Average Period Length",
                value: false,
                onChanged: (_) {},
              ),
              SettingToggleTile(
                title: "Average Cycle Length",
                value: false,
                onChanged: (_) {},
              ),
            ],
          ),
          const Text("Symptoms to Track"),
          SettingsGroup(
            children: [
              SettingToggleTile(
                title: "Test",
                value: symptoms.trackedSymptoms.bleeding,
                onChanged: (value) => toggleSymptom(
                  (symptoms) => symptoms.copyWith(bleeding: value),
                ),
              ),
              SettingToggleTile(
                title: "Test",
                value: symptoms.trackedSymptoms.body,
                onChanged: (_) => {},
              ),
              SettingToggleTile(
                title: "Test",
                value: symptoms.trackedSymptoms.digestion,
                onChanged: (_) => {},
              ),
              SettingToggleTile(
                title: "Test",
                value: symptoms.trackedSymptoms.discharge,
                onChanged: (_) => {},
              ),
              SettingToggleTile(
                title: "Test",
                value: symptoms.trackedSymptoms.energy,
                onChanged: (_) => {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
