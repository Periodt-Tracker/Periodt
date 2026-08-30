import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:periodt/core/settings/notifier.dart';
import 'package:periodt/core/theme/base/text.dart';
import 'package:periodt/i18n/strings.g.dart';

enum GreetingType { generic, time }

class GreetingText extends ConsumerWidget {
  const GreetingText({super.key});

  GreetingType _getRandomGreetingType() {
    // final random = Random();
    // final index = random.nextInt(GreetingType.values.length);

    // return GreetingType.values[index];

    return GreetingType.generic;
  }

  String _getGreeting(String name) {
    final type = _getRandomGreetingType();

    switch (type) {
      case GreetingType.generic:
        return t.home.greeting.generic(name: name);

      case GreetingType.time:
        final hour = DateTime.now().hour;

        if (hour < 12) {
          return t.home.greeting.morning(name: name);
        } else if (hour < 18) {
          return t.home.greeting.afternoon(name: name);
        } else {
          return t.home.greeting.evening(name: name);
        }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifier.select((s) => s.user));

    return Expanded(
      child: Text(
        _getGreeting(settings.name ?? "unknown"),
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: PeriodtText.display,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          height: 1,
        ),
      ),
    );
  }
}
