import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:periodt/core/utilities/range.dart';

class ReactiveRangePicker extends ReactiveFormField<Range<int>, Range<int>> {
  ReactiveRangePicker({
    super.key,
    required super.formControlName,
    required int min,
    required int max,
    required Widget Function(int) formatter,
    double itemExtent = 24,
    double magnification = 1.22,
    double squeeze = 1.2,
    bool useMagnifier = true,
    super.validationMessages,
    super.showErrors,
  }) : super(
         builder: (ReactiveFormFieldState<Range<int>, Range<int>> fieldState) {
           return _RangePickerInternal(
             fieldState: fieldState,
             min: min,
             max: max,
             formatter: formatter,
             itemExtent: itemExtent,
             magnification: magnification,
             squeeze: squeeze,
             useMagnifier: useMagnifier,
           );
         },
       );
}

class _RangePickerInternal extends StatefulWidget {
  final ReactiveFormFieldState<Range<int>, Range<int>> fieldState;
  final int min;
  final int max;
  final Widget Function(int) formatter;
  final double itemExtent;
  final double magnification;
  final double squeeze;
  final bool useMagnifier;

  const _RangePickerInternal({
    required this.fieldState,
    required this.min,
    required this.max,
    required this.formatter,
    required this.itemExtent,
    required this.magnification,
    required this.squeeze,
    required this.useMagnifier,
  });

  @override
  State<_RangePickerInternal> createState() => _RangePickerInternalState();
}

class _RangePickerInternalState extends State<_RangePickerInternal> {
  late FixedExtentScrollController _lowerController;
  late FixedExtentScrollController _upperController;

  @override
  void initState() {
    super.initState();
    final currentValue =
        widget.fieldState.value ?? Range(lower: widget.min, upper: widget.max);

    _lowerController = FixedExtentScrollController(
      initialItem: currentValue.lower - widget.min,
    );
    _upperController = FixedExtentScrollController(
      initialItem: currentValue.upper - (widget.min + 1),
    );
  }

  @override
  void dispose() {
    _lowerController.dispose();
    _upperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentValue =
        widget.fieldState.value ?? Range(lower: widget.min, upper: widget.max);

    final List<int> lowerItems = List.generate(
      widget.max - widget.min,
      (i) => widget.min + i,
    );
    final List<int> upperItems = List.generate(
      widget.max - widget.min,
      (i) => widget.min + 1 + i,
    );

    void setLower(int index) {
      final value = widget.min + index;
      final currentUpper = currentValue.upper;

      if (value >= currentUpper) {
        final newUpper = value + 1;
        widget.fieldState.didChange(Range(lower: value, upper: newUpper));

        _upperController.animateToItem(
          newUpper - (widget.min + 1),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        widget.fieldState.didChange(Range(lower: value, upper: currentUpper));
      }
    }

    void setUpper(int index) {
      final value = (widget.min + 1) + index;
      final currentLower = currentValue.lower;

      if (value <= currentLower) {
        final newLower = value - 1;
        widget.fieldState.didChange(Range(lower: newLower, upper: value));

        _lowerController.animateToItem(
          newLower - widget.min,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      } else {
        widget.fieldState.didChange(Range(lower: currentLower, upper: value));
      }
    }

    return InputDecorator(
      decoration: InputDecoration(
        errorText: widget.fieldState.errorText,
        border: InputBorder.none,
        contentPadding: EdgeInsets.zero,
      ),
      child: Row(
        children: [
          Expanded(
            child: CupertinoPicker(
              itemExtent: widget.itemExtent,
              scrollController: _lowerController,
              magnification: widget.magnification,
              squeeze: widget.squeeze,
              useMagnifier: widget.useMagnifier,
              onSelectedItemChanged: setLower,
              children: lowerItems.map(widget.formatter).toList(),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text("-"),
          ),
          Expanded(
            child: CupertinoPicker(
              itemExtent: widget.itemExtent,
              scrollController: _upperController,
              magnification: widget.magnification,
              squeeze: widget.squeeze,
              useMagnifier: widget.useMagnifier,
              onSelectedItemChanged: setUpper,
              children: upperItems.map(widget.formatter).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
