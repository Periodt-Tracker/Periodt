import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:periodt/core/form/widgets/date_range.dart';
import 'package:periodt/core/form/widgets/range.dart';
import 'package:periodt/core/form/widgets/text.dart';
import 'package:periodt/core/settings/notifier.dart';
import 'package:periodt/core/widgets/layout/bottom_sheet.dart';
import 'package:periodt/features/setup/data/controller.dart';
import 'package:periodt/features/setup/data/pages/cycle_length.dart';
import 'package:periodt/features/setup/data/pages/last_period.dart';
import 'package:periodt/features/setup/data/pages/period_length.dart';
import 'package:periodt/features/setup/data/pages/user.dart';
import 'package:periodt/features/setup/widgets/past_periods.dart';

class SetupForm extends HookConsumerWidget {
  const SetupForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void complete() {
      ref.watch(settingsNotifier.notifier).completeSetup();
    }

    final form = useSetupForm(onSubmit: (event) => {print(event)});

    return BottomSheetScreen(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 32),
          // Logo and Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Periodt.',
                  style: TextStyle(
                    color: Color(0xFFE08283),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(onPressed: complete, child: const Text("FUCk")),
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  tween: Tween<double>(end: form.currentStep / form.stepCount),
                  builder: (context, value, child) {
                    return LinearProgressIndicator(
                      value: value,
                      backgroundColor: Colors.grey[200],
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFFE08283),
                      ),
                      minHeight: 8,
                      borderRadius: BorderRadius.circular(4),
                    );
                  },
                ),
              ],
            ),
          ),

          // Multi-Step Form Pages
          Expanded(
            child: PageView(
              controller: form.pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildNameStep(form.user),
                _buildDateStep(form.lastPeriod),
                _buildCycleLengthStep(form.cycleLength),
                _buildPeriodLengthStep(form.periodLength),
              ],
            ),
          ),

          // Navigation Buttons
          Padding(
            padding: const EdgeInsets.all(32.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: form.back,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.grey[600],
                    side: BorderSide(color: Colors.grey[300]!),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('Back'),
                ),
                ListenableBuilder(
                  listenable: form,
                  builder: (_, _) => ElevatedButton(
                    onPressed: form.canContinue ? form.next : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE08283),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    // Update button text dynamically
                    child: Text(
                      form.currentStep == form.stepCount - 1
                          ? 'Finish'
                          : 'Continue',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameStep(UserPageState form) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text(
            'What should we call you?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          HookedTextField(field: form.name),
          const SizedBox(height: 20),
          Text(
            'Periodt. will only use this name to personalize your experience. It won\'t be shared with anyone or ever leave your device.',
            style: TextStyle(color: Colors.grey[500], height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDateStep(LastPeriodPageState form) {
    String format(List<DateTime?>? range) {
      if (range == null || range.isEmpty) {
        return "Select date";
      }

      var start = range.first;
      var end = range.length > 1 ? range.last : null;

      if (start != null && end != null) {
        return "${start.month}/${start.day}/${start.year} - ${end.month}/${end.day}/${end.year}";
      } else if (start != null) {
        return "${start.month}/${start.day}/${start.year}";
      } else {
        return "Select date";
      }
    }

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text(
            'When were your last periods?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Expanded(child: PastPeriods(form)),
          // child: DateRangePicker(
          //   formField: form.lastPeriod,
          //   transformer: (newValue, previous) {
          //     var newCleaned = newValue.nonNulls.toList();

          //     if (newCleaned.isEmpty) {
          //       return null;
          //     }

          //     if (previous == null) {
          //       var anchor = newCleaned.first;
          //       var future = anchor.add(const Duration(days: 4));

          //       return [anchor, future];
          //     }

          //     var previousCleaned = previous.nonNulls.toList();

          //     if (previousCleaned.length == 2) {
          //       var oldStart = previousCleaned.first;
          //       var oldEnd = previousCleaned.last;

          //       var newEnd = newCleaned.last;

          //       if (oldStart == newCleaned.first || oldStart == newEnd) {
          //         return null;
          //       }

          //       if (oldStart.isBefore(newEnd) && oldEnd.isAfter(newEnd)) {
          //         return [oldStart, newEnd];
          //       }

          //       var anchor = newCleaned.first;
          //       var future = anchor.add(const Duration(days: 4));

          //       return [anchor, future];
          //     }

          //     return null;
          //   },
          // ),
          const SizedBox(height: 20),
          // Text(
          //   "If you're not sure that's completely okay, just pick a date that is close to the actual date and we'll work it all out. \n\nOur first few guesses may be a little off though :)",
          //   style: TextStyle(color: Colors.grey[500], height: 1.5),
          // ),
        ],
      ),
    );
  }

  Widget _buildCycleLengthStep(CycleLengthPageState form) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text(
            'How long are your cycles usually?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 150,
            child: RangePicker(
              form.cycleLength,
              min: 21,
              max: 35,
              formatter: (value) => Text('$value'),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'If you aren\'t sure, just pick the average length. You can always adjust this later on.',
            style: TextStyle(color: Colors.grey[500], height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodLengthStep(PeriodLengthPageState form) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text(
            'How long are your periods usually?',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          // TODO: add an ctual cycle lenght picker
          const SizedBox(height: 20),
          Text(
            'If you aren\'t sure, just pick the average length. You can always adjust this later on.',
            style: TextStyle(color: Colors.grey[500], height: 1.5),
          ),
        ],
      ),
    );
  }
}
