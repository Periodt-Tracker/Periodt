import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:periodt/core/forcast/provider.dart';
import 'package:periodt/core/widgets/skeleton/pulse.dart';

class PhaseDetails extends ConsumerWidget {
  const PhaseDetails({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDayProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: selectedDay.when(
        data: (day) => Text("${day?.phase.toString()}"),
        error: (_, _) => Text("Error"),
        loading: () =>
            PulseBox(width: double.infinity, height: 256, borderRadius: 32),
      ),
    );
  }
}
