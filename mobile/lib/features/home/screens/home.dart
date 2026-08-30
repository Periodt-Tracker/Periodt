import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:periodt/core/forcast/provider.dart';
import 'package:periodt/core/settings/notifier.dart';
import 'package:periodt/core/theme/app.dart';
import 'package:periodt/core/theme/base/text.dart';
import 'package:periodt/core/widgets/curved_divider/curved_divider.dart';
import 'package:periodt/features/home/widgets/cycle_view.dart';
import 'package:periodt/features/home/widgets/greeting.dart';
import 'package:periodt/features/home/widgets/phase.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = GoRouter.of(context);

    final settings = ref.watch(settingsNotifier.select((s) => s.user));
    final forecast = ref.watch(forecastProvider);

    return Scaffold(
      body: ListView(
        // ensure the top background goes behind the safe area
        padding: EdgeInsets.zero,

        children: [
          Container(
            decoration: BoxDecoration(color: PeriodtTheme.period.primary),
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Column(
              spacing: 38,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GreetingText(),
                      IconButton(
                        iconSize: 36,
                        onPressed: () => navigator.push("/settings"),
                        icon: Icon(Icons.menu_rounded),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                forecast.when(
                  data: (forecast) => CycleView(forecast: forecast),
                  error: (error, _) => Text("Error: $error"),
                  loading: () => const CircularProgressIndicator(),
                ),
              ],
            ),
          ),
          CurvedDivider(color: PeriodtTheme.period.primary, height: 30),
          PhaseDetails(),
          // space to dodge the navigation bar
          Container(height: 128),
        ],
      ),
    );
  }
}
