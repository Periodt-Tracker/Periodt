import 'dart:math' as math;
import 'observation.dart';
import 'emission_params.dart';
import 'duration_params.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Constants
// ─────────────────────────────────────────────────────────────────────────────
const int nStates = 4;
const int maxDuration = 22;
const double negInf = double.negativeInfinity;

const List<String> stateNames = [
  'Menstruation',
  'Follicular',
  'Ovulatory',
  'Luteal',
];

// ─────────────────────────────────────────────────────────────────────────────
// Math helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Log of the standard normal PDF at x.
double _normLogPdf(double x, double mu, double sigma) {
  final z = (x - mu) / sigma;
  return -0.5 * z * z - math.log(sigma) - 0.9189385332046727; // log(sqrt(2π))
}

/// Standard normal CDF via approximation (Abramowitz & Stegun 26.2.17).
double _normCdf(double x) {
  if (x < -8.0) return 0.0;
  if (x > 8.0) return 1.0;
  const p = 0.2316419;
  const b = [0.319381530, -0.356563782, 1.781477937, -1.821255978, 1.330274429];
  final t = 1.0 / (1.0 + p * x.abs());
  double poly = 0.0;
  double tPow = t;
  for (final bi in b) {
    poly += bi * tPow;
    tPow *= t;
  }
  final pdf = math.exp(-0.5 * x * x) / math.sqrt(2 * math.pi);
  final cdf = 1.0 - pdf * poly;
  return x >= 0 ? cdf : 1.0 - cdf;
}

double _normLogCdf(double x) => math.log(_normCdf(x) + 1e-300);

/// Log-sum-exp of two values (numerically stable).
double _logAddExp(double a, double b) {
  if (a == negInf) return b;
  if (b == negInf) return a;
  if (a > b) return a + math.log(1.0 + math.exp(b - a));
  return b + math.log(1.0 + math.exp(a - b));
}

// ─────────────────────────────────────────────────────────────────────────────
// Duration model
// ─────────────────────────────────────────────────────────────────────────────
double durationLogPmf(int state, int d) {
  final p = durationParams[state]!;
  final mu = p['mu']!;
  final sigma = p['sigma']!;
  final lp = _normLogPdf(d.toDouble(), mu, sigma);
  // Normalisation over {1 .. maxDuration}
  final lZ = math.log(
    _normCdf((maxDuration + 0.5 - mu) / sigma) -
        _normCdf((0.5 - mu) / sigma) +
        1e-300,
  );
  return lp - lZ;
}

// ─────────────────────────────────────────────────────────────────────────────
// Emission model  (all channels optional — missing → 0 contribution)
// ─────────────────────────────────────────────────────────────────────────────
bool _isMissing(double? v) => v == null || v.isNaN;
bool _isMissingInt(int? v) => v == null;

double _gaussianLl(double? v, double mu, double sigma) {
  if (_isMissing(v)) return 0.0;
  return _normLogPdf(v!, mu, sigma);
}

double _bernoulliLl(int? v, double p) {
  if (_isMissingInt(v)) return 0.0;
  return v == 1 ? math.log(p + 1e-9) : math.log(1.0 - p + 1e-9);
}

double _categoricalLl(int? v, List<double> probs) {
  if (_isMissingInt(v)) return 0.0;
  final idx = v!.clamp(0, probs.length - 1);
  return math.log(probs[idx] + 1e-9);
}

