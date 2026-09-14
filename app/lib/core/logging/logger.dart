import 'dart:async';

import 'package:app/core/logging/event.dart';
import 'package:app/core/logging/level.dart';
import 'package:app/core/logging/sink.dart';
import 'package:app/core/logging/span.dart';
import 'package:app/core/settings/settings_state.dart';
import 'package:clock/clock.dart';

final class PeriodtLogger {
  PeriodtLogger._({
    required this.name,
    required List<LogSink> sinks,
    required this.minimumLevel,
    required this.baseFields,
  }) : _sinks = List.unmodifiable(sinks);

  factory PeriodtLogger.root({
    String name = 'app',
    required List<LogSink> sinks,
    LogLevel minimumLevel = LogLevel.trace,
    LogFields fields = const {},
  }) {
    return PeriodtLogger._(
      name: name,
      sinks: sinks,
      minimumLevel: minimumLevel,
      baseFields: fields,
    );
  }

  final String name;
  final List<LogSink> _sinks;
  final LogLevel minimumLevel;
  final LogFields baseFields;

  PeriodtLogger child(
    String name, {
    LogFields fields = const {},
  }) {
    return PeriodtLogger._(
      name: '$this.name.$name',
      sinks: _sinks,
      minimumLevel: minimumLevel,
      baseFields: {
        ...baseFields,
        ...fields,
      },
    );
  }

  void trace(String message, {LogFields fields = const {}}) =>
      _write(LogLevel.trace, message, fields: fields);

  void debug(String message, {LogFields fields = const {}}) =>
      _write(LogLevel.debug, message, fields: fields);

  void info(String message, {LogFields fields = const {}}) =>
      _write(LogLevel.info, message, fields: fields);

  void warning(String message, {LogFields fields = const {}}) =>
      _write(LogLevel.warning, message, fields: fields);

  void error(
    String message, {
    LogFields fields = const {},
    Object? error,
    StackTrace? stackTrace,
  }) => _write(
    LogLevel.error,
    message,
    fields: fields,
    error: error,
    stackTrace: stackTrace,
  );

  void fatal(
    String message, {
    LogFields fields = const {},
    Object? error,
    StackTrace? stackTrace,
  }) => _write(
    LogLevel.fatal,
    message,
    fields: fields,
    error: error,
    stackTrace: stackTrace,
  );

  Future<T> span<T>(
    String name,
    Future<T> Function(Span span) action, {
    LogFields fields = const {},
  }) async {
    final parent = LogContextStore.current;

    final span = Span.start(
      parent: parent,
      name: name,
      fields: {
        ...baseFields,
        ...parent.fields,
        ...fields,
      },
    );

    _emitSpanStart(span, fields);

    try {
      final result = await runZoned(
        () => action(span),
        zoneValues: {
          LogContextStore.zoneKey: LogContext(
            traceId: span.traceId,
            spanId: span.spanId,
            spanName: span.name,
            depth: span.depth,
            fields: {
              ...parent.fields,
              ...fields,
              ...span.fields,
            },
          ),
        },
      );

      span.end();
      _emitSpanEnd(span);
      return result;
    } catch (error, stackTrace) {
      span.end(SpanStatus.error);
      _emitSpanEnd(span, error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  T spanSync<T>(
    String name,
    T Function(Span span) action, {
    LogFields fields = const {},
  }) {
    final parent = LogContextStore.current;
    final span = Span.start(
      parent: parent,
      name: name,
      fields: {
        ...baseFields,
        ...parent.fields,
        ...fields,
      },
    );

    _emitSpanStart(span, fields);

    try {
      final result = runZoned(
        () => action(span),
        zoneValues: {
          LogContextStore.zoneKey: LogContext(
            traceId: span.traceId,
            spanId: span.spanId,
            spanName: span.name,
            depth: span.depth,
            fields: {
              ...parent.fields,
              ...fields,
              ...span.fields,
            },
          ),
        },
      );

      span.end();
      _emitSpanEnd(span);
      return result;
    } catch (error, stackTrace) {
      span.end(SpanStatus.error);
      _emitSpanEnd(span, error: error, stackTrace: stackTrace);
      rethrow;
    }
  }

  void _write(
    LogLevel level,
    String message, {
    LogFields fields = const {},
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (level.isAtLeast(minimumLevel)) {
      return;
    }

    final context = LogContextStore.current;

    _emit(
      LogEvent(
        timestamp: clock.now(),
        level: level,
        loggerName: name,
        message: message,
        fields: {
          ...baseFields,
          ...context.fields,
          ...fields,
          '_spanDepth': context.depth,
        },
        error: error,
        stackTrace: stackTrace,
        traceId: context.traceId,
        spanId: context.spanId,
        spanName: context.spanName,
      ),
    );
  }

  void _emitSpanStart(Span span, LogFields fields) {
    if (!LogLevel.debug.isAtLeast(minimumLevel)) {
      return;
    }

    _emit(
      LogEvent(
        timestamp: span.startedAt,
        level: LogLevel.debug,
        loggerName: name,
        message: 'span.start',
        fields: {
          ...baseFields,
          ...fields,
          '_spanDepth': span.depth,
        },
        traceId: span.traceId,
        spanId: span.spanId,
        parentSpanId: span.parentSpanId,
        spanName: span.name,
        eventType: LogEventType.spanStart,
      ),
    );
  }

  void _emitSpanEnd(
    Span span, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!LogLevel.debug.isAtLeast(minimumLevel)) {
      return;
    }

    _emit(
      LogEvent(
        timestamp: clock.now(),
        level: span.status == SpanStatus.error
            ? LogLevel.error
            : LogLevel.debug,
        loggerName: name,
        message: 'span.end',
        fields: {
          ...baseFields,
          ...span.fields,
          '_spanDepth': span.depth,
        },
        error: error,
        stackTrace: stackTrace,
        traceId: span.traceId,
        spanId: span.spanId,
        parentSpanId: span.parentSpanId,
        spanName: span.name,
        eventType: LogEventType.spanEnd,
        duration: span.elapsed,
        status: span.status,
      ),
    );
  }

  void _emit(LogEvent event) {
    for (final sink in _sinks) {
      sink.write(event);
    }
  }

  void close() {
    for (final sink in _sinks) {
      sink.close();
    }
  }

  @override
  String toString() => name;
}
