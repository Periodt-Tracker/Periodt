import 'package:health/health.dart';
import 'package:periodt/core/health/health_record.dart';

class HealthService {
  static const _types = <HealthDataType>[
    HealthDataType.BODY_TEMPERATURE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_SDNN,
    HealthDataType.RESPIRATORY_RATE,
    HealthDataType.SLEEP_ASLEEP,
  ];

  final Health _health;

  HealthService(this._health);

  Future<bool> _ensurePermissions() async {
    return await _health.requestAuthorization(_types);
  }

  Future<HealthRecord> fetchHealthMetrics(DateTime date) async {
    final granted = await _ensurePermissions();

    if (!granted) {
      throw Exception("Health permissions not granted");
    }

    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));

    final data = await _health.getHealthDataFromTypes(
      types: _types,
      startTime: start,
      endTime: end,
    );

    return _mapToHealthMetrics(data);
  }

  HealthRecord _mapToHealthMetrics(List<HealthDataPoint> data) {
    double? skinTemp;
    double? restingHr;
    double? hrv;
    double? respRate;
    double? sleepHours;

    for (final point in data) {
      final value = point.value;

      switch (point.type) {
        case HealthDataType.BODY_TEMPERATURE:
          skinTemp = (value as NumericHealthValue).numericValue.toDouble();
          break;

        case HealthDataType.RESTING_HEART_RATE:
          restingHr = (value as NumericHealthValue).numericValue.toDouble();
          break;

        case HealthDataType.HEART_RATE_VARIABILITY_SDNN:
          hrv = (value as NumericHealthValue).numericValue.toDouble();
          break;

        case HealthDataType.RESPIRATORY_RATE:
          respRate = (value as NumericHealthValue).numericValue.toDouble();
          break;

        case HealthDataType.SLEEP_ASLEEP:
          final duration = point.dateTo.difference(point.dateFrom);
          sleepHours = (sleepHours ?? 0) + duration.inMinutes / 60.0;
          break;

        default:
          break;
      }
    }

    return HealthRecord(
      skinTemp: skinTemp,
      restingHr: restingHr,
      hrvRmssd: hrv,
      respiratoryRate: respRate,
      sleepHours: sleepHours,
    );
  }
}
