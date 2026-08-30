import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:periodt/core/theme/base/text.dart';

class LastPeriodForm extends StatelessWidget {
  const LastPeriodForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Text(
          "When was your last period?",
          style: TextStyle(
            fontSize: PeriodtText.xl,
            fontWeight: FontWeight.bold,
          ),
        ),
        // ReactiveDateRangePicker(formControlName: 'last_period'),
      ],
    );
  }
}
