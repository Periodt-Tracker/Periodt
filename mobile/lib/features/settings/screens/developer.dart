import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:periodt/core/forcast/backend/models.dart';
import 'package:periodt/core/settings/notifier.dart';
import 'package:periodt/features/settings/widgets/settings_radio.dart';

class DeveloperSettingsScreen extends ConsumerWidget {
  const DeveloperSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifier.select((s) => s.developer));

    void setForecastModel(ForcastModel? model) {
      if (model == null) {
        return;
      }

      final notifier = ref.read(settingsNotifier.notifier);
      notifier.updateDeveloperSettings((s) => s.copyWith(forecastModel: model));
    }

    void resetSetup() {
      final notifier = ref.read(settingsNotifier.notifier);

      notifier.resetSetup();
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Developer Settings")),
      body: Column(
        children: [
          SettingsRadioGroup(
            value: settings.forecastModel,
            values: {
              ForcastModel.fixture: RadioTileOptions(
                title: "Fixture",
                description: "Use a fixed mock forcast",
              ),
              ForcastModel.simple: RadioTileOptions(
                title: "Simple",
                description: "Use a simple fixed pattern model",
              ),
              ForcastModel.hsmm: RadioTileOptions(
                title: "HSMM",
                description: "(Reccommended) Use a hidden semi-markov model",
              ),
              ForcastModel.hanging: RadioTileOptions(
                title: "Hanging",
                description:
                    "A model that never completes to test loading states",
              ),
            },
            onChanged: setForecastModel,
          ),

          ElevatedButton(
            onPressed: resetSetup,
            child: const Text("Reset Setup"),
          ),
        ],
      ),
    );
  }
}
