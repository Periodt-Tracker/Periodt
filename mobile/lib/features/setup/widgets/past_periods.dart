import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:periodt/core/widgets/calendar/scroll_calendar.dart';
import 'package:periodt/features/setup/data/pages/last_period.dart';

const defaultPrediction = 5;

class PeriodBuilder extends StatelessWidget {
  final DateTime startDate;

  const PeriodBuilder(this.startDate, {super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        "Add a Period",
        textAlign: TextAlign.center,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Text(
        "We will add a period starting on ${startDate.toLocal()}",
        textAlign: TextAlign.center,
      ),
      backgroundColor: Colors.white,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text("OK"),
        ),
      ],
    );
  }
}

class PastPeriods extends HookWidget {
  final LastPeriodPageState form;

  const PastPeriods(this.form, {super.key});

  Future _showDialog(BuildContext context, DateTime startDate) {
    return showDialog(
      context: context,
      builder: (context) => PeriodBuilder(startDate),
    );
  }

  @override
  Widget build(BuildContext context) {
    final periods = useState<List<DateTimeRange>>([]);

    int predictedLength() {
      if (periods.value.isEmpty) {
        return defaultPrediction - 1;
      }

      final lastPeriod = periods.value.last;
      return lastPeriod.end.difference(lastPeriod.start).inDays;
    }

    return ScrollableCalendar(
      ranges: periods.value,
      onDateTap: (date) {
        final prediction = predictedLength();

        for (var index = 0; index < periods.value.length; index++) {
          final range = periods.value[index];

          if (date == range.start) {
            // Tapped the start of an existing period, remove it
            periods.value = List.from(periods.value)..removeAt(index);
            return;
          }

          if (date.isAfter(range.start) && date.isBefore(range.end)) {
            // Tapped inside an existing period, remove it
            periods.value = List.from(periods.value)
              ..removeAt(index)
              ..add(DateTimeRange(start: range.start, end: date));

            return;
          }

          if (date.isAfter(range.end) &&
              date.difference(range.end).inDays <= 2) {
            // Tapped just after an existing period, extend it
            periods.value = List.from(periods.value)
              ..removeAt(index)
              ..add(DateTimeRange(start: range.start, end: date));

            return;
          }

          var predictedEnd = date.add(Duration(days: prediction));

          if (date.isBefore(range.start) &&
              predictedEnd.isAfter(range.start) &&
              predictedEnd.isBefore(range.end)) {
            // Tapped a date that would predictably overlap with the start of an existing period, extend it
            periods.value = List.from(periods.value)
              ..removeAt(index)
              ..add(DateTimeRange(start: date, end: predictedEnd));

            return;
          }
        }

        periods.value = [
          ...periods.value,
          DateTimeRange(
            start: date,
            end: date.add(Duration(days: prediction)),
          ),
        ];
      },
    );
  }
}
