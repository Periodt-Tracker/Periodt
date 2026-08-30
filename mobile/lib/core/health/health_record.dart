import 'package:freezed_annotation/freezed_annotation.dart';

part 'health_record.freezed.dart';
part 'health_record.g.dart';

@freezed
abstract class HealthRecord with _$HealthRecord {
  const factory HealthRecord({
    double? skinTemp,
    double? wristTempDiff,
    double? restingHr,
    double? hrvRmssd,
    double? sleepHours,
    double? sleepScore,
    double? stressScore,
    double? respiratoryRate,
  }) = _HealthRecord;

  factory HealthRecord.fromJson(Map<String, dynamic> json) =>
      _$HealthRecordFromJson(json);
}
