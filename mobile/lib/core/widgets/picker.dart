import 'package:flutter/cupertino.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactivePicker<T> extends ReactiveFormField<T, T> {
  ReactivePicker({
    super.key,
    required List<T> values,
    required String formControlName,
    required Widget Function(T) formatter,
    double itemExtent = 24,
    double magnification = 1.22,
    double squeeze = 1.2,
    bool useMagnifier = true,
    T? initialValue,
    FixedExtentScrollController? scrollController,
  }) : super(
         formControlName: formControlName,
         builder: (field) {
           return CupertinoPicker(
             itemExtent: itemExtent,
             magnification: magnification,
             squeeze: squeeze,
             useMagnifier: useMagnifier,
             onSelectedItemChanged: (index) {
               field.didChange(values[index]);
             },
             scrollController: scrollController,
             children: values.map(formatter).toList(),
           );
         },
       );

  @override
  ReactiveFormFieldState<T, T> createState() => ReactiveFormFieldState<T, T>();
}
