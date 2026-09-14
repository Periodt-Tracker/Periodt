import 'package:app/core/logging/event.dart';
import 'package:app/core/logging/level.dart';

abstract interface class LogSink {
  void write(LogEvent event);

  void close() {}
}

abstract interface class FilteringSink implements LogSink {
  LogLevel get minimumLevel;
}
