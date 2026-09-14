import 'level.dart';

typedef LogFields = Map<String, Object?>;

enum SpanStatus { ok, error }

final class LogEvent {
  const LogEvent({
    required this.timestamp,
    required this.level,
    required this.loggerName,
    required this.message,
    this.fields = const {},
    this.error,
    this.stackTrace,
    this.traceId,
    this.spanId,
    this.parentSpanId,
    this.spanName,
    this.eventType = LogEventType.log,
    this.duration,
    this.status,
  });

  final DateTime timestamp;
  final LogLevel level;
  final String loggerName;
  final String message;
  final LogFields fields;
  final Object? error;
  final StackTrace? stackTrace;

  final String? traceId;
  final String? spanId;
  final String? parentSpanId;
  final String? spanName;

  final LogEventType eventType;
  final Duration? duration;
  final SpanStatus? status;

  Map<String, Object?> toJson() => {
    'timestamp': timestamp.toUtc().toIso8601String(),
    'level': level.label,
    'logger': loggerName,
    'message': message,
    if (fields.isNotEmpty) 'fields': fields,
    if (error != null) 'error': error.toString(),
    if (stackTrace != null) 'stackTrace': stackTrace.toString(),
    if (traceId != null) 'traceId': traceId,
    if (spanId != null) 'spanId': spanId,
    if (parentSpanId != null) 'parentSpanId': parentSpanId,
    if (spanName != null) 'span': spanName,
    if (eventType != LogEventType.log) 'eventType': eventType.name,
    if (duration != null) 'durationMs': duration!.inMicroseconds / 1000,
    if (status != null) 'status': status!.name,
  };
}

enum LogEventType { log, spanStart, spanEnd }
