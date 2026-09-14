import 'package:app/core/logging/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoggingBloc<Event, State> extends Bloc<Event, State> {
  LoggingBloc(
    super.initialState, {
    required String name,
    required PeriodtLogger logger,
  }) : logger = logger.child(name);

  final PeriodtLogger logger;
}
