import 'package:app/core/utilities/date.dart';
import 'package:flutter/material.dart';

@immutable
class PeriodDetails {
  final DateOnly start;
  final DateOnly end;

  const PeriodDetails({required this.start, required this.end});
}

@immutable
class PeriodMetadata {
  final int cycleLength;
  final int periodLength;

  const PeriodMetadata({required this.cycleLength, required this.periodLength});
}
