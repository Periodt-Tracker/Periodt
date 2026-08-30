import 'package:app/core/utilities/date.dart';
import 'package:app/features/forecasting/domain/stage.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'forecast_day.freezed.dart';

@freezed
class ForecastDay with _$ForecastDay {
  ForecastDay({
    required this.date,
    required this.stage,
    required this.probabilities,
    required this.cycleDay,
    required this.cycleLength,
  });

  final DateOnly date;
  final CycleStage stage;
  final Map<CycleStage, double> probabilities;
  final int cycleDay;
  final int cycleLength;
}
