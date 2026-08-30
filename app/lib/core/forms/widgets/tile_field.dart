import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:app/core/forms/engine/field.dart';
import 'package:flutter/material.dart';

class TileField<TRaw, TVal, Err> extends StatelessWidget {
  const TileField({
    required this.items,
    required this.field,
    required this.onChanged,
    required this.onTouched,
    required this.errorText,
    this.crossAxisCount = 2,
    required this.builder,
    super.key,
  });

  final PeriodtInput<TRaw, TVal, Err> field;

  final List<TRaw> items;

  final ValueChanged<TRaw> onChanged;
  final VoidCallback onTouched;

  final String? Function(Err error) errorText;

  final int crossAxisCount;

  final Widget Function(BuildContext context, TRaw value, bool selected)
  builder;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      children: items.map((value) {
        final selected = field.value == value;

        return GestureDetector(
          onTap: () => onChanged(value),
          child: builder(context, value, selected),
        );
      }).toList(),
    );
  }
}
