import 'package:app/core/forms/engine/field.dart';
import 'package:flutter/material.dart';

class PeriodtTileField<TRaw, TVal, Err> extends StatelessWidget {
  const PeriodtTileField({
    required this.items,
    required this.field,
    required this.onChanged,
    required this.onTouched,
    required this.errorText,
    this.crossAxisCount = 2,
    required this.builder,
    super.key,
  });

  final PeriodtInput<Set<TRaw>, TVal, Err> field;

  final Set<TRaw> items;

  final ValueChanged<Set<TRaw>> onChanged;
  final VoidCallback onTouched;

  final String? Function(Err error) errorText;

  final int crossAxisCount;

  final Widget Function(BuildContext context, TRaw value, bool selected)
  builder;

  void _onChanged(TRaw value) {
    final newValue = field.value.contains(value)
        ? field.value.difference({value})
        : field.value.union({value});

    onChanged(newValue);
  }

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      children: items.map((value) {
        final selected = field.value.contains(value);

        return GestureDetector(
          onTap: () => _onChanged(value),
          child: builder(context, value, selected),
        );
      }).toList(),
    );
  }
}
