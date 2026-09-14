import 'dart:convert';
import 'dart:io';

import 'package:app/core/logging/event.dart';
import 'package:app/core/logging/level.dart';
import 'package:app/core/logging/sink.dart';

final class ConsoleSink implements LogSink {
  ConsoleSink({
    this.json = false,
    this.minimumLevel = LogLevel.trace,
    this.useStderrForErrors = true,
  });

  final bool json;
  final LogLevel minimumLevel;
  final bool useStderrForErrors;

  @override
  void write(LogEvent event) {
    if (event.level.isAtLeast(minimumLevel)) return;

    if (json) {
      (event.level.isAtLeast(LogLevel.error) ? stderr : stdout).writeln(
        jsonEncode(event.toJson()),
      );
      return;
    }

    final indent = '  ' * _depth(event);
    final context = [
      event.loggerName,
      if (event.spanName != null) event.spanName!,
    ].join(' ');

    final fields = event.fields.entries
        .map((entry) => '${entry.key}=${_format(entry.value)}')
        .join(' ');

    final buffer = StringBuffer()
      ..write(indent)
      ..write(event.level.label.padRight(5))
      ..write(' ')
      ..write(context)
      ..write('  ')
      ..write(event.message);

    if (fields.isNotEmpty) {
      buffer
        ..write('  ')
        ..write(fields);
    }

    if (event.duration != null) {
      buffer
        ..write('  duration=')
        ..write(_duration(event.duration!));
    }

    if (event.status != null) {
      buffer
        ..write('  status=')
        ..write(event.status!.name);
    }

    final output = buffer.toString();

    if (useStderrForErrors && event.level.isAtLeast(LogLevel.error)) {
      stderr.writeln(output);
      if (event.error != null) stderr.writeln('$indent  error: ${event.error}');
      if (event.stackTrace != null) stderr.writeln('$indent$event.stackTrace');
    } else {
      stdout.writeln(output);
    }
  }

  int _depth(LogEvent event) {
    if (event.eventType == LogEventType.spanStart) return _spanDepth(event);
    if (event.eventType == LogEventType.spanEnd) return _spanDepth(event);
    return event.spanId == null ? 0 : _spanDepth(event);
  }

  int _spanDepth(LogEvent event) {
    // Console indentation is intentionally derived from the parent relationship
    // only when the sink is given depth via a field.
    final depth = event.fields['_spanDepth'];
    return depth is int ? depth : 0;
  }

  String _duration(Duration value) {
    final ms = value.inMicroseconds / 1000;
    return '${ms.toStringAsFixed(1)}ms';
  }

  String _format(Object? value) {
    if (value == null) return 'null';
    if (value is String) return '"$value"';
    if (value is Map || value is Iterable) return jsonEncode(value);
    return value.toString();
  }

  @override
  void close() {
    // TODO: implement close
  }
}
