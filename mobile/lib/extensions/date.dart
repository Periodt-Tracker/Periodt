extension DateTimeExtension on DateTime {
  bool isBetween(DateTime start, DateTime end) {
    return isAfter(start) && isBefore(end);
  }
}
