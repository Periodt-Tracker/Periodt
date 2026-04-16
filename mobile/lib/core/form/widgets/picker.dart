import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:periodt/core/form/models/field.dart';

class PickerField<T> extends HookWidget {
  final PeriodtField<T, String> field;
  final FixedExtentScrollController _controller = FixedExtentScrollController();

  final List<T> items;
  final Widget Function(T) formatter;
  final double itemExtent;
  final double magnification;
  final double squeeze;
  final bool useMagnifier;

  PickerField({
    super.key,
    required this.field,
    required this.items,
    required this.formatter,
    this.itemExtent = 24,
    this.magnification = 1.22,
    this.squeeze = 1.2,
    this.useMagnifier = true,
  });

  @override
  Widget build(BuildContext context) {
    final state = useListenable(field);

    useEffect(() {
      final index = items.indexOf(state.field);

      if (index == -1) {
        throw Exception('Value ${state.value} not found in items');
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.animateToItem(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });

      return null;
    }, [state.value]);

    return CupertinoPicker(
      itemExtent: itemExtent,
      scrollController: _controller,
      magnification: magnification,
      squeeze: squeeze,
      useMagnifier: useMagnifier,
      onSelectedItemChanged: (value) => state.setValue(items[value]),
      children: items.map(formatter).toList(),
    );
  }
}
