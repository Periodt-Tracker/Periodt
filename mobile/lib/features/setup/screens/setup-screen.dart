import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:periodt/core/settings/notifier.dart';
import 'package:periodt/core/theme/app.dart';
import 'package:periodt/core/theme/base/text.dart';
import 'package:periodt/features/setup/data/controller.dart';
import 'package:periodt/features/setup/widgets/last-period.dart';
import 'package:periodt/features/setup/widgets/name.dart';
import 'package:periodt/features/setup/widgets/period-duration.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SetupScreen extends HookConsumerWidget {
  const SetupScreen({super.key});

  void _handleSubmit(WidgetRef ref, SetupFormState value) {
    ref.read(settingsNotifier.notifier).completeSetup();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final form = useSetupForm(onSubmit: (value) => _handleSubmit(ref, value));

    return PopScope(
      canPop: form.canGoBack,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) {
          return;
        }

        form.back();
      },
      child: Scaffold(
        backgroundColor: PeriodtTheme.period.secondary,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  children: [
                    Text(
                      "Welcome to Periodt!",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: PeriodtText.display,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 32,
                  ),
                  child: Column(
                    spacing: 8,
                    children: [
                      Expanded(
                        child: PageView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: form.pageController,
                          children: [
                            NameForm(form),
                            PeriodDurationForm(form),
                            Text("third page"),
                            LastPeriodForm(),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: form.next,
                          iconAlignment: IconAlignment.end,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: PeriodtTheme.period.primary,
                            foregroundColor: Colors.white,
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          icon: const Icon(Icons.arrow_forward),
                          label: Text("Continue"),
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton.icon(
                                onPressed: form.back,
                                icon: const Icon(Icons.arrow_back),
                                style: TextButton.styleFrom(
                                  foregroundColor: Colors.black54,
                                ),
                                label: Text("Back"),
                              ),
                            ),
                            SmoothPageIndicator(
                              controller: form.pageController,
                              count: 4,
                              effect: WormEffect(
                                activeDotColor: PeriodtTheme.period.primary,
                                radius: 16,
                                dotWidth: 12,
                                dotHeight: 12,
                                spacing: 4,
                              ),
                              onDotClicked: (index) => form.back(to: index),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
