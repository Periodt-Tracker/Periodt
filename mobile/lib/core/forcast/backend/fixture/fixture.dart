import 'package:flutter/material.dart';
import 'package:periodt/core/forcast/backend/base.dart';

@immutable
class FixtureForecastBackend implements ForecastBackend {
  @override
  Future<Forecast> forecast(ForecastData data, ForecastOptions options) async {
    await Future.delayed(const Duration(seconds: 1));

    return _buildFixtureForecast();
  }

  ForecastCycle _buildCycle({
    required DateTime start,
    required int cycleLength,
    required int periodLength,
  }) {
    final days = <ForecastDay>[];

    for (int i = 0; i < cycleLength; i++) {
      final date = start.add(Duration(days: i));

      late CyclePhase phase;

      if (i < periodLength) {
        phase = CyclePhase.period;
      } else if (i < cycleLength * 0.5) {
        phase = CyclePhase.follicular;
      } else if (i < cycleLength * 0.6) {
        phase = CyclePhase.ovulation;
      } else {
        phase = CyclePhase.luteal;
      }

      days.add(
        ForecastDay(
          date: date,
          phase: phase,
          probabilities: {
            CyclePhase.period: phase == CyclePhase.period ? 90 : 5,
            CyclePhase.follicular: phase == CyclePhase.follicular ? 80 : 10,
            CyclePhase.ovulation: phase == CyclePhase.ovulation ? 70 : 10,
            CyclePhase.luteal: phase == CyclePhase.luteal ? 85 : 10,
          },
        ),
      );
    }

    return ForecastCycle(days: days);
  }

  Forecast _buildFixtureForecast() {
    final cycleLength = 28;
    final periodLength = 5;

    final start = DateTime.now();

    final cycle1 = _buildCycle(
      start: start,
      cycleLength: cycleLength,
      periodLength: periodLength,
    );

    final cycle2 = _buildCycle(
      start: cycle1.endDate.add(const Duration(days: 1)),
      cycleLength: cycleLength,
      periodLength: periodLength,
    );

    final cycle3 = _buildCycle(
      start: cycle2.endDate.add(const Duration(days: 1)),
      cycleLength: cycleLength,
      periodLength: periodLength,
    );

    final allDays = [...cycle1.days, ...cycle2.days, ...cycle3.days];

    return Forecast(days: allDays, cycles: [cycle1, cycle2, cycle3]);
  }
}
