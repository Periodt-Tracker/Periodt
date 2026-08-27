import 'dart:io';

import 'package:app/core/logging/log_entry.dart';
import 'package:app/core/logging/log_sink.dart';
import 'package:path_provider/path_provider.dart';

/// Writes log entries to one file per calendar day under the app's support
/// directory, so retention has a clean, explainable story ("we keep the
/// last N days of logs") and a bug report referencing "yesterday" or "the
/// last few days" maps directly onto file names.
///
/// File naming: `app-YYYY-MM-DD.log`. If a single day's log grows past
/// [maxBytesPerFile] — which should basically never happen in normal use —
/// it overflows to `app-YYYY-MM-DD_2.log`, `_3.log`, etc, so a pathological
/// retry loop or a very long verbose-logging session can't fill the disk.
///
/// Only the [maxDays] most recent calendar days are kept; whole days older
/// than that (including any overflow files for that day) are deleted.
///
/// Writes are serialized through an internal queue so concurrent log calls
/// never interleave or race on the file handle, and so a slow disk never
/// blocks the caller — [write] returns as soon as the entry is queued, not
/// once it's actually on disk.
class RotatingFileSink implements LogSink {
  RotatingFileSink({
    this.maxDays = 7,
    this.maxBytesPerFile = 5 * 1024 * 1024, // 5 MB safety valve per day
  });

  final int maxDays;
  final int maxBytesPerFile;

  static final RegExp _fileNamePattern = RegExp(
    r'^app-(\d{4}-\d{2}-\d{2})(?:_(\d+))?\.log$',
  );

  Directory? _logDir;
  IOSink? _activeSink;
  int _currentSize = 0;
  String? _currentDateKey;
  int _currentOverflowIndex = 1; // 1 = app-YYYY-MM-DD.log, 2+ = _2, _3, ...
  Future<void> _writeQueue = Future.value();
  bool _disposed = false;

  /// Must be called once before the sink is used. `AppLoggerInitializer`
  /// does this for you as part of app startup.
  Future<void> init() async {
    final supportDir = await getApplicationSupportDirectory();
    _logDir = Directory('${supportDir.path}/logs')..createSync(recursive: true);
    await _openForDate(_dateKey(DateTime.now()));
    await _pruneOldDays();
  }

  @override
  Future<void> write(LogEntry entry) async {
    if (_disposed || _logDir == null) return;
    // Chain onto the write queue so writes are strictly ordered and never
    // interleave, without making the caller await disk I/O.
    _writeQueue = _writeQueue.then((_) => _writeInternal(entry));
  }

  Future<void> _writeInternal(LogEntry entry) async {
    final todayKey = _dateKey(entry.timestamp);
    if (todayKey != _currentDateKey) {
      // Crossed midnight since the last write — roll to a fresh day.
      await _openForDate(todayKey);
      await _pruneOldDays();
    }

    final line = '${entry.format()}\n';
    final approxBytes = line.length;
    if (_currentSize + approxBytes > maxBytesPerFile) {
      await _openForDate(todayKey, overflow: true);
    }

    _activeSink?.write(line);
    _currentSize += approxBytes;
  }

  /// Opens the file for [dateKey], continuing an existing file if one
  /// already exists for that day (e.g. app restarted same-day), or bumping
  /// to the next overflow index if [overflow] is requested because the
  /// current file just hit the size cap.
  Future<void> _openForDate(String dateKey, {bool overflow = false}) async {
    await _activeSink?.flush();
    await _activeSink?.close();

    final sameDay = dateKey == _currentDateKey;
    if (overflow && sameDay) {
      _currentOverflowIndex += 1;
    } else if (!sameDay) {
      // New day: if files already exist for it (unlikely, but possible if
      // clock skew or a prior session left some behind), pick up after the
      // highest existing overflow index instead of clobbering.
      final highest = _highestExistingOverflowIndex(dateKey);
      _currentOverflowIndex = highest == 0 ? 1 : highest;
    } else {
      _currentOverflowIndex = 1;
    }

    _currentDateKey = dateKey;
    final file = _fileFor(dateKey, _currentOverflowIndex);
    _currentSize = file.existsSync() ? await file.length() : 0;
    _activeSink = file.openWrite(mode: FileMode.append);
  }

  int _highestExistingOverflowIndex(String dateKey) {
    var highest = 0;
    for (final entity in _logDir!.listSync()) {
      if (entity is! File) continue;
      final match = _fileNamePattern.firstMatch(entity.uri.pathSegments.last);
      if (match == null || match.group(1) != dateKey) continue;
      final index = int.tryParse(match.group(2) ?? '1') ?? 1;
      if (index > highest) highest = index;
    }
    return highest;
  }

  File _fileFor(String dateKey, int overflowIndex) {
    final suffix = overflowIndex > 1 ? '_$overflowIndex' : '';
    return File('${_logDir!.path}/app-$dateKey$suffix.log');
  }

  Future<void> _pruneOldDays() async {
    final dateKeys = <String>{};
    for (final entity in _logDir!.listSync()) {
      if (entity is! File) continue;
      final match = _fileNamePattern.firstMatch(entity.uri.pathSegments.last);
      if (match != null) dateKeys.add(match.group(1)!);
    }
    if (dateKeys.length <= maxDays) return;

    final sortedDates = dateKeys.toList()..sort(); // ISO dates sort lexically
    final toDelete = sortedDates.take(sortedDates.length - maxDays);
    for (final dateKey in toDelete) {
      for (final entity in _logDir!.listSync()) {
        if (entity is! File) continue;
        final match = _fileNamePattern.firstMatch(entity.uri.pathSegments.last);
        if (match != null && match.group(1) == dateKey) {
          entity.deleteSync();
        }
      }
    }
  }

  static String _dateKey(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}-${two(dt.month)}-${two(dt.day)}';
  }

  /// All log files on disk, most recent first — used by
  /// [LogExportService]. Sorted by date descending, then by overflow index
  /// descending within a date.
  Future<List<File>> logFiles() async {
    if (_logDir == null) return [];
    final matches = <MapEntry<File, (String, int)>>[];
    for (final entity in _logDir!.listSync()) {
      if (entity is! File) continue;
      final name = entity.uri.pathSegments.last;
      final match = _fileNamePattern.firstMatch(name);
      if (match == null) continue;
      final dateKey = match.group(1)!;
      final index = int.tryParse(match.group(2) ?? '1') ?? 1;
      matches.add(MapEntry(entity, (dateKey, index)));
    }
    matches.sort((a, b) {
      final dateCompare = b.value.$1.compareTo(a.value.$1);
      if (dateCompare != 0) return dateCompare;
      return b.value.$2.compareTo(a.value.$2);
    });
    return matches.map((e) => e.key).toList();
  }

  @override
  Future<void> dispose() async {
    _disposed = true;
    await _writeQueue;
    await _activeSink?.flush();
    await _activeSink?.close();
  }
}
