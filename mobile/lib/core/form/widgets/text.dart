import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:periodt/core/form/models/field.dart';

class HookedTextField extends HookWidget {
  final PeriodtField<String, String> field;

  const HookedTextField({super.key, required this.field});

  @override
  Widget build(BuildContext context) {
    final state = useListenable(field);
    final controller = useTextEditingController(text: state.field);

    useEffect(() {
      if (controller.text != state.field) {
        controller.text = state.field;

        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: controller.text.length),
        );
      }
      return null;
    }, [state.field]);

    return TextField(
      onChanged: (value) => state.setValue(value),
      decoration: InputDecoration(errorText: state.displayError),
    );
  }
}
