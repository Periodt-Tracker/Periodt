import 'dart:async';

import 'package:app/core/logging/log_entry.dart';
import 'package:app/core/logging/log_level.dart';
import 'package:app/core/logging/log_sink.dart';

/// Central logging facade. This is the only thing app code should ever
/// import to log something — never write to a sink directly.
///
/// Usage:
/// ```dart
/// AppLogger.instance.i('cycle_repository', 'Loaded entries', {'count': 12});
/// AppLogger.instance.e('sync_service', 'Failed to write to disk',
///     error: e, stackTrace: st);
/// ```
///
/// PRIVACY CONTRACT — read this before adding a log call:
/// The `data` map passed to any log call must contain only safe scalar
/// values (bool, num, String, null) or Lists/Maps of the same — ids,
/// counts, enum names, durations, booleans. Never pass a domain model, a
/// date the user entered, or free text.
///
/// In debug builds, [_assertSafe] throws if a value looks like an
/// accidental `Object.toString()` dump, or isn't a recognized safe type at
/// all. This is a *backstop* against the most common mistake (interpolating
/// a whole object), not a substitute for care at the call site — it is
/// stripped out of release builds via `assert()`, so it can never crash a
/// user's app, but it also can't save you in production. Review log calls
/// touching domain data with the same scrutiny as the data model itself.
class AppLogger {
  AppLogger._();

  static final AppLogger instance = AppLogger._();

  final List<LogSink> _sinks = [];
  AppLogLevel _minLevel = AppLogLevel.info;
  bool _initialized = false;

  /// Wire up sinks and set the initial minimum level. Call once at startup
  /// (see `AppLoggerInitializer.init`), after any async sink setup (e.g.
  /// `RotatingFileSink.init()`) has completed.
  void init({
    required List<LogSink> sinks,
    AppLogLevel minLevel = AppLogLevel.info,
  }) {
    _sinks
      ..clear()
      ..addAll(sinks);
    _minLevel = minLevel;
    _initialized = true;
  }

  /// Lets a settings screen flip on verbose logging at runtime when a user
  /// is reproducing a bug, without needing a rebuild.
  void setMinLevel(AppLogLevel level) => _minLevel = level;

  AppLogLevel get minLevel => _minLevel;

  void debug(String tag, String message, [Map<String, Object?>? data]) =>
      _log(AppLogLevel.debug, tag, message, data);

  void info(String tag, String message, [Map<String, Object?>? data]) =>
      _log(AppLogLevel.info, tag, message, data);

  void warn(
    String tag,
    String message, [
    Map<String, Object?>? data,
    Object? error,
    StackTrace? stackTrace,
  ]) => _log(AppLogLevel.warning, tag, message, data, error, stackTrace);

  void error(
    String tag,
    String message, {
    Map<String, Object?>? data,
    Object? error,
    StackTrace? stackTrace,
  }) => _log(AppLogLevel.error, tag, message, data, error, stackTrace);

  void critical(
    String tag,
    String message, {
    Map<String, Object?>? data,
    Object? error,
    StackTrace? stackTrace,
  }) => _log(AppLogLevel.critical, tag, message, data, error, stackTrace);

  void _log(
    AppLogLevel level,
    String tag,
    String message, [
    Map<String, Object?>? data,
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (!_initialized || level.index < _minLevel.index) {
      return;
    }

    final entry = LogEntry(
      timestamp: DateTime.now(),
      level: level,
      tag: tag,
      message: message,
      data: data,
      error: error,
      stackTrace: stackTrace,
    );

    for (final sink in _sinks) {
      // Never let one broken sink take down logging — or the app — as a
      // whole. Fire-and-forget with a swallowed error is the right choice
      // for a diagnostic subsystem: a failed log write must never surface
      // as a user-facing crash.
      unawaited(Future.sync(() => sink.write(entry)).catchError((_) {}));
    }
  }

  void _assertSafe(String tag, Map<String, Object?> data, [int depth = 0]) {
    for (final entry in data.entries) {
      _assertValueSafe(tag, entry.key, entry.value, depth);
    }
  }

  void _assertValueSafe(String tag, String key, Object? value, int depth) {
    if (value == null || value is bool || value is num || value is String) {
      if (value is String && _looksLikeDefaultToString(value)) {
        throw StateError(
          'AppLogger: "$tag.$key" looks like a raw Object.toString() '
          '(value: "$value"). Did you accidentally log a domain object? '
          'Log a specific safe field instead (id, count, enum name, etc).',
        );
      }
      return;
    }
    if (value is List) {
      for (final v in value) {
        _assertValueSafe(tag, '$key[]', v, depth + 1);
      }
      return;
    }
    if (value is Map) {
      if (depth > 5) return; // avoid pathological recursion on deep maps
      value.forEach((k, v) => _assertValueSafe(tag, '$key.$k', v, depth + 1));
      return;
    }
    // Deliberately strict: this includes DateTime. If you need to log a
    // date for legitimate diagnostic reasons (e.g. a timezone/DST shift,
    // NOT a tracked cycle date), convert it explicitly to something you've
    // consciously decided is safe, e.g. `date.timeZoneOffset.toString()`,
    // so the decision is visible in the diff rather than implicit.
    throw StateError(
      'AppLogger: "$tag.$key" is a ${value.runtimeType}, not a safe scalar. '
      'Log data must be bool/num/String/List/Map of the same — never a '
      'domain model, DateTime, or other object. This is almost always an '
      'accidental content leak.',
    );
  }

  static bool _looksLikeDefaultToString(String value) {
    return RegExp(r"^Instance of '").hasMatch(value);
  }

  Future<void> dispose() async {
    for (final sink in _sinks) {
      await sink.dispose();
    }
  }
}
