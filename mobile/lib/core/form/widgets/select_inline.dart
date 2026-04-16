import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:periodt/core/form/models/field.dart';
import 'package:periodt/core/form/widgets/select-tile.dart';

class SelectGrid<T> extends HookWidget {
  final PeriodtField<T?, String> field;
  final List<T> options;
  final Axis scrollDirection;
  final int crossAxisCount;
  final Widget Function(T option) itemBuilder;

  const SelectGrid({
    super.key,
    required this.options,
    required this.field,
    required this.scrollDirection,
    this.crossAxisCount = 2,
    required this.itemBuilder,
  });

  T? get selectedOption => field.field;

  void handleTap(T option) {
    if (selectedOption == option) {
      field.setValue(null);
      return;
    }

    field.setValue(option);
  }

  @override
  Widget build(BuildContext context) {
    final field = useListenable(this.field);

    return Expanded(
      child: GridView.builder(
        scrollDirection: scrollDirection,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1,
        ),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final option = options[index];

          return SelectTile(
            onTap: () => handleTap(option),
            selected: option == selectedOption,
            child: Text(option.toString()),
          );
        },
      ),
    );
  }
}
