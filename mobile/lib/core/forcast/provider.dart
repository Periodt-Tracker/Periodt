import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:periodt/core/database/provider.dart';
import 'package:periodt/core/forcast/backend/base.dart';
import 'package:periodt/core/forcast/backend/fixture/fixture.dart';
import 'package:periodt/core/forcast/backend/hang/hang.dart';
import 'package:periodt/core/forcast/backend/models.dart';
import 'package:periodt/core/forcast/backend/simple/simple.dart';
import 'package:periodt/core/settings/notifier.dart';
import 'package:periodt/core/utilities/range.dart';

final forecastBackendProvider = Provider<ForecastBackend>((ref) {
  final settings = ref.watch(settingsNotifier);

  switch (settings.developer.forecastModel) {
    case ForcastModel.fixture:
      return FixtureForecastBackend();

    case ForcastModel.simple:
      return SimpleForecastBackend();

    case ForcastModel.hsmm:
      throw UnimplementedError("HSMM model not implemented yet");

    case ForcastModel.hanging:
      return HangingForecastBackend();
  }
});

final forecastProvider = FutureProvider<Forecast>((ref) async {
  final backend = ref.watch(forecastBackendProvider);
  final settings = ref.watch(settingsNotifier);

  final periods = await ref.watch(periodsProvider.future);

  final cycleSettings = settings.cycle;

  final data = ForecastData(
    periods: periods,
    logs: [], // TODO: implement log
    cycleLength: Range(
      upper: 28, // cycleSettings.upperCycleLength,
      lower: 26, // cycleSettings.lowerCycleLength,
    ),
    periodLength: Range(
      upper: 4, // cycleSettings.upperPeriodLength,
      lower: 6, // cycleSettings.lowerPeriodLength,
    ),
  );

  return backend.forecast(data, ForecastOptions(cycles: 3));
});

final selectedDateProvider = StateProvider<DateTime>((ref) => DateTime.now());

final selectedDayProvider = FutureProvider<ForecastDay?>((ref) async {
  final forecast = await ref.watch(forecastProvider.future);
  final selectedDay = ref.watch(selectedDateProvider);

  return forecast.days.firstWhere(
    (day) =>
        day.date.year == selectedDay.year &&
        day.date.month == selectedDay.month &&
        day.date.day == selectedDay.day,
  );
});
