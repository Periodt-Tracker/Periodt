// Copyright (c) Periodt. 2026
//
// This file is part of Periodt and licensed under the PSAL v1.0.
// See the LICENSE file for details.
//
import 'package:flutter/material.dart';
import 'package:periodt/features/symptom-tracker/data/form.dart';

class DischardgeLogForm extends StatelessWidget {
  final DailyLogForm form;

  const DischardgeLogForm({super.key, required this.form});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Discharge",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        // Add form fields here using form.colour, form.odor, form.consistency
      ],
    );
  }
}
