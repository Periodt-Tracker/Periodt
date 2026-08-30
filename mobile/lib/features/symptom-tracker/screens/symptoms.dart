// Copyright (c) Periodt. 2026
//
// This file is part of Periodt and licensed under the PSAL v1.0.
// See the LICENSE file for details.
//
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:periodt/core/database/models/daily-log.dart';
import 'package:periodt/core/database/provider.dart';
import 'package:periodt/core/database/services/daily-log.dart';
import 'package:periodt/core/form/widgets/wizard-controls.dart';
import 'package:periodt/features/symptom-tracker/data/form.dart';
import 'package:periodt/features/symptom-tracker/widgets/mood.dart';

class DailyLogScreen extends HookConsumerWidget {
  const DailyLogScreen({super.key});

  Future _handleSubmit(DailyLogBuilder builder, WidgetRef ref) async {
    final database = ref.read(databaseProvider);

    await database.createDailyLog(builder);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = GoRouter.of(context);

    final form = useDailyLogForm(onSubmit: (data) => _handleSubmit(data, ref));
    final today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close), // your custom icon
          onPressed: navigator.pop,
        ),
        centerTitle: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Daily Log",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              DateFormat.MMMMEEEEd().format(today),
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: form.pageController,
                  children: [
                    MoodFormPage(form),
                    MoodFormPage(form),
                    MoodFormPage(form),
                  ], // replace with actual form pages
                ),
              ),
              WizardControls(form),
            ],
          ),
        ),
      ),
    );
  }
}
