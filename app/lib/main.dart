import 'package:app/app/theme/base.dart';
import 'package:app/core/logging/logger.dart';
import 'package:app/core/logging/sinks/console_sink.dart';
import 'package:app/core/settings/settings_cubit.dart';
import 'package:app/core/settings/settings_repository.dart';
import 'package:app/core/settings/settings_state.dart';
import 'package:app/features/security/presentation/pages/security_page.dart';
import 'package:app/features/setup/presentation/pages/welcome_page.dart';
import 'package:app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = PeriodtLogger.root(sinks: [ConsoleSink()]);

  await LocaleSettings.useDeviceLocale();

  final settingsCubit = SettingsCubit(
    repository: MockSettingsRepository(),
    logger: logger,
  )..load();

  runApp(
    TranslationProvider(
      child: PeriodtApp(settingsCubit: settingsCubit, logger: logger),
    ),
  );
}

class PeriodtApp extends StatelessWidget {
  const PeriodtApp({
    required this.settingsCubit,
    required this.logger,
    super.key,
  });

  final PeriodtLogger logger;
  final SettingsCubit settingsCubit;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: t.name,
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: PeriodtTheme.light,
      home: BlocBuilder<SettingsCubit, SettingsState>(
        bloc: settingsCubit,
        builder: (context, state) {
          return switch (state) {
            SettingsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),

            // todo: it may be worth introducing a sort of "recovery"
            // protocol for corrupted settings
            //
            SettingsMissing() || SettingsInvalid() => const WelcomePage(),

            SettingsValid(:final settings) => SecurityPage(
              settings: settings,
              logger: logger,
              child: const Text('Welcome to the app'),
            ),
          };
        },
      ),
    );
  }
}
