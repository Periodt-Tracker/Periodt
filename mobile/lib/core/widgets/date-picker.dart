import 'package:flutter/material.dart';
import 'package:periodt/core/theme/app.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DatePicker extends StatelessWidget {
  final DateRangePickerSelectionMode selectionMode;
  final DateRangePickerView view;
  final DateRangePickerSelectionChangedCallback? onSelectionChanged;
  final PickerDateRange? initialSelectedRange;
  final DateTime? maxDate;
  final DateTime? minDate;

  const DatePicker({
    super.key,
    required this.view,
    required this.selectionMode,
    this.onSelectionChanged,
    this.maxDate,
    this.minDate,
    this.initialSelectedRange,
  });

  @override
  Widget build(BuildContext context) {
    return SfTheme(
      data: SfThemeData(
        dateRangePickerThemeData: SfDateRangePickerThemeData(
          backgroundColor: Colors.white,
          headerBackgroundColor: Colors.white,
          viewHeaderTextStyle: TextStyle(color: Colors.grey),
          rangeSelectionColor: PeriodtTheme.period.primary,
        ),
      ),
      child: SfDateRangePicker(
        view: DateRangePickerView.month,
        selectionMode: selectionMode,
        minDate: minDate,
        maxDate: maxDate,
        onSelectionChanged: onSelectionChanged,
        initialSelectedRange: initialSelectedRange,

        rangeTextStyle: TextStyle(color: Colors.white),

        headerStyle: const DateRangePickerHeaderStyle(
          textAlign: TextAlign.center,
          textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),

        showTodayButton: false,

        monthCellStyle: const DateRangePickerMonthCellStyle(
          textStyle: TextStyle(color: Colors.black),
          todayTextStyle: TextStyle(color: Colors.black),
          disabledDatesTextStyle: TextStyle(
            color: Color.fromARGB(255, 215, 179, 179),
          ),
        ),

        extendableRangeSelectionDirection:
            ExtendableRangeSelectionDirection.forward,

        monthViewSettings: const DateRangePickerMonthViewSettings(
          enableSwipeSelection: false,
        ),

        showNavigationArrow: true,
        navigationMode: DateRangePickerNavigationMode.snap,
      ),
    );
  }
}
