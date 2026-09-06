import 'package:app/core/forms/engine/field.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';

class PeriodtCalendarField<T> extends StatelessWidget {
  const PeriodtCalendarField({
    required this.value,
    required this.onChanged,
    required this.onTouched,
    required this.config,
    super.key,
  });

  final PeriodtInput<List<DateTime>, T, dynamic> value;

  final void Function(List<DateTime>) onChanged;
  final void Function() onTouched;

  // behold, the leaky abstraction
  //
  // if we ever we ever want to change the library
  final CalendarDatePicker2Config config;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CalendarDatePicker2(
          config: config,
          value: value.value,
          onValueChanged: onChanged,
        ),
      ],
    );
  }
}
