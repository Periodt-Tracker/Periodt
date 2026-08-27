import 'dart:collection';

import 'package:app/core/logging/log_entry.dart';
import 'package:app/core/logging/log_sink.dart';

/// Keeps the last [maxEntries] log lines in memory for an in-app "recent
/// activity" debug view (see `LogViewerScreen`). Cheap, synchronous, no
/// disk I/O — safe to include unconditionally in every build.
class MemorySink implements LogSink {
  MemorySink({this.maxEntries = 500});

  final int maxEntries;
  final Queue<LogEntry> _buffer = ListQueue<LogEntry>();

  @override
  Future<void> write(LogEntry entry) async {
    _buffer.addLast(entry);
    while (_buffer.length > maxEntries) {
      _buffer.removeFirst();
    }
  }

  /// A snapshot of the current buffer, oldest first. Safe to iterate/display
  /// without worrying about concurrent mutation.
  List<LogEntry> snapshot() => List.unmodifiable(_buffer);

  void clear() => _buffer.clear();

  @override
  Future<void> dispose() async {}
}
