import 'dart:math';

import 'package:periodt/core/database/database.dart';
import 'package:periodt/core/forcast/backend/base.dart';
import 'package:periodt/core/utilities/range.dart';

class SimpleForecastBackend implements ForecastBackend {
  static const int _lutealPhaseLength = 14;
  static const int _ovulationWindowHalf = 1; // ±1 day around ovulation center

  @override
  Future<Forecast> forecast(ForecastData data, ForecastOptions options) async {
    final sortedPeriods = List<Period>.from(data.periods)
      ..sort((a, b) => a.startDate.compareTo(b.startDate));

    final avgCycleLength = _avgRange(data.cycleLength);
    final avgPeriodLength = _avgRange(data.periodLength);
    final today = _dateOnly(DateTime.now());

    // ── 1. Find the start of the cycle that contains today ──────────────────
    final currentCycleStart = _findCurrentCycleStart(
      sortedPeriods: sortedPeriods,
      avgCycleLength: avgCycleLength,
      today: today,
    );

    // ── 2. Build ordered list of all cycle start dates ───────────────────────
    final cycleStartDates = _buildCycleStartDates(
      currentCycleStart: currentCycleStart,
      sortedPeriods: sortedPeriods,
      n: options.cycles,
      avgCycleLength: avgCycleLength,
    );

    // ── 3. Generate days for each cycle ─────────────────────────────────────
    final List<ForecastCycle> forecastCycles = [];
    final List<ForecastDay> allDays = [];

    for (int c = 0; c < cycleStartDates.length; c++) {
      final cycleStart = cycleStartDates[c];

      // Cycle length = gap to the next known start, or fall back to average.
      final thisCycleLength = c < cycleStartDates.length - 1
          ? cycleStartDates[c + 1].difference(cycleStart).inDays
          : avgCycleLength;

      // Period length = from actual data if this start matches a real period.
      final thisPeriodLength = _actualPeriodLength(
        cycleStart: cycleStart,
        sortedPeriods: sortedPeriods,
        fallback: avgPeriodLength,
      );

      final List<ForecastDay> cycleDays = [];

      for (int d = 0; d < thisCycleLength; d++) {
        final date = cycleStart.add(Duration(days: d));
        final dayOfCycle = d + 1; // 1-indexed

        final probabilities = _computeProbabilities(
          dayOfCycle: dayOfCycle,
          cycleLength: thisCycleLength,
          periodLength: thisPeriodLength,
          cycleLengthRange: data.cycleLength,
          periodLengthRange: data.periodLength,
        );

        final dominant = probabilities.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key;

        final forecastDay = ForecastDay(
          date: date,
          phase: dominant,
          probabilities: probabilities,
        );

        cycleDays.add(forecastDay);
        allDays.add(forecastDay);
      }

      forecastCycles.add(ForecastCycle(days: cycleDays));
    }

    return Forecast(days: allDays, cycles: forecastCycles);
  }

  // ── Cycle anchor helpers ───────────────────────────────────────────────────

  /// Walks forward from the most recent known period to find the cycle that
  /// contains [today]. Falls back to [today] when there is no history.
  DateTime _findCurrentCycleStart({
    required List<Period> sortedPeriods,
    required int avgCycleLength,
    required DateTime today,
  }) {
    if (sortedPeriods.isEmpty) return today;

    var anchor = _dateOnly(sortedPeriods.last.startDate);

    // Advance until the *next* projected start would be after today.
    while (!anchor.add(Duration(days: avgCycleLength)).isAfter(today)) {
      anchor = anchor.add(Duration(days: avgCycleLength));
    }

    return anchor;
  }

  /// Produces [2n + 1] sorted cycle start dates centred on [currentCycleStart].
  /// Backward cycles snap to a real period start when one is close enough
  /// (within half a cycle length), so the forecast is anchored to history.
  List<DateTime> _buildCycleStartDates({
    required DateTime currentCycleStart,
    required List<Period> sortedPeriods,
    required int n,
    required int avgCycleLength,
  }) {
    final starts = <DateTime>[];

    for (int i = n; i >= 1; i--) {
      final estimated = currentCycleStart.subtract(
        Duration(days: avgCycleLength * i),
      );
      starts.add(
        _snapToPeriod(
          estimated: estimated,
          periods: sortedPeriods,
          windowDays: avgCycleLength ~/ 2,
        ),
      );
    }

    starts.add(currentCycleStart);

    for (int i = 1; i <= n; i++) {
      starts.add(currentCycleStart.add(Duration(days: avgCycleLength * i)));
    }

    // Ensure no duplicates (can arise when snapping several estimates to the
    // same real period) and that everything is in chronological order.
    return (starts.toSet().toList()..sort());
  }

  /// Returns [estimated] if no real period falls within [windowDays], otherwise
  /// returns the start date of the nearest real period.
  DateTime _snapToPeriod({
    required DateTime estimated,
    required List<Period> periods,
    required int windowDays,
  }) {
    DateTime? best;
    int bestDiff = windowDays + 1; // one beyond the window – will not match

    for (final period in periods) {
      final start = _dateOnly(period.startDate);
      final diff = start.difference(estimated).inDays.abs();
      if (diff < bestDiff) {
        bestDiff = diff;
        best = start;
      }
    }

    return best ?? estimated;
  }

  /// Returns the recorded period length if [cycleStart] coincides with a real
  /// period, otherwise [fallback].
  int _actualPeriodLength({
    required DateTime cycleStart,
    required List<Period> sortedPeriods,
    required int fallback,
  }) {
    for (final period in sortedPeriods) {
      if (_dateOnly(period.startDate) == cycleStart) {
        return _dateOnly(
              period.endDate,
            ).difference(_dateOnly(period.startDate)).inDays +
            1;
      }
    }
    return fallback;
  }

