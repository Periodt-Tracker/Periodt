import 'dart:developer' as developer;

import '../log_entry.dart';
import '../log_sink.dart';

/// Prints to the IDE/terminal console via `dart:developer`'s [developer.log],
/// which — unlike `print` — doesn't truncate long messages and shows up
/// correctly (with level, name, and error/stack) in DevTools.
///
/// Intended for debug builds only. Gate its construction on `kDebugMode` at
/// the call site (see `AppLoggerInitializer`) rather than checking here, so
/// this class stays a plain, unconditional sink.
class ConsoleSink implements LogSink {
  @override
  Future<void> write(LogEntry entry) async {
    developer.log(
      entry.message,
      time: entry.timestamp,
      name: entry.tag,
      level: entry.level.loggingLevel.value,
      error: entry.error,
      stackTrace: entry.stackTrace,
    );
  }

  @override
  Future<void> dispose() async {}
}
