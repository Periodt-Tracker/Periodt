import 'package:app/app/app_event.dart';
import 'package:app/app/app_phase.dart';
import 'package:app/app/theme/base.dart';
import 'package:app/core/logging/app_logger_initialiser.dart';
import 'package:app/core/logging/observers/blob_logging_observer.dart';
import 'package:app/core/settings/settings_repository.dart';
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
    final bloc = AppBloc(repository)..add(const AppEvent.started());

    final wizard = SetupWizardBloc();

    return MaterialApp(
      title: 'Periodt',
      theme: PeriodtTheme.light,
      home: BlocBuilder<AppBloc, AppPhase>(
        bloc: bloc,
        builder: (context, state) {
          return switch (state) {
            Startup() => const Text('Starting...'),
            Setup() => SetupPage(wizard: wizard),
            Ready(:final settings) => const Text('Ready!'),
          };
        },
      ),
    );
  }
}
