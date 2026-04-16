import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:periodt/core/form/models/field.dart';
import 'package:periodt/core/utilities/list.dart';
import 'package:periodt/core/utilities/range.dart';

class RangePicker extends HookWidget {
  final PeriodtField<Range<int>, String> field;

  final FixedExtentScrollController _lowerController =
      FixedExtentScrollController();
  final FixedExtentScrollController _upperController =
      FixedExtentScrollController();

  final int min;
  final int max;

  final Widget Function(int) formatter;
  final double itemExtent;
  final double magnification;
  final double squeeze;
  final bool useMagnifier;

  late final List<int> _lowerItems = range(min, max - 1);
  late final List<int> _upperItems = range(min + 1, max);

  RangePicker(
    this.field, {
    super.key,
    required this.min,
    required this.max,
    required this.formatter,
    this.itemExtent = 24,
    this.magnification = 1.22,
    this.squeeze = 1.2,
    this.useMagnifier = true,
  }) : assert(min < max, 'min must be less than max');

  void setLower(int index) {
    final upper = field.field.upper;
    final value = index + min;

    if (value >= upper) {
      final newUpper = value + 1;
      field.setValue(Range(lower: value, upper: newUpper));

      _upperController.animateToItem(
        newUpper - min - 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      field.setValue(Range(lower: value, upper: upper));
    }
  }

  void setUpper(int index) {
    final lower = field.field.lower;
    final value = index + min + 1;

    if (value <= lower) {
      final newLower = value - 1;
      field.setValue(Range(lower: newLower, upper: value));

      _lowerController.animateToItem(
        newLower - min,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      field.setValue(Range(lower: lower, upper: value));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CupertinoPicker(
            itemExtent: itemExtent,
            scrollController: _lowerController,
            magnification: magnification,
            squeeze: squeeze,
            useMagnifier: useMagnifier,
            onSelectedItemChanged: setLower,
            children: _lowerItems.map(formatter).toList(),
          ),
        ),
        const Text("-"),
        Expanded(
          child: CupertinoPicker(
            itemExtent: itemExtent,
            scrollController: _upperController,
            magnification: magnification,
            squeeze: squeeze,
            useMagnifier: useMagnifier,
            onSelectedItemChanged: setUpper,
            children: _upperItems.map(formatter).toList(),
          ),
        ),
      ],
    );
  }
}
