import 'dart:async';

import 'package:app/core/logging/app_logger.dart';
import 'package:app/core/logging/log_level.dart';
import 'package:app/core/logging/log_sink.dart';
import 'package:app/core/logging/sinks/console_sink.dart';
import 'package:app/core/logging/sinks/file_sink.dart';
import 'package:app/core/logging/sinks/memory_sink.dart';
import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Wires up [AppLogger] with its sinks, catches uncaught errors from every
/// layer Flutter exposes, and stamps the first log line of every session
/// with enough environment info to make a bug report useful — since there's
/// no telemetry to fall back on.
///
/// Call [init] from `main()` before `runApp`, and run the app itself inside
/// [runAppGuarded] so async errors outside the normal Flutter error paths
/// still get captured. See the example at the bottom of this file.
class AppLoggerInitializer {
  AppLoggerInitializer._();

  static final MemorySink memorySink = MemorySink();
  static RotatingFileSink? _fileSink;

  /// Exposed for `LogExportService` and the log viewer screen. Throws if
  /// accessed before [init] has completed — that's a startup ordering bug,
  /// not something to silently work around.
  static RotatingFileSink get fileSink {
    final sink = _fileSink;
    if (sink == null) {
      throw StateError(
        'AppLoggerInitializer.fileSink accessed before init() completed.',
      );
    }
    return sink;
  }

  static Future<void> init({AppLogLevel minLevel = AppLogLevel.info}) async {
    final fileSink = RotatingFileSink();
    await fileSink.init();
    _fileSink = fileSink;

    final sinks = <LogSink>[
      if (kDebugMode) ConsoleSink(),
      fileSink,
      memorySink,
    ];

    AppLogger.instance.init(sinks: sinks, minLevel: minLevel);

    await _logSessionHeader();
    _installErrorHandlers();
  }

  static Future<void> _logSessionHeader() async {
    var appVersion = 'unknown';
    try {
      final info = await PackageInfo.fromPlatform();
      appVersion = '${info.version}+${info.buildNumber}';
    } catch (_) {
      // A missing version string is far less important than a startup
      // crash caused by the logging helper itself — proceed without it.
    }

    AppLogger.instance.info('session', 'App started', {
      'app_version': appVersion,
      'platform': defaultTargetPlatform.name,
      'debug_mode': kDebugMode,
    });
  }

  static void _installErrorHandlers() {
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails details) {
      AppLogger.instance.error(
        'flutter',
        'Framework error',
        error: details.exception,
        stackTrace: details.stack,
      );
      previousOnError?.call(details);
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      AppLogger.instance.error(
        'platform',
        'Uncaught platform error',
        error: error,
        stackTrace: stack,
      );
      return true; // handled — don't let this crash release builds
    };
  }

  static Future<void> dispose() => AppLogger.instance.dispose();
}

/// Runs [body] (typically `() => runApp(const MyApp())`) inside a guarded
/// zone, so async errors that escape Flutter's normal error handlers (e.g.
/// thrown from a `Future` nobody awaited) get logged instead of silently
/// vanishing or crashing the isolate.
///
/// Example `main.dart`:
/// ```dart
/// Future<void> main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await AppLoggerInitializer.init(
///     minLevel: kDebugMode ? AppLogLevel.debug : AppLogLevel.info,
///   );
///   Bloc.observer = AppBlocObserver();
///   runAppGuarded(() => runApp(const PeriodTrackerApp()));
/// }
/// ```
void runAppGuarded(void Function() body) {
  runZonedGuarded(body, (error, stack) {
    AppLogger.instance.error(
      'zone',
      'Uncaught zone error',
      error: error,
      stackTrace: stack,
    );
  });
}
