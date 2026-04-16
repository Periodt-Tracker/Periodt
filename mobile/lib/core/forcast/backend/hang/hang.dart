import 'dart:async';

import 'package:periodt/core/forcast/backend/base.dart';

class HangingForecastBackend implements ForecastBackend {
  @override
  Future<Forecast> forecast(ForecastData data, ForecastOptions options) async {
    final completer = Completer<Forecast>();

    return await completer.future;
  }
}
