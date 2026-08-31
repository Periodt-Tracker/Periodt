import 'package:app/core/forms/engine/field.dart';
import 'package:flutter/cupertino.dart';

class PeriodtDateField<T, E> extends StatelessWidget {
  const PeriodtDateField({
    required this.field,
    required this.onChanged,
    required this.onTouched,
    required this.errorText,
    this.maximumDate,
    this.minimumDate,
    this.mode = CupertinoDatePickerMode.date,
    super.key,
  });

  final PeriodtInput<DateTime?, T, E> field;

  final String? Function(E error) errorText;

  final void Function(DateTime) onChanged;
  final void Function() onTouched;

  final CupertinoDatePickerMode mode;

  final DateTime? maximumDate;
  final DateTime? minimumDate;

  @override
  Widget build(BuildContext context) {
    final initialDate = field.value ?? DateTime.now();

    return CupertinoDatePicker(
      initialDateTime: initialDate,
      onDateTimeChanged: onChanged,
      maximumDate: maximumDate,
      minimumDate: minimumDate,
      mode: CupertinoDatePickerMode.date,
    );
  }
}
