import 'package:app/app/theme/base.dart';
import 'package:app/core/forms/engine/field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PeriodtTextField<Value, E> extends StatelessWidget {
  const PeriodtTextField({
    required this.field,
    required this.onChanged,
    required this.onTouched,
    required this.errorText,
    this.placeholder,
    this.decoration,
    this.keyboardType,
    this.label,
    this.inputFormatters,
    this.obscureText = false,
    super.key,
  });

  final PeriodtInput<Object?, Value, E> field;

  final ValueChanged<String> onChanged;
  final VoidCallback onTouched;

  final String? Function(E error) errorText;

  final InputDecoration? decoration;
  final TextInputType? keyboardType;
  final String? placeholder;
  final String? label;
  final List<TextInputFormatter>? inputFormatters;

  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final err = field.displayError;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        TextField(
          onChanged: onChanged,
          onTapOutside: (_) => onTouched(),
          keyboardType: keyboardType,
          obscureText: obscureText,
          inputFormatters: inputFormatters,
          decoration: (decoration ?? const InputDecoration()).copyWith(
            errorText: err != null ? errorText(err) : null,
            hintText: placeholder,
          ),
        ),
        if (label != null) ...[
          const SizedBox(height: 4),
          Text(label!, style: PeriodtTheme.light.textTheme.bodyMedium),
        ],
      ],
    );
  }
}
