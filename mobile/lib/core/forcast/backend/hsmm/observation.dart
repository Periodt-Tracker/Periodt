import 'package:freezed_annotation/freezed_annotation.dart';

part 'observation.freezed.dart';
part 'observation.g.dart';

/// One day's worth of observations for the HSMM.
///
/// All fields are optional — set only what you have.
/// Any null field is treated as missing and contributes nothing
/// to the model's likelihood (the model degrades gracefully).
///
/// Health / device channels:
///   bbt         — Basal body temperature in °C  (e.g. 36.5)
///   lhSurge     — LH ovulation strip result 0/1
///   restingHr   — Resting heart rate in bpm      (e.g. 65.0)
///   hrv         — Heart rate variability in ms   (e.g. 52.0)
///   sleepHours  — Hours of sleep                 (e.g. 7.5)
///
/// User-logged symptom channels:
///   bleeding    — Bleeding intensity 0–4 (0=none, 4=heavy)
///   cramps      — Cramping severity 0–3
///   bloating    — Bloating present 0/1
///   breastPain  — Breast tenderness 0/1
///   headache    — Headache present 0/1
///   moodScore   — Self-reported mood 1–5
///   energyScore — Self-reported energy 1–5
///   discharge   — Cervical mucus 0–3 (0=none, 3=egg-white)
@freezed
abstract class CycleObservation with _$CycleObservation {
  const CycleObservation._(); // enables custom getters

  const factory CycleObservation({
    // Health / device
    @JsonKey(name: 'bbt') double? bbt,
    @JsonKey(name: 'lh_surge') int? lhSurge,
    @JsonKey(name: 'resting_hr') double? restingHr,
    @JsonKey(name: 'hrv') double? hrv,
    @JsonKey(name: 'sleep_hours') double? sleepHours,
    // Symptoms
    @JsonKey(name: 'bleeding') int? bleeding,
    @JsonKey(name: 'cramps') int? cramps,
    @JsonKey(name: 'bloating') int? bloating,
    @JsonKey(name: 'breast_pain') int? breastPain,
    @JsonKey(name: 'headache') int? headache,
    @JsonKey(name: 'mood_score') double? moodScore,
    @JsonKey(name: 'energy_score') double? energyScore,
    @JsonKey(name: 'discharge') int? discharge,
  }) = _CycleObservation;

  factory CycleObservation.fromJson(Map<String, dynamic> json) =>
      _$CycleObservationFromJson(json);

  /// True if this observation has at least one non-null field.
  bool get hasAnyData =>
      bbt != null ||
      lhSurge != null ||
      restingHr != null ||
      hrv != null ||
      sleepHours != null ||
      bleeding != null ||
      cramps != null ||
      bloating != null ||
      breastPain != null ||
      headache != null ||
      moodScore != null ||
      energyScore != null ||
      discharge != null;
}