  // ── Phase probability model ────────────────────────────────────────────────

  /// Assigns a smooth probability to each [CyclePhase] for a given day.
  ///
  /// Phase layout (1-indexed days):
  ///   Period      : 1 … periodLength
  ///   Follicular  : periodLength+1 … ovulationDay-2
  ///   Ovulation   : ovulationDay-1 … ovulationDay+1  (3-day window)
  ///   Luteal      : ovulationDay+2 … cycleLength
  ///
  /// The spread of [cycleLengthRange] and [periodLengthRange] is used as the
  /// half-width of the transition zones so that tighter ranges → sharper
  /// boundaries and wider ranges → softer, more blended transitions.
  Map<CyclePhase, int> _computeProbabilities({
    required int dayOfCycle,
    required int cycleLength,
    required int periodLength,
    required Range<int> cycleLengthRange,
    required Range<int> periodLengthRange,
  }) {
    // Ovulation is offset backwards from the end of the cycle by the (fairly
    // stable) luteal phase length.
    final ovulationDay = (cycleLength - _lutealPhaseLength).clamp(
      periodLength + 2,
      cycleLength - 2,
    );

    // Transition-zone half-widths derived from the recorded ranges.
    final periodSigma =
        ((periodLengthRange.upper - periodLengthRange.lower) / 2.0).clamp(
          0.5,
          4.0,
        );
    final cycleSigma = ((cycleLengthRange.upper - cycleLengthRange.lower) / 4.0)
        .clamp(0.5, 4.0);

    final d = dayOfCycle.toDouble();

    // ── Period ────────────────────────────────────────────────────────────────
    // High near day 1, fades to 0 around periodLength.
    final double periodFrac = _smoothstep(
      d,
      periodLength - periodSigma,
      periodLength + periodSigma,
      inverted: true,
    );

    // ── Ovulation ─────────────────────────────────────────────────────────────
    // Bell peak at ovulationDay, width driven by cycle uncertainty.
    final double ovulationFrac = _bell(
      d,
      ovulationDay.toDouble(),
      _ovulationWindowHalf + cycleSigma / 2,
    );

    // ── Luteal ────────────────────────────────────────────────────────────────
    // Rises after the ovulation window, cannot overlap with period.
    final double lutealFrac =
        _smoothstep(
          d,
          ovulationDay + _ovulationWindowHalf - cycleSigma / 2,
          ovulationDay + _ovulationWindowHalf + cycleSigma / 2,
        ) *
        (1.0 - periodFrac);

    // ── Follicular ────────────────────────────────────────────────────────────
    // Everything left between period end and ovulation/luteal onset.
    final double follicularFrac =
        (1.0 - periodFrac) * (1.0 - ovulationFrac) * (1.0 - lutealFrac);

    final total = periodFrac + follicularFrac + ovulationFrac + lutealFrac;

    if (total == 0) {
      return {
        CyclePhase.period: 0,
        CyclePhase.follicular: 100,
        CyclePhase.ovulation: 0,
        CyclePhase.luteal: 0,
      };
    }

    return _toPercentMap({
      CyclePhase.period: periodFrac / total,
      CyclePhase.follicular: follicularFrac / total,
      CyclePhase.ovulation: ovulationFrac / total,
      CyclePhase.luteal: lutealFrac / total,
    });
  }

  // ── Maths helpers ──────────────────────────────────────────────────────────

  /// Smooth-step from 0→1 across [edge0, edge1].
  /// When [inverted] is true the direction is reversed (1→0).
  double _smoothstep(
    double x,
    double edge0,
    double edge1, {
    bool inverted = false,
  }) {
    if (edge0 >= edge1) {
      final step = x >= edge0 ? 1.0 : 0.0;
      return inverted ? 1.0 - step : step;
    }
    final t = ((x - edge0) / (edge1 - edge0)).clamp(0.0, 1.0);
    final smooth = t * t * (3.0 - 2.0 * t);
    return inverted ? 1.0 - smooth : smooth;
  }

  /// Gaussian bell curve (max = 1 at [center]) with standard deviation [sigma].
  double _bell(double x, double center, double sigma) {
    if (sigma <= 0) return x == center ? 1.0 : 0.0;
    final diff = x - center;
    return exp(-(diff * diff) / (2.0 * sigma * sigma));
  }

  /// Converts a map of [0, 1] weights to integer percentages that sum to 100
  /// using largest-remainder rounding.
  Map<CyclePhase, int> _toPercentMap(Map<CyclePhase, double> raw) {
    final phases = raw.keys.toList();
    final floors = phases.map((p) => (raw[p]! * 100).floor()).toList();
    final remainders = phases
        .map((p) => (raw[p]! * 100) - (raw[p]! * 100).floor())
        .toList();

    int leftover = 100 - floors.reduce((a, b) => a + b);

    // Distribute leftover points to entries with the largest fractional parts.
    final order = List<int>.generate(phases.length, (i) => i)
      ..sort((a, b) => remainders[b].compareTo(remainders[a]));

    for (int i = 0; i < leftover; i++) {
      floors[order[i]]++;
    }

    return {for (int i = 0; i < phases.length; i++) phases[i]: floors[i]};
  }

  int _avgRange(Range<int> r) => ((r.lower + r.upper) / 2).round();

  DateTime _dateOnly(DateTime dt) => DateTime(dt.year, dt.month, dt.day);
}
