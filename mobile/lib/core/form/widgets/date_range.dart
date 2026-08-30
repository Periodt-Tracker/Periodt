import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:periodt/core/form/models/field.dart';

const List<DateTime?> defaultRange = [];

typedef DateRangeTransformer =
    List<DateTime?>? Function(
      List<DateTime?> newValue,
      List<DateTime?>? previous,
    );

class DateRangePicker extends HookWidget {
  final PeriodtField<List<DateTime?>?, String> formField;
  final DateRangeTransformer? transformer;

  const DateRangePicker({super.key, required this.formField, this.transformer});

  @override
  Widget build(BuildContext context) {
    final field = useValueListenable(formField);

    return CalendarDatePicker2(
      config: CalendarDatePicker2Config(
        calendarType: CalendarDatePicker2Type.range,
        calendarViewMode: CalendarDatePicker2Mode.day,
      ),
      onValueChanged: (dates) {
        final transformed = transformer?.call(dates, field.value);

        formField.setValue(transformed ?? dates);
      },
      value: field.value ?? defaultRange,
    );
  }
}
