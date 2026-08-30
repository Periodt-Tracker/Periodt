// Copyright (c) Periodt. 2026
//
// This file is part of Periodt and licensed under the PSAL v1.0.
// See the LICENSE file for details.
//
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:periodt/core/form/models/wizard.dart';
import 'package:periodt/core/theme/app.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// a re-usable helper widget for wizard forms providing controls to
// navigate between pages
//
class WizardControls extends HookWidget {
  final PeriodtWizardController form;

  const WizardControls(this.form, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        children: [
          ListenableBuilder(
            listenable: form,
            builder: (_, _) => SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: form.canContinue ? form.next : null,
                iconAlignment: IconAlignment.end,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PeriodtTheme.period.primary,
                  foregroundColor: Colors.white,
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
                icon: const Icon(Icons.arrow_forward),
                label: const Text("Continue"),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (form.canGoBack) ...[
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
                ],
                SmoothPageIndicator(
                  controller: form.pageController,
                  count: form.stepCount,
                  effect: WormEffect(
                    activeDotColor: PeriodtTheme.period.primary,
                    radius: 16,
                    dotWidth: 12,
                    dotHeight: 12,
                    spacing: 4,
                  ),
                  onDotClicked: (index) => form.back(to: index),
                ),
                if (form.pageSkippable && !form.isLastPage) ...[
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: form.next,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black54,
                      ),
                      child: const Text("Skip"),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
