// Copyright (c) Periodt. 2026
//
// This file is part of Periodt and licensed under the PSAL v1.0.
// See the LICENSE file for details.
//
import 'package:flutter/material.dart';
import 'package:periodt/core/conditions/constants.dart';
import 'package:periodt/core/form/widgets/select_inline.dart';
import 'package:periodt/features/symptom-tracker/data/form.dart';

class MoodFormPage extends StatelessWidget {
  final DailyLogForm form;

  const MoodFormPage(this.form, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        SelectGrid(
          options: Mood.values,
          field: form.mood.moodType,
          scrollDirection: Axis.vertical,
          itemBuilder: (mood) => Text(mood.toString()),
        ),
      ],
    );
  }
}
