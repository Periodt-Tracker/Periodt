import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:periodt/core/form/widgets/range.dart';
import 'package:periodt/core/theme/base/text.dart';
import 'package:periodt/core/utilities/list.dart';
import 'package:periodt/features/setup/data/controller.dart';

final lowerRange = range(1, 13);
final upperRange = range(2, 14);

class PeriodDurationForm extends StatelessWidget {
  final SetupFormController form;

  const PeriodDurationForm(this.form, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24,
      children: [
        Text(
          "How long does your period usually last?",
          style: TextStyle(
            fontSize: PeriodtText.xl,
            fontWeight: FontWeight.bold,
          ),
        ),

        SizedBox(
          height: 100,
          child: RangePicker(
            form.periodLength.periodLength,
            min: 1,
            max: 13,
            formatter: (n) => Text(
              "$n Days",
              style: TextStyle(
                fontSize: PeriodtText.base,
                fontFamily: Theme.of(context).textTheme.bodyMedium!.fontFamily,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
