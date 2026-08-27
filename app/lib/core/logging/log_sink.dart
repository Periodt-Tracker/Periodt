import 'log_entry.dart';

/// A destination for log entries. Sinks are fanned out to from [AppLogger]
/// and must never throw in a way that reaches the caller — a broken sink
/// should not crash the app or take down other sinks. [AppLogger] wraps
/// every `write` call defensively, but sinks should still be defensive
/// internally too.
abstract class LogSink {
  Future<void> write(LogEntry entry);

  /// Called on app shutdown / logger disposal. Flush buffers, close file
  /// handles, etc.
  Future<void> dispose() async {}
}
