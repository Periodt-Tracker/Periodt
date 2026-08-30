import 'package:app/core/forms/engine/field.dart';
import 'package:flutter/material.dart';

class PeriodtTextField<Value, E> extends StatelessWidget {
  final PeriodtInput<String, Value, E> field;

  final ValueChanged<String> onChanged;
  final VoidCallback onTouched;

  final String? Function(E error) errorText;

  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final String? placeholder;

  final bool obscureText;

  const PeriodtTextField({
    required this.field,
    required this.onChanged,
    required this.onTouched,
    required this.errorText,
    this.placeholder,
    this.decoration,
    this.keyboardType,
    this.obscureText = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final err = field.displayError;

    return TextField(
      onChanged: onChanged,
      onTapOutside: (_) => onTouched(),
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: (decoration ?? const InputDecoration()).copyWith(
        errorText: err != null ? errorText(err) : null,
        hintText: placeholder,
      ),
    );
  }
}
