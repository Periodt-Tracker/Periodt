import 'package:logging/logging.dart' as logging;

/// Application-facing log levels, mapped onto `package:logging`'s [logging.Level].
///
/// Kept intentionally small — five levels covers everything this app needs
/// and keeps log output easy to scan and filter.
enum AppLogLevel {
  debug,
  info,
  warning,
  error,
  critical;

  /// The underlying `package:logging` level, exposed so [AppLogger] can use
  /// the real hierarchical logger machinery under the hood.
  logging.Level get loggingLevel => switch (this) {
    AppLogLevel.debug => logging.Level.FINE,
    AppLogLevel.info => logging.Level.INFO,
    AppLogLevel.warning => logging.Level.WARNING,
    AppLogLevel.error => logging.Level.SEVERE,
    AppLogLevel.critical => logging.Level.SHOUT,
  };

  static AppLogLevel fromLoggingLevel(logging.Level level) {
    if (level >= logging.Level.SHOUT) return AppLogLevel.critical;
    if (level >= logging.Level.SEVERE) return AppLogLevel.error;
    if (level >= logging.Level.WARNING) return AppLogLevel.warning;
    if (level >= logging.Level.INFO) return AppLogLevel.info;
    return AppLogLevel.debug;
  }

  String get label => switch (this) {
    AppLogLevel.debug => 'DEBUG',
    AppLogLevel.info => 'INFO',
    AppLogLevel.warning => 'WARN',
    AppLogLevel.error => 'ERROR',
    AppLogLevel.critical => 'CRITICAL',
  };
}
