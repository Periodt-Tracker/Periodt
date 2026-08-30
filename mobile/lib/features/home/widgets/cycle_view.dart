import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:periodt/core/forcast/backend/base.dart';
import 'package:periodt/features/home/widgets/period_tracker.dart';
import 'package:periodt/features/home/widgets/timeline.dart';
import 'package:periodt/features/home/widgets/wheel.dart';

class AngleNotifier extends ValueNotifier<double> {
  AngleNotifier(super.value);

  void updateAngle(double newAngle) {
    value = newAngle;
    notifyListeners();
  }
}

// we'll track each cycle as 2pi, where each cycle may be a slightly different
// length we'll need to adjust the angle of each day but the change in movement
// per day will be negligible especially between seperate swipes
//
class CycleView extends HookConsumerWidget {
  final Forecast forecast;

  const CycleView({super.key, required this.forecast});

  bool isSameDate(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  int get cycleCount => forecast.cycles.length;

  // Pure functions - put these outside your widget or in a helper class

  double calculateAngleFromOffset(
    double offset,
    List<ForecastCycle> cycles,
    double dayWidth,
  ) {
    double days = offset / dayWidth;
    double newAngle = 0.0;

    for (final cycle in cycles) {
      if (days >= cycle.days.length) {
        newAngle += 2 * pi;
        days -= cycle.days.length;
      } else {
        newAngle += (days / cycle.days.length) * 2 * pi;
        break;
      }
    }
    return newAngle.clamp(0.0, 2 * pi * cycles.length);
  }

  double calculateOffsetFromAngle(
    double angle,
    List<ForecastCycle> cycles,
    double dayWidth,
  ) {
    final maxAngle = 2 * pi * cycles.length;
    final clamped = angle.clamp(0.0, maxAngle);

    final cycleIndex = (clamped ~/ (2 * pi)).clamp(0, cycles.length - 1);
    final daysBefore = cycles
        .take(cycleIndex)
        .fold<double>(0, (sum, cycle) => sum + cycle.days.length);

    final progress = (clamped % (2 * pi)) / (2 * pi);
    final currentCycle = cycles[cycleIndex];

    return (daysBefore + progress * currentCycle.days.length) * dayWidth;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final index = forecast.days.indexWhere((day) => isSameDate(day.date, now));

    final initialOffset = index * dayWidth;
    final timelineController = useScrollController(
      initialScrollOffset: initialOffset,
    );

    void handleWheelChange(double angle) {
      final targetOffset = calculateOffsetFromAngle(
        angle,
        forecast.cycles,
        dayWidth,
      );

      timelineController.jumpTo(targetOffset);
    }

    return Column(
      spacing: 32,
      children: [
        ListenableBuilder(
          listenable: timelineController,
          builder: (context, _) {
            // Derive the angle directly from the scroll offset.
            // Fallback to initialOffset if the controller hasn't attached to the view yet.
            final currentOffset = timelineController.hasClients
                ? timelineController.offset
                : initialOffset;

            final currentAngle = calculateAngleFromOffset(
              currentOffset,
              forecast.cycles,
              dayWidth,
            );

            return CycleWheel(
              cycles: forecast.cycles,
              rotation: currentAngle,
              onRotationChanged: handleWheelChange,
            );
          },
        ),
        // PeriodTracker(currentDay: index, controller: timelineController),
        CycleTimeline(days: forecast.days, controller: timelineController),
      ],
    );
  }
}
