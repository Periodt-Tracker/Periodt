import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:periodt/features/home/data/cycle_controller.dart';

class PeriodTracker extends HookWidget {
  final int currentDay;
  final ScrollController controller;

  const PeriodTracker({
    super.key,
    required this.currentDay,
    required this.controller,
  });

  void animateToToday() {
    controller.animateToDay(currentDay);
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: animateToToday,
      child: Text("Go to Today"),
    );
  }
}
