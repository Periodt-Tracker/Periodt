import 'package:app/core/forms/engine/field.dart';
import 'package:app/core/forms/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PeriodtIntegerField<T, E> extends StatelessWidget {
  const PeriodtIntegerField({
    required this.field,
    required this.onChanged,
    required this.onTouched,
    required this.errorText,
    this.decoration,
    this.placeholder,
    this.label,
    super.key,
  });

  final PeriodtInput<int?, T, E> field;

  final String? Function(E error) errorText;

  final InputDecoration? decoration;
  final String? placeholder;
  final String? label;

  final void Function(int) onChanged;
  final void Function() onTouched;

  void _onChanged(String value) {
    final parsed = int.tryParse(value);

    if (parsed != null) {
      onChanged(parsed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PeriodtTextField<T, E>(
      field: field,
      onChanged: _onChanged,
      onTouched: onTouched,
      placeholder: placeholder,
      label: label,
      errorText: errorText,
      decoration: decoration,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
    );
  }
}
