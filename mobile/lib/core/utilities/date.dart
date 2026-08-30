class DateUtils {
  static DateTime toDateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static String toIsoDate(DateTime dateTime) {
    final dateOnly = toDateOnly(dateTime);
    return dateOnly.toIso8601String().split('T').first;
  }

  static String nowIsoDate() {
    final now = DateTime.now();

    return toIsoDate(now);
  }

  static DateTime parseIsoDate(String isoDate) {
    final date = DateTime.parse(isoDate);

    return DateTime(date.year, date.month, date.day);
  }
}
