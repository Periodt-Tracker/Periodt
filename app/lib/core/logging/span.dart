import 'dart:async';
import 'dart:math';

import 'package:app/core/logging/event.dart';

final class LogContext {
  const LogContext({
    required this.traceId,
    required this.spanId,
    required this.spanName,
    required this.depth,
    required this.fields,
  });

  const LogContext.root()
    : traceId = null,
      spanId = null,
      spanName = null,
      depth = 0,
      fields = const {};

  final String? traceId;
  final String? spanId;
  final String? spanName;
  final int depth;
  final LogFields fields;
}

final class Span {
  Span._({
    required this.traceId,
    required this.spanId,
    required this.parentSpanId,
    required this.name,
    required this.startedAt,
    required this.depth,
    required LogFields fields,
  }) : _fields = {...fields};

  final String traceId;
  final String spanId;
  final String? parentSpanId;
  final String name;
  final DateTime startedAt;
  final int depth;
  final LogFields _fields;

  bool _ended = false;
  SpanStatus? _status;

  Map<String, Object?> get fields => Map.unmodifiable(_fields);
  SpanStatus? get status => _status;
  bool get ended => _ended;

  void setField(String key, Object? value) {
    if (_ended) {
      throw StateError('Cannot modify an ended span.');
    }
    _fields[key] = value;
  }

  void setFields(Map<String, Object?> fields) {
    if (_ended) {
      throw StateError('Cannot modify an ended span.');
    }
    _fields.addAll(fields);
  }

  void setStatus(SpanStatus status) {
    if (_ended) {
      throw StateError('Cannot modify an ended span.');
    }
    _status = status;
  }

  Duration get elapsed => DateTime.now().difference(startedAt);

  void end([SpanStatus status = SpanStatus.ok]) {
    if (_ended) return;
    _status = status;
    _ended = true;
  }

  static Span start({
    required LogContext parent,
    required String name,
    required LogFields fields,
  }) {
    return Span._(
      traceId: parent.traceId ?? _id(16),
      spanId: _id(8),
      parentSpanId: parent.spanId,
      name: name,
      startedAt: DateTime.now(),
      depth: parent.depth + 1,
      fields: fields,
    );
  }

  static String _id(int bytes) {
    final random = Random.secure();
    final values = List<int>.generate(bytes, (_) => random.nextInt(256));
    return values.map((v) => v.toRadixString(16).padLeft(2, '0')).join();
  }
}

final class LogContextStore {
  static const Object zoneKey = #localLoggerContext;

  static LogContext get current =>
      Zone.current[zoneKey] as LogContext? ?? const LogContext.root();
}
