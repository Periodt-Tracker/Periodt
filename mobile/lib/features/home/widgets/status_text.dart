import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:periodt/core/database/database.dart';
import 'package:periodt/core/database/provider.dart';
import 'package:periodt/core/forcast/backend/base.dart';
import 'package:periodt/extensions/date.dart';
import 'package:periodt/i18n/strings.g.dart';

// the status text can display a range of information about where the selected
// day is releative to the last period that was actually recoreded by the user
//
// 1. if we are in the middle of a logged period then we should show "Day X of Y"
// 2. if we are after the last logged period but within the next cycle then we
//    should show "Period in X days"
// 3. if we are into the next cycle then we should show period X days late from the
//    predicted start date of the last period.
// 4. if we are before the last period then we should show "Period in X days"
//
// That should all hopefully result in something a little like this
//
//     ╭────────────────────────────╮         ╭──────────────────╮
//     │ Is during a logged period? │──Yes───>│   Period Day N   │
//     ╰─────────────┬──────────────╯         ╰──────────────────╯
//                   │ No
//                   v
//     ╭─────────────┴─────────────╮          ╭──────────────────╮
//     │ After last logged period? │───No────>│ Period in N days │
//     ╰─────────────┬─────────────╯          ╰──────────────────╯
//                   │ Yes
//                   v
//     ╭─────────────┴────────────────╮       ╭──────────────────╮
//     │ Same cycle as logged period? │──Yes─>│ Period in N days │
//     ╰─────────────┬────────────────╯       ╰──────────────────╯
//                   │ No
//                   v
//     ╭─────────────┴──────────────╮         ╭──────────────────╮
//     │ Actual date in same cycle? │──Yes───>│ Period in N days │
//     ╰─────────────┬──────────────╯         ╰──────────────────╯
//                   │ No
//                   v
//        ╭──────────┴──────────────╮
//        │  Period late by N days  │
//        ╰─────────────────────────╯
//
class StatusText extends ConsumerWidget {
  final Forecast forecast;

  final ForecastCycle currentCycle;
  // note that this is not necessarily the same as the actual current
  // day in the calendar
  final ForecastDay selectedDay;

  const StatusText({
    super.key,
    required this.forecast,
    required this.currentCycle,
    required this.selectedDay,
  });

  bool _isAfterLastPeriod(Period lastPeriod) {
    return selectedDay.date.isAfter(lastPeriod.endDate);
  }

  bool _isLastPeriodInCycle(Period lastPeriod) {
    // if the start date of the current cycle is before the end of the last period
    // then the last period is in the current cycle
    return currentCycle.startDate.isBefore(lastPeriod.endDate);
  }

  bool _calendarInCycle(Period lastPeriod) {
    final now = DateTime.now();

    return now.isBetween(currentCycle.startDate, currentCycle.endDate);
  }

  bool _shouldShowLate(Period lastPeriod) {
    return _isAfterLastPeriod(lastPeriod) &&
        !_isLastPeriodInCycle(lastPeriod) &&
        !_calendarInCycle(lastPeriod);
  }

  String _buildStatus(List<Period> periods) {
    if (periods.isEmpty) {
      return t.home.status.missing;
    }

    final lastPeriod = periods.last;
    final date = selectedDay.date;

    if (date.isBetween(lastPeriod.startDate, lastPeriod.endDate)) {
      final difference = lastPeriod.endDate.difference(date);
      final days = difference.inDays + 1;

      return t.home.status.period(day: days);
    }

    if (_shouldShowLate(lastPeriod)) {
      final predictedStart = lastPeriod.startDate.add(
        Duration(days: forecast.days.length),
      );

      final difference = date.difference(predictedStart);
      final days = difference.inDays;

      return t.home.status.late(days: days);
    }

    final difference = lastPeriod.startDate.difference(date);
    final days = difference.inDays;

    return t.home.status.period_in(days: days);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final periods = ref.watch(periodsProvider);

    return periods.when(
      data: (periods) => Text(_buildStatus(periods)),
      error: (_, _) => Text("fuck"),
      loading: () => CircularProgressIndicator(),
    );
  }
}
