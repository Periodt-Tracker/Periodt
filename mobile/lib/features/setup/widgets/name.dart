import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:periodt/core/form/widgets/text.dart';
import 'package:periodt/core/theme/base/text.dart';
import 'package:periodt/features/setup/data/controller.dart';

class NameForm extends HookWidget {
  const NameForm(this.form, {super.key});

  final SetupFormController form;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Text(
          "What is your name?",
          style: TextStyle(
            fontSize: PeriodtText.xl,
            fontWeight: FontWeight.bold,
          ),
        ),

        HookedTextField(field: form.user.name),

        // TextFormField(
        //   style: GoogleFonts.outfit(
        //     fontSize: 16,
        //     color: Colors.black,
        //     letterSpacing: 0, // fixes weird spacing
        //   ),
        //   decoration: InputDecoration(
        //     hintText: "Enter your name",
        //     border: const UnderlineInputBorder(),
        //     focusedBorder: UnderlineInputBorder(
        //       borderSide: BorderSide(
        //         color: PeriodtTheme.period.primary,
        //         width: 2,
        //       ),
        //     ),
        //   ),
        // ),
        Text(
          "This is used to personalize your experience. You can change it later in settings.",
          style: TextStyle(fontSize: PeriodtText.sm, color: Colors.black54),
        ),
      ],
    );
  }
}
