import 'dart:math' as math;
import 'hsmm_model.dart';
import 'observation.dart';
import 'emission_params.dart';
import 'duration_params.dart';
import 'cycle_models.dart';

export 'cycle_models.dart';
export 'observation.dart';
export 'hsmm_model.dart' show stateNames, nStates;

int _sampleDuration(int state, math.Random rng) {
  final p = durationParams[state]!;

  final mu = p['mu']!;
  final sigma = p['sigma']!;

  final u1 = rng.nextDouble();
  final u2 = rng.nextDouble();

  final z =
      math.sqrt(-2.0 * math.log(u1 + 1e-300)) * math.cos(2.0 * math.pi * u2);

  return (mu + sigma * z).round().clamp(1, maxDuration);
}

double _logSumExp(List<double> xs) {
  final maxX = xs.reduce(math.max);

  if (maxX == double.negativeInfinity) {
    return double.negativeInfinity;
  }

  double sum = 0;

  for (final x in xs) {
    sum += math.exp(x - maxX);
  }

  return maxX + math.log(sum);
}

List<List<double>> _hsmmForward(List<CycleObservation> observations) {
  final T = observations.length;
  final alpha = List.generate(
    T,
    (_) => List.filled(nStates, double.negativeInfinity),
  );

  for (int s = 0; s < nStates; s++) {
    for (int d = 1; d <= math.min(maxDuration, T); d++) {
      final tEnd = d - 1;
      if (tEnd >= T) break;
      double segLl = 0;
      for (int i = 0; i < d; i++) segLl += emissionLogProb(s, observations[i]);
      final val =
          (s == 0 ? 0.0 : double.negativeInfinity) +
          segLl +
          durationLogPmf(s, d);
      if (val > alpha[tEnd][s]) alpha[tEnd][s] = val;
    }
  }

  for (int t = 1; t < T; t++) {
    for (int s = 0; s < nStates; s++) {
      final prevS = (s - 1 + nStates) % nStates;
      final candidates = <double>[];
      for (int d = 1; d <= math.min(maxDuration, t + 1); d++) {
        final tStart = t - d + 1;
        if (tStart < 1) break;
        final prevT = tStart - 1;
        if (alpha[prevT][prevS] == double.negativeInfinity) continue;
        double segLl = 0;
        for (int i = tStart; i <= t; i++) {
          segLl += emissionLogProb(s, observations[i]);
        }
        candidates.add(alpha[prevT][prevS] + segLl + durationLogPmf(s, d));
      }
      if (candidates.isNotEmpty) alpha[t][s] = _logSumExp(candidates);
    }
  }
  return alpha;
}

List<List<double>> _hsmmBackward(List<CycleObservation> observations) {
  final T = observations.length;

  final beta = List.generate(
    T,
    (_) => List.filled(nStates, double.negativeInfinity),
  );

  for (int s = 0; s < nStates; s++) {
    beta[T - 1][s] = 0.0;
  }

  for (int t = T - 2; t >= 0; t--) {
    for (int s = 0; s < nStates; s++) {
      final nextS = (s + 1) % nStates;
      final candidates = <double>[];

      for (int d = 1; d <= math.min(maxDuration, T - t - 1); d++) {
        final tEnd = t + d;
        if (tEnd >= T) break;
        if (beta[tEnd][nextS] == double.negativeInfinity) continue;
        double segLl = 0;

        for (int i = t + 1; i <= tEnd; i++) {
          segLl += emissionLogProb(nextS, observations[i]);
        }

        candidates.add(segLl + durationLogPmf(nextS, d) + beta[tEnd][nextS]);
      }

      if (candidates.isNotEmpty) beta[t][s] = _logSumExp(candidates);
    }
  }
  return beta;
}

List<List<double>> _posteriors(List<CycleObservation> observations) {
  final alpha = _hsmmForward(observations);
  final beta = _hsmmBackward(observations);
  final T = observations.length;
  final gamma = List.generate(T, (_) => List.filled(nStates, 0.0));

  for (int t = 0; t < T; t++) {
    final logZ = _logSumExp(
      List.generate(nStates, (s) => alpha[t][s] + beta[t][s]),
    );
    double rowSum = 0;
    for (int s = 0; s < nStates; s++) {
      final lp = alpha[t][s] + beta[t][s] - logZ;
      gamma[t][s] = (lp > -50) ? math.exp(lp) : 0.0;
      rowSum += gamma[t][s];
    }
    if (rowSum > 0) {
      for (int s = 0; s < nStates; s++) gamma[t][s] /= rowSum;
    }
  }
  return gamma;
}

