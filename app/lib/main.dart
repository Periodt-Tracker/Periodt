import 'package:app/app/app_event.dart';
import 'package:app/app/app_phase.dart';
import 'package:app/app/theme/base.dart';
import 'package:app/core/logging/app_logger_initialiser.dart';
import 'package:app/core/logging/observers/blob_logging_observer.dart';
import 'package:app/core/settings/settings_cubit.dart';
import 'package:app/core/settings/settings_repository.dart';
import 'package:app/core/settings/settings_state.dart';
import 'package:app/features/setup/bloc/setup_wizard_bloc.dart';
import 'package:app/features/setup/presentation/pages/setup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppLoggerInitializer.init();

  Bloc.observer = AppBlocObserver();

  runAppGuarded(() => runApp(const PeriodtApp()));
}

class PeriodtApp extends StatelessWidget {
  const PeriodtApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = MockSettingsRepository();
    final settingsCubit = SettingsCubit(repository: repository);

    return MaterialApp(
      title: 'Periodt',
      theme: PeriodtTheme.light,
      home: BlocBuilder<SettingsCubit, SettingsState>(
        bloc: settingsCubit,
        builder: (context, state) {
          return switch (state) {
            // TODO: We should probably have a proper splash screen here
            SettingsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),

            // todo: it may be worth introducing a sort of "recovery"
            // protocol for corrupted settings
            //
            SettingsMissing() || SettingsInvalid() => SetupPage(
              wizard: SetupWizardBloc(settings: settingsCubit),
            ),

            SettingsValid(:final settings) => const Text('AAA'),
          };
        },
      ),
    );
  }
}
