import 'package:periodt/core/forcast/backend/base.dart';

ForecastCycle buildCycle({
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

Forecast buildFixtureForecast() {
  final cycleLength = 28;
  final periodLength = 5;

  final start = DateTime.now();

  final cycle1 = buildCycle(
    start: start,
    cycleLength: cycleLength,
    periodLength: periodLength,
  );

  final cycle2 = buildCycle(
    start: cycle1.endDate.add(const Duration(days: 1)),
    cycleLength: cycleLength,
    periodLength: periodLength,
  );

  final cycle3 = buildCycle(
    start: cycle2.endDate.add(const Duration(days: 1)),
    cycleLength: cycleLength,
    periodLength: periodLength,
  );

  final allDays = [...cycle1.days, ...cycle2.days, ...cycle3.days];

  return Forecast(days: allDays, cycles: [cycle1, cycle2, cycle3]);
}