ForecastDayExpectation _buildExpectation(
  int dayOffset,
  List<double> phaseProbs,
) {
  final dominant = phaseProbs
      .asMap()
      .entries
      .reduce((a, b) => a.value >= b.value ? a : b)
      .key;

  double bbt = 0, lhP = 0, hr = 0, hrv = 0, sleep = 0;
  double bleeding = 0, cramps = 0, bloating = 0, breastPain = 0;
  double headache = 0, mood = 0, energy = 0, discharge = 0;

  for (int k = 0; k < nStates; k++) {
    final w = phaseProbs[k];
    final p = emissionParams[k]!;
    bbt += w * p.bbtMu;
    lhP += w * p.lhSurgeP;
    hr += w * p.restingHrMu;
    hrv += w * p.hrvMu;
    sleep += w * p.sleepHoursMu;
    bloating += w * p.bloatingP;
    breastPain += w * p.breastPainP;
    headache += w * p.headacheP;
    mood += w * p.moodMu;
    energy += w * p.energyMu;

    double bleedExp = 0;
    for (int i = 0; i < p.bleedingProbs.length; i++) {
      bleedExp += i * p.bleedingProbs[i];
    }
    bleeding += w * bleedExp;

    double crampExp = 0;
    for (int i = 0; i < p.crampsProbs.length; i++) {
      crampExp += i * p.crampsProbs[i];
    }
    cramps += w * crampExp;

    double discExp = 0;
    for (int i = 0; i < p.dischargeProbs.length; i++) {
      discExp += i * p.dischargeProbs[i];
    }
    discharge += w * discExp;
  }

  return ForecastDayExpectation(
    dayOffset: dayOffset,
    dominantStateIndex: dominant,
    dominantPhaseName: stateNames[dominant],
    phaseProbs: List.unmodifiable(phaseProbs),
    expectedBbt: bbt,
    expectedLhSurgeProb: lhP,
    expectedRestingHr: hr,
    expectedHrv: hrv,
    expectedSleepHours: sleep,
    expectedBleeding: bleeding,
    expectedCramps: cramps,
    expectedBloatingProb: bloating,
    expectedBreastPainProb: breastPain,
    expectedHeadacheProb: headache,
    expectedMoodScore: mood,
    expectedEnergyScore: energy,
    expectedDischarge: discharge,
  );
}

int _percentile(List<int> sorted, double p) {
  if (sorted.isEmpty) return 0;
  final idx = ((p / 100) * (sorted.length - 1)).round();
  return sorted[idx.clamp(0, sorted.length - 1)];
}

DatePrediction _makeCi(List<int> rawSamples, int horizon) {
  final valid = rawSamples.where((v) => v <= horizon).toList()..sort();
  if (valid.isEmpty) {
    return DatePrediction(
      medianDays: horizon,
      p5Days: horizon,
      p95Days: horizon,
      coverage: 0.0,
    );
  }
  return DatePrediction(
    medianDays: _percentile(valid, 50),
    p5Days: _percentile(valid, 5),
    p95Days: _percentile(valid, 95),
    coverage: valid.length / rawSamples.length,
  );
}

/// Runs the full HSMM pipeline.
///
/// This class is intentionally stateless — it is instantiated fresh each time
/// (typically inside an Isolate) and returns immutable Freezed models.
class CycleForecastService {
  const CycleForecastService();

