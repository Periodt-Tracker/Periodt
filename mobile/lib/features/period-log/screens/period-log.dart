import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:periodt/core/database/provider.dart';
import 'package:periodt/core/database/services/period.dart';
import 'package:periodt/core/theme/app.dart';

class PeriodLogScreen extends HookConsumerWidget {
  const PeriodLogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navigator = GoRouter.of(context);

    final selection = useState<List<DateTime?>>([null, null]);
    final periods = ref.watch(periodsProvider);

    void submit(List<DateTime?> value, WidgetRef ref) async {
      final database = ref.read(databaseProvider);

      if (value.length != 2) {
        return;
      }

      final startDate = value[0];
      final endDate = value[1];

      if (startDate == null || endDate == null) {
        return;
      }

      await database.addPeriod((startDate: startDate, endDate: endDate));

      navigator.pop();
    }

    void handleValueChanged(List<DateTime?> value) {
      final previous = selection.value;
      final cleanedValue = value.whereType<DateTime>().toList();

      if (cleanedValue.isEmpty) {
        selection.value = [null, null];
        return;
      }

      if (cleanedValue.length == 1) {
        final [lower] = cleanedValue;
        final newUpper = lower.add(Duration(days: 4));

        selection.value = [lower, newUpper];
        return;
      }

      if (value == previous) {
        selection.value = [null, null];
        return;
      }

      final [lower, upper] = cleanedValue;
      selection.value = [lower, upper];
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Log a period'),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CalendarDatePicker2(
                config: CalendarDatePicker2Config(
                  calendarType: CalendarDatePicker2Type.range,
                  centerAlignModePicker: true,
                  calendarViewMode: CalendarDatePicker2Mode.scroll,
                  rangeBidirectional: true,
                  lastDate: DateTime.now(),
                ),
                value: selection.value,
                onValueChanged: handleValueChanged,
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () => submit(selection.value, ref),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PeriodtTheme.period.primary,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: Text("Save"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
