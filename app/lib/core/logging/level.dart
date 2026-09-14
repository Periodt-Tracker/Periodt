enum LogLevel implements Comparable<LogLevel> {
  trace(0, 'TRACE'),
  debug(1, 'DEBUG'),
  info(2, 'INFO'),
  warning(3, 'WARN'),
  error(4, 'ERROR'),
  fatal(5, 'FATAL');

  const LogLevel(this.severity, this.label);

  final int severity;
  final String label;

  @override
  int compareTo(LogLevel other) => severity.compareTo(other.severity);

  bool isAtLeast(LogLevel other) => severity >= other.severity;

  bool isLessThan(LogLevel other) => severity < other.severity;

  bool isAtMost(LogLevel other) => severity <= other.severity;
}