  /// Full pipeline: decode history + Monte-Carlo forecast.
  ///
  /// Safe to call from [Isolate.run] — all inputs/outputs are serialisable.
  CycleForecastResult run({
    required List<CycleObservation> observations,
    int horizon = 90,
    int nSamples = 1000,
    int seed = 42,
  }) {
    if (observations.isEmpty) return _emptyResult(horizon, nSamples);

    // ── 1. Viterbi MAP decode ─────────────────────────────────────────────────
    final mapStates = hsmmViterbi(observations);

    // ── 2. Forward-backward posteriors ───────────────────────────────────────
    final gamma = _posteriors(observations);

    // ── 3. Build history objects ──────────────────────────────────────────────
    final history = List.generate(observations.length, (i) {
      final s = mapStates[i];
      return HistoricalDayPhase(
        dayIndex: i,
        stateIndex: s,
        phaseName: stateNames[s],
        posteriorProbs: List.unmodifiable(gamma[i]),
      );
    });

    // ── 4. Current phase + days into it ──────────────────────────────────────
    final currentState = mapStates.last;
    int daysInto = 1;
    for (int i = mapStates.length - 2; i >= 0; i--) {
      if (mapStates[i] == currentState)
        daysInto++;
      else
        break;
    }
    final durP = durationParams[currentState]!;
    final daysRemaining = math.max(1.0, durP['mu']! - daysInto);

    // ── 5. Monte-Carlo future simulation ─────────────────────────────────────
    final rng = math.Random(seed);
    final phaseMatrix = List.generate(nSamples, (_) => List.filled(horizon, 0));
    final periodSamples = List.filled(nSamples, horizon + 1);
    final ovulationSamples = List.filled(nSamples, horizon + 1);
    final cycleLengths = List.filled(nSamples, 0);

    for (int si = 0; si < nSamples; si++) {
      int day = 0;
      int state = currentState;
      int remaining = math.max(1, _sampleDuration(state, rng) - daysInto);

      bool seenPeriod = (state == 0);
      bool seenOvulation = (state == 2);
      int? cycleStart;
      bool cycleRecorded = false;

      while (day < horizon) {
        final fillEnd = math.min(day + remaining, horizon);
        for (int d = day; d < fillEnd; d++) phaseMatrix[si][d] = state;

        if (state == 0 && !seenPeriod) {
          periodSamples[si] = day;
          seenPeriod = true;
          cycleStart ??= day;
        }
        if (state == 2 && !seenOvulation) {
          ovulationSamples[si] = day;
          seenOvulation = true;
        }
        if (state == 0 && cycleStart != null && !cycleRecorded && day > 0) {
          cycleLengths[si] = day - cycleStart!;
          cycleRecorded = true;
        }

        day += remaining;
        state = (state + 1) % nStates;
        remaining = _sampleDuration(state, rng);
      }

      if (cycleLengths[si] == 0) {
        cycleLengths[si] = durationParams.values
            .fold(0.0, (s, p) => s + p['mu']!)
            .round();
      }
    }

    // ── 6. Phase probability matrix ───────────────────────────────────────────
    final phaseProbs = List.generate(horizon, (_) => List.filled(nStates, 0.0));
    for (int d = 0; d < horizon; d++) {
      for (int si = 0; si < nSamples; si++) {
        phaseProbs[d][phaseMatrix[si][d]]++;
      }
      for (int k = 0; k < nStates; k++) phaseProbs[d][k] /= nSamples;
    }

    // ── 7. Per-day forecast expectations ─────────────────────────────────────
    final forecastDays = List.generate(
      horizon,
      (d) => _buildExpectation(d + 1, phaseProbs[d]),
    );

    // ── 8. Credible intervals ─────────────────────────────────────────────────
    final plausibleCycles =
        cycleLengths.where((v) => v >= 15 && v <= 50).toList()..sort();
    final cycleCI = plausibleCycles.isEmpty
        ? const DatePrediction(
            medianDays: 28,
            p5Days: 24,
            p95Days: 35,
            coverage: 0,
          )
        : DatePrediction(
            medianDays: _percentile(plausibleCycles, 50),
            p5Days: _percentile(plausibleCycles, 5),
            p95Days: _percentile(plausibleCycles, 95),
            coverage: plausibleCycles.length / nSamples,
          );

    return CycleForecastResult(
      history: history,
      daysIntoCurrentPhase: daysInto,
      daysRemainingInPhase: daysRemaining,
      forecast: forecastDays,
      nextPeriod: _makeCi(periodSamples, horizon),
      nextOvulation: _makeCi(ovulationSamples, horizon),
      nextCycleLength: cycleCI,
      nSamples: nSamples,
      horizon: horizon,
    );
  }

  /// Decode history only — no MC sampling. Cheaper when forecast not needed.
  List<HistoricalDayPhase> decodeHistory(List<CycleObservation> observations) {
    if (observations.isEmpty) return [];
    final mapStates = hsmmViterbi(observations);
    final gamma = _posteriors(observations);
    return List.generate(observations.length, (i) {
      final s = mapStates[i];
      return HistoricalDayPhase(
        dayIndex: i,
        stateIndex: s,
        phaseName: stateNames[s],
        posteriorProbs: List.unmodifiable(gamma[i]),
      );
    });
  }

  CycleForecastResult _emptyResult(int horizon, int nSamples) {
    final flat = List.filled(nStates, 1.0 / nStates);
    return CycleForecastResult(
      history: [],
      daysIntoCurrentPhase: 0,
      daysRemainingInPhase: 0.0,
      forecast: List.generate(horizon, (d) => _buildExpectation(d + 1, flat)),
      nextPeriod: const DatePrediction(
        medianDays: 14,
        p5Days: 10,
        p95Days: 20,
        coverage: 0,
      ),
      nextOvulation: const DatePrediction(
        medianDays: 7,
        p5Days: 4,
        p95Days: 12,
        coverage: 0,
      ),
      nextCycleLength: const DatePrediction(
        medianDays: 28,
        p5Days: 24,
        p95Days: 35,
        coverage: 0,
      ),
      nSamples: nSamples,
      horizon: horizon,
    );
  }
}