/// Log P(obs | state).  Any null field is silently ignored.
double emissionLogProb(int state, CycleObservation obs) {
  final p = emissionParams[state]!;
  double lp = 0.0;

  // Health / device channels
  lp += _gaussianLl(obs.bbt, p.bbtMu, p.bbtSigma);
  lp += _bernoulliLl(obs.lhSurge, p.lhSurgeP);
  lp += _gaussianLl(obs.restingHr, p.restingHrMu, p.restingHrSigma);
  lp += _gaussianLl(obs.hrv, p.hrvMu, p.hrvSigma);
  lp += _gaussianLl(obs.sleepHours, p.sleepHoursMu, p.sleepHoursSigma);

  // User-logged symptoms
  lp += _categoricalLl(obs.bleeding, p.bleedingProbs);
  lp += _categoricalLl(obs.cramps, p.crampsProbs);
  lp += _bernoulliLl(obs.bloating, p.bloatingP);
  lp += _bernoulliLl(obs.breastPain, p.breastPainP);
  lp += _bernoulliLl(obs.headache, p.headacheP);
  lp += _gaussianLl(obs.moodScore, p.moodMu, p.moodSigma);
  lp += _gaussianLl(obs.energyScore, p.energyMu, p.energySigma);
  lp += _categoricalLl(obs.discharge, p.dischargeProbs);

  return lp;
}

double _segmentLogLikelihood(int state, List<CycleObservation> seg) {
  return seg.fold(0.0, (sum, o) => sum + emissionLogProb(state, o));
}

// ─────────────────────────────────────────────────────────────────────────────
// Viterbi decoder
// ─────────────────────────────────────────────────────────────────────────────

/// Decode a sequence of observations into the most probable phase sequence.
/// Returns a list of state indices (0–3) one per day.
/// Handles any pattern of missing data including fully empty observations.
List<int> hsmmViterbi(List<CycleObservation> observations) {
  final T = observations.length;
  if (T == 0) return [];

  // delta[t][s] = best log-prob ending in state s at time t
  final delta = List.generate(T, (_) => List.filled(nStates, negInf));
  // psi[t][s]  = (prevState, duration) backpointer; null = no predecessor
  final psi = List.generate(T, (_) => List<(int?, int)?>.filled(nStates, null));

  // ── Initialisation (cycle starts in state 0: Menstruation) ────────────────
  for (int s = 0; s < nStates; s++) {
    for (int d = 1; d <= math.min(maxDuration, T); d++) {
      final tEnd = d - 1;
      if (tEnd >= T) break;
      final segLl = _segmentLogLikelihood(s, observations.sublist(0, d));
      final durLp = durationLogPmf(s, d);
      final initLp = (s == 0) ? 0.0 : negInf;
      final val = initLp + segLl + durLp;
      if (val > delta[tEnd][s]) {
        delta[tEnd][s] = val;
        psi[tEnd][s] = (null, d);
      }
    }
  }

  // ── Recursion ─────────────────────────────────────────────────────────────
  for (int t = 1; t < T; t++) {
    for (int s = 0; s < nStates; s++) {
      final prevS = (s - 1 + nStates) % nStates; // deterministic predecessor
      for (int d = 1; d <= math.min(maxDuration, t + 1); d++) {
        final tStart = t - d + 1;
        if (tStart < 1) break;
        final prevT = tStart - 1;
        if (delta[prevT][prevS] == negInf) continue;
        final segLl = _segmentLogLikelihood(
          s,
          observations.sublist(tStart, t + 1),
        );
        final durLp = durationLogPmf(s, d);
        final val = delta[prevT][prevS] + segLl + durLp;
        if (val > delta[t][s]) {
          delta[t][s] = val;
          psi[t][s] = (prevS, d);
        }
      }
    }
  }

  // ── Back-tracking ─────────────────────────────────────────────────────────
  final states = List.filled(T, 0);
  var bestS = 0;
  var bestVal = negInf;
  for (int s = 0; s < nStates; s++) {
    if (delta[T - 1][s] > bestVal) {
      bestVal = delta[T - 1][s];
      bestS = s;
    }
  }

  var t = T - 1;
  while (t >= 0) {
    final info = psi[t][bestS];
    if (info == null) {
      for (int tt = 0; tt <= t; tt++) states[tt] = bestS;
      break;
    }
    final (prevS, d) = info;
    for (int tt = t - d + 1; tt <= t; tt++) states[tt] = bestS;
    t -= d;
    if (prevS == null) break;
    bestS = prevS;
  }

  return states;
}

/// Convenience: decode and return human-readable phase names.
List<String> decodePhaseNames(List<CycleObservation> observations) {
  return hsmmViterbi(observations).map((s) => stateNames[s]).toList();
}
