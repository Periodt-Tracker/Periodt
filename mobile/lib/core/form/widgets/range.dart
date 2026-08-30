import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:periodt/core/form/models/field.dart';
import 'package:periodt/core/utilities/range.dart';

class RangePicker extends HookWidget {
  final PeriodtField<Range<int>, String> formField;
  final int min;
  final int max;
  final Widget Function(int) formatter;
  final double itemExtent;
  final double magnification;
  final double squeeze;
  final bool useMagnifier;

  const RangePicker(
    this.formField, {
    super.key,
    required this.min,
    required this.max,
    required this.formatter,
    this.itemExtent = 24,
    this.magnification = 1.22,
    this.squeeze = 1.2,
    this.useMagnifier = true,
  }) : assert(min < max, 'min must be less than max');

  @override
  Widget build(BuildContext context) {
    final field = useValueListenable(formField);

    final lowerController = useFixedExtentScrollController(
      initialItem: field.value.lower - min,
    );
    final upperController = useFixedExtentScrollController(
      initialItem: field.value.upper - (min + 1),
    );

    // This single effect handles both syncing external data AND the
    // bounce-back animation if the user scrolls into the disabled zone.
    useEffect(() {
      final expectedLower = field.value.lower - min;
      final expectedUpper = field.value.upper - (min + 1);

      if (lowerController.hasClients &&
          lowerController.selectedItem != expectedLower) {
        lowerController.animateToItem(
          expectedLower,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
      if (upperController.hasClients &&
          upperController.selectedItem != expectedUpper) {
        upperController.animateToItem(
          expectedUpper,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
      return null;
    }, [field.value.lower, field.value.upper]);

    final List<int> lowerItems = List.generate(max - min, (i) => min + i);
    final List<int> upperItems = List.generate(max - min, (i) => min + 1 + i);

    void setLower(int index) {
      final value = min + index;
      final currentUpper = formField.value.value.upper;

      if (value >= currentUpper) {
        // Clamp it: Do not allow the lower value to reach or exceed the upper value
        formField.setValue(Range(lower: currentUpper - 1, upper: currentUpper));
      } else {
        formField.setValue(Range(lower: value, upper: currentUpper));
      }
    }

    void setUpper(int index) {
      final value = (min + 1) + index;
      final currentLower = formField.value.value.lower;

      if (value <= currentLower) {
        // Clamp it: Do not allow the upper value to reach or drop below the lower value
        formField.setValue(Range(lower: currentLower, upper: currentLower + 1));
      } else {
        formField.setValue(Range(lower: currentLower, upper: value));
      }
    }

    return Row(
      children: [
        Expanded(
          child: CupertinoPicker(
            itemExtent: itemExtent,
            scrollController: lowerController,
            magnification: magnification,
            squeeze: squeeze,
            useMagnifier: useMagnifier,
            onSelectedItemChanged: setLower,
            children: lowerItems.map((val) {
              final isDisabled = val >= field.value.upper;
              return Opacity(
                opacity: isDisabled
                    ? 0.3
                    : 1.0, // Visually grey out disabled items
                child: formatter(val),
              );
            }).toList(),
          ),
        ),
        const Text("-"),
        Expanded(
          child: CupertinoPicker(
            itemExtent: itemExtent,
            scrollController: upperController,
            magnification: magnification,
            squeeze: squeeze,
            useMagnifier: useMagnifier,
            onSelectedItemChanged: setUpper,
            children: upperItems.map((val) {
              final isDisabled = val <= field.value.lower;
              return Opacity(
                opacity: isDisabled
                    ? 0.3
                    : 1.0, // Visually grey out disabled items
                child: formatter(val),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
