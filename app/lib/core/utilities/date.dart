class DateOnly implements Comparable<DateOnly> {
  final int year;
  final int month;
  final int day;

  const DateOnly(this.year, this.month, this.day);

  factory DateOnly.now() {
    final now = DateTime.now();

    return DateOnly.fromDateTime(now);
  }

  factory DateOnly.fromDateTime(DateTime dt) {
    return DateOnly(dt.year, dt.month, dt.day);
  }

  factory DateOnly.fromIsoString(String iso) {
    final parts = iso.split('-');
    if (parts.length != 3) {
      throw FormatException('Invalid ISO date: $iso');
    }

    return DateOnly(
      int.parse(parts[0]),
      int.parse(parts[1]),
      int.parse(parts[2]),
    );
  }

  bool isAfter(DateOnly other) {
    return compareTo(other) > 0;
  }

  bool isBefore(DateOnly other) {
    return compareTo(other) < 0;
  }

  String toIsoString() {
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$year-$m-$d';
  }

  DateTime toDateTime() => DateTime(year, month, day);

  @override
  int compareTo(DateOnly other) {
    return toDateTime().compareTo(other.toDateTime());
  }

  @override
  String toString() => toIsoString();

  @override
  bool operator ==(Object other) =>
      other is DateOnly &&
      year == other.year &&
      month == other.month &&
      day == other.day;

  @override
  int get hashCode => Object.hash(year, month, day);
}
