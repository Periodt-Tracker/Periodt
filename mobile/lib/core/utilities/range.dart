import 'package:flutter/foundation.dart';
import 'package:periodt/core/utilities/date_only.dart';

@immutable
class Range<T> {
  final T upper;
  final T lower;

  const Range({required this.upper, required this.lower});

  Range<T> copyWith({T? upper, T? lower}) {
    return Range(upper: upper ?? this.upper, lower: lower ?? this.lower);
  }
}

extension NumberRange on Range<int> {
  double mean() {
    return (lower + upper) / 2;
  }

  int discreteMean() {
    return mean().round();
  }
}

extension DateRange on Range<DateTime> {
  List<DateTime> datesBetween() {
    final start = DateTime(lower.year, lower.month, lower.day);
    final end = DateTime(upper.year, upper.month, upper.day);

    final days = end.difference(start).inDays;

    return List.generate(days + 1, (i) => start.add(Duration(days: i)));
  }

  bool contains(DateTime date) {
    return date.isAfter(lower) && date.isBefore(upper);
  }
}
