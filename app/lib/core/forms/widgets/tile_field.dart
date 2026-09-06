import 'package:app/core/forms/engine/field.dart';
import 'package:flutter/material.dart';

class PeriodtTileField<TRaw, TVal, Err> extends StatelessWidget {
  const PeriodtTileField({
    required this.items,
    required this.field,
    required this.onChanged,
    required this.onTouched,
    required this.errorText,
    required this.builder,
    this.crossAxisSpacing = 0,
    this.mainAxisSpacing = 0,
    this.crossAxisCount = 2,
    super.key,
  });

  final PeriodtInput<Set<TRaw>, TVal, Err> field;

  final Set<TRaw> items;

  final ValueChanged<Set<TRaw>> onChanged;
  final VoidCallback onTouched;

  final String? Function(Err error) errorText;

  final int crossAxisCount;
  final double crossAxisSpacing;
  final double mainAxisSpacing;

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
      mainAxisSpacing: mainAxisSpacing,
      crossAxisSpacing: crossAxisSpacing,
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
