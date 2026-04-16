/// Emission parameters for a single cycle phase.
class PhaseEmissionParams {
  // Health channels
  final double bbtMu;
  final double bbtSigma;
  final double lhSurgeP;
  final double restingHrMu;
  final double restingHrSigma;
  final double hrvMu;
  final double hrvSigma;
  final double sleepHoursMu;
  final double sleepHoursSigma;

  // Symptom channels
  final List<double> bleedingProbs; // length 5, indices 0–4
  final List<double> crampsProbs; // length 4, indices 0–3
  final double bloatingP;
  final double breastPainP;
  final double headacheP;
  final double moodMu;
  final double moodSigma;
  final double energyMu;
  final double energySigma;
  final List<double> dischargeProbs; // length 4, indices 0–3

  const PhaseEmissionParams({
    required this.bbtMu,
    required this.bbtSigma,
    required this.lhSurgeP,
    required this.restingHrMu,
    required this.restingHrSigma,
    required this.hrvMu,
    required this.hrvSigma,
    required this.sleepHoursMu,
    required this.sleepHoursSigma,
    required this.bleedingProbs,
    required this.crampsProbs,
    required this.bloatingP,
    required this.breastPainP,
    required this.headacheP,
    required this.moodMu,
    required this.moodSigma,
    required this.energyMu,
    required this.energySigma,
    required this.dischargeProbs,
  });
}

/// Emission parameters for all four phases.
const Map<int, PhaseEmissionParams> emissionParams = {
  // ── 0: Menstruation ───────────────────────────────────────────────────────
  0: PhaseEmissionParams(
    bbtMu: 36.4,
    bbtSigma: 0.15,
    lhSurgeP: 0.04,
    restingHrMu: 68.0,
    restingHrSigma: 4.0,
    hrvMu: 48.0,
    hrvSigma: 8.0,
    sleepHoursMu: 7.2,
    sleepHoursSigma: 0.8,
    bleedingProbs: [0.02, 0.08, 0.30, 0.40, 0.20],
    crampsProbs: [0.15, 0.25, 0.35, 0.25],
    bloatingP: 0.55,
    breastPainP: 0.25,
    headacheP: 0.35,
    moodMu: 2.5,
    moodSigma: 0.8,
    energyMu: 2.5,
    energySigma: 0.8,
    dischargeProbs: [0.70, 0.20, 0.08, 0.02],
  ),

  // ── 1: Follicular ─────────────────────────────────────────────────────────
  1: PhaseEmissionParams(
    bbtMu: 36.5,
    bbtSigma: 0.12,
    lhSurgeP: 0.04,
    restingHrMu: 65.0,
    restingHrSigma: 3.5,
    hrvMu: 55.0,
    hrvSigma: 8.0,
    sleepHoursMu: 7.5,
    sleepHoursSigma: 0.7,
    bleedingProbs: [0.90, 0.07, 0.02, 0.01, 0.00],
    crampsProbs: [0.75, 0.18, 0.06, 0.01],
    bloatingP: 0.10,
    breastPainP: 0.08,
    headacheP: 0.10,
    moodMu: 3.8,
    moodSigma: 0.7,
    energyMu: 4.0,
    energySigma: 0.7,
    dischargeProbs: [0.30, 0.35, 0.30, 0.05],
  ),

  // ── 2: Ovulatory ──────────────────────────────────────────────────────────
  2: PhaseEmissionParams(
    bbtMu: 36.65,
    bbtSigma: 0.12,
    lhSurgeP: 0.82,
    restingHrMu: 66.0,
    restingHrSigma: 3.5,
    hrvMu: 53.0,
    hrvSigma: 7.0,
    sleepHoursMu: 7.4,
    sleepHoursSigma: 0.7,
    bleedingProbs: [0.85, 0.10, 0.04, 0.01, 0.00],
    crampsProbs: [0.50, 0.30, 0.15, 0.05],
    bloatingP: 0.30,
    breastPainP: 0.20,
    headacheP: 0.20,
    moodMu: 4.2,
    moodSigma: 0.6,
    energyMu: 4.3,
    energySigma: 0.6,
    dischargeProbs: [0.05, 0.10, 0.20, 0.65],
  ),

  // ── 3: Luteal ─────────────────────────────────────────────────────────────
  3: PhaseEmissionParams(
    bbtMu: 36.82,
    bbtSigma: 0.10,
    lhSurgeP: 0.02,
    restingHrMu: 70.0,
    restingHrSigma: 4.0,
    hrvMu: 46.0,
    hrvSigma: 7.0,
    sleepHoursMu: 6.9,
    sleepHoursSigma: 0.9,
    bleedingProbs: [0.94, 0.04, 0.01, 0.01, 0.00],
    crampsProbs: [0.60, 0.22, 0.12, 0.06],
    bloatingP: 0.50,
    breastPainP: 0.55,
    headacheP: 0.30,
    moodMu: 3.0,
    moodSigma: 0.9,
    energyMu: 3.0,
    energySigma: 0.9,
    dischargeProbs: [0.55, 0.25, 0.15, 0.05],
  ),
};
