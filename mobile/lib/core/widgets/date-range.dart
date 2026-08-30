import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:periodt/core/widgets/date-picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

String _text(ReactiveFormFieldState<PickerDateRange?, PickerDateRange?> field) {
  final value = field.value;

  if (value == null) {
    return "Select Date Range";
  }

  final start = value.startDate;
  final end = value.endDate;

  final formatter = DateFormat('MMM d');

  if (start == null && end == null) {
    return "Select Date Range";
  }

  final startText = start != null ? formatter.format(start) : "Unselected";
  final endText = end != null ? formatter.format(end) : "Unselected";

  return "$startText - $endText";
}

void _onSelectionChanged(
  DateRangePickerSelectionChangedArgs args,
  ReactiveFormFieldState<PickerDateRange?, PickerDateRange?> field,
) {
  final value = args.value;

  if (value is! PickerDateRange) {
    return;
  }

  field.didChange(value);
}

class ReactiveDateRangePicker
    extends ReactiveFormField<PickerDateRange?, PickerDateRange?> {
  ReactiveDateRangePicker({
    super.key,
    required String formControlName,
    DateTime? maxDate,
    DateTime? minDate,
    showTodayButton = false,
  }) : super(
         formControlName: formControlName,
         builder: (field) {
           return ElevatedButton.icon(
             icon: const Icon(Icons.calendar_today),
             label: Text(_text(field)),
             style: ElevatedButton.styleFrom(
               backgroundColor: Colors.grey,
               foregroundColor: Colors.black,
               shadowColor: Colors.transparent,
             ),
             onPressed: () {
               showDialog(
                 context: field.context,
                 builder: (context) {
                   return AlertDialog(
                     backgroundColor: Colors.white,
                     title: const Text(
                       "Select Date Range",
                       style: TextStyle(fontWeight: FontWeight.bold),
                       textAlign: TextAlign.center,
                     ),
                     content: SizedBox(
                       width: 380,
                       height: 300,
                       child: Column(
                         children: [
                           Expanded(
                             child: DatePicker(
                               view: DateRangePickerView.month,

                               initialSelectedRange: field.value,

                               selectionMode:
                                   DateRangePickerSelectionMode.range,
                               onSelectionChanged: (args) =>
                                   _onSelectionChanged(args, field),
                             ),
                           ),
                         ],
                       ),
                     ),
                     actions: [
                       TextButton(
                         onPressed: () => Navigator.pop(context),
                         child: const Text("Cancel"),
                       ),
                       TextButton(
                         onPressed: () => Navigator.pop(context),
                         child: const Text("OK"),
                       ),
                     ],
                   );
                 },
               );
             },
           );
         },
       );
}
