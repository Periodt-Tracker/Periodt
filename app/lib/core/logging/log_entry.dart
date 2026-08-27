import 'package:app/core/logging/log_level.dart';

/// A single structured log line.
///
/// IMPORTANT (privacy): [data] must only ever contain safe, non-identifying
/// scalars — counts, ids, enum names, durations, booleans. Never put a
/// domain model (CycleEntry, Symptom, Note, ...) or user-entered text in
/// here. [AppLogger] enforces a best-effort version of this at debug time —
/// see its `_assertSafe`.
class LogEntry {
  LogEntry({
    required this.timestamp,
    required this.level,
    required this.tag,
    required this.message,
    this.data,
    this.error,
    this.stackTrace,
  });

  final DateTime timestamp;
  final AppLogLevel level;

  /// Short identifier for where this log came from, e.g. a bloc name or
  /// repository name — not business-domain content.
  final String tag;

  final String message;
  final Map<String, Object?>? data;
  final Object? error;
  final StackTrace? stackTrace;

  /// Single-line-ish, human-readable rendering used by every sink, so
  /// console/file/in-app views all stay in sync.
  String format() {
    final buffer = StringBuffer()
      ..write(timestamp.toIso8601String())
      ..write(' ')
      ..write('[${level.label}]'.padRight(7))
      ..write(' ')
      ..write('$tag: ')
      ..write(message);

    if (data != null && data!.isNotEmpty) {
      buffer.write(' | ${_formatData(data!)}');
    }
    if (error != null) {
      buffer.write('\n  error: $error');
    }
    if (stackTrace != null) {
      buffer.write('\n$stackTrace');
    }
    return buffer.toString();
  }

  static String _formatData(Map<String, Object?> data) {
    return data.entries.map((e) => '${e.key}=${e.value}').join(', ');
  }
}
