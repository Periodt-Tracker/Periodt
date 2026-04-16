import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:periodt/core/forcast/backend/hsmm/observation.dart';

part 'cycle_models.freezed.dart';
part 'cycle_models.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Phase estimate for a single historical day
// ─────────────────────────────────────────────────────────────────────────────

@freezed
abstract class HistoricalDayPhase with _$HistoricalDayPhase {
  const HistoricalDayPhase._();

  const factory HistoricalDayPhase({
    /// 0-based index into the observation list.
    required int dayIndex,

    /// Most probable phase index 0–3 (Viterbi MAP).
    required int stateIndex,

    /// Human-readable phase name.
    required String phaseName,

    /// Marginal posterior P(phase | all obs) — one per state, sums to 1.
    required List<double> posteriorProbs,
  }) = _HistoricalDayPhase;

  factory HistoricalDayPhase.fromJson(Map<String, dynamic> json) =>
      _$HistoricalDayPhaseFromJson(json);

  /// Confidence in the MAP label (0–1).
  double get confidence => posteriorProbs[stateIndex];
}

// ─────────────────────────────────────────────────────────────────────────────
// Expected observations for a single forecast day
// ─────────────────────────────────────────────────────────────────────────────

@freezed
abstract class ForecastDayExpectation with _$ForecastDayExpectation {
  const ForecastDayExpectation._();

  const factory ForecastDayExpectation({
    /// Day offset from today (1 = tomorrow).
    required int dayOffset,

    /// Dominant phase index (argmax of phaseProbs).
    required int dominantStateIndex,
    required String dominantPhaseName,

    /// P(phase k) for k ∈ {0,1,2,3}.
    required List<double> phaseProbs,

    // ── Expected channel values ─────────────────────────────────────────────
    required double expectedBbt,
    required double expectedLhSurgeProb,
    required double expectedRestingHr,
    required double expectedHrv,
    required double expectedSleepHours,
    required double expectedBleeding,
    required double expectedCramps,
    required double expectedBloatingProb,
    required double expectedBreastPainProb,
    required double expectedHeadacheProb,
    required double expectedMoodScore,
    required double expectedEnergyScore,
    required double expectedDischarge,
  }) = _ForecastDayExpectation;

  factory ForecastDayExpectation.fromJson(Map<String, dynamic> json) =>
      _$ForecastDayExpectationFromJson(json);
}

// ─────────────────────────────────────────────────────────────────────────────
// A key-date prediction with a credible interval
// ─────────────────────────────────────────────────────────────────────────────

@freezed
abstract class DatePrediction with _$DatePrediction {
  const DatePrediction._();

  const factory DatePrediction({
    /// Median day offset from today.
    required int medianDays,

    /// 5th-percentile (lower 90% CI bound).
    required int p5Days,

    /// 95th-percentile (upper 90% CI bound).
    required int p95Days,

    /// Fraction of MC samples that landed within the horizon.
    required double coverage,
  }) = _DatePrediction;

  factory DatePrediction.fromJson(Map<String, dynamic> json) =>
      _$DatePredictionFromJson(json);

  @override
  String toString() => 'Day +$medianDays (90% CI: +$p5Days → +$p95Days)';
}

// ─────────────────────────────────────────────────────────────────────────────
// Full forecast result
// ─────────────────────────────────────────────────────────────────────────────

@freezed
abstract class CycleForecastResult with _$CycleForecastResult {
  const CycleForecastResult._();

  const factory CycleForecastResult({
    /// Per-day decoded phases for every historical observation.
    required List<HistoricalDayPhase> history,

    /// How many consecutive days the current phase has been active.
    required int daysIntoCurrentPhase,

    /// Point estimate of days remaining in the current phase.
    required double daysRemainingInPhase,

    /// Per-day expectations for [horizon] days ahead.
    required List<ForecastDayExpectation> forecast,

    required DatePrediction nextPeriod,
    required DatePrediction nextOvulation,
    required DatePrediction nextCycleLength,

    required int nSamples,
    required int horizon,
  }) = _CycleForecastResult;

  factory CycleForecastResult.fromJson(Map<String, dynamic> json) =>
      _$CycleForecastResultFromJson(json);

  /// Current phase — last historical day.
  HistoricalDayPhase get currentPhase => history.last;
}

// ─────────────────────────────────────────────────────────────────────────────
// UI state — wraps AsyncValue loading / error / data lifecycle
// ─────────────────────────────────────────────────────────────────────────────

/// The complete app state held by the cycle notifier.
@freezed
abstract class CycleState with _$CycleState {
  const factory CycleState({
    /// All stored observations, oldest first.
    @Default([]) List<CycleObservation> observations,

    /// Latest model output — null while first run is pending.
    CycleForecastResult? result,

    /// True while the model is running.
    @Default(false) bool isComputing,

    /// Non-null if the last compute attempt threw.
    String? errorMessage,

    /// Which forecast day is selected in the Forecast tab.
    @Default(0) int selectedForecastDay,
  }) = _CycleState;
}
