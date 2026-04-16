import 'package:periodt/core/database/database.dart';
import 'package:periodt/core/database/models/daily-log.dart';
import 'package:periodt/core/utilities/range.dart';

class ForecastData {
  final List<Period> periods;
  final List<FullDailyLog> logs;
  final Range<int> cycleLength;
  final Range<int> periodLength;

  ForecastData({
    required this.periods,
    required this.logs,
    required this.cycleLength,
    required this.periodLength,
  });
}

class ForecastOptions {
  final int cycles;

  ForecastOptions({required this.cycles});
}

enum CyclePhase { period, follicular, ovulation, luteal }

class ForecastDay {
  final DateTime date;
  final CyclePhase phase;
  final Map<CyclePhase, int> probabilities;

  ForecastDay({
    required this.date,
    required this.phase,
    required this.probabilities,
  });
}

class ForecastCycle {
  final List<ForecastDay> days;

  DateTime get startDate => days.first.date;
  DateTime get endDate => days.last.date;

  ForecastCycle({required this.days});
}

class Forecast {
  final List<ForecastDay> days;
  final List<ForecastCycle> cycles;

  DateTime get startDate => days.first.date;
  DateTime get endDate => days.last.date;

  Forecast({required this.days, required this.cycles});
}

abstract interface class ForecastBackend {
  Future<Forecast> forecast(ForecastData data, ForecastOptions options);
}
