import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';

class PinLockoutView extends StatefulWidget {
  const PinLockoutView({
    required this.until,
    required this.formatter,
    super.key,
  });

  final DateTime until;
  final Widget Function(Duration remaining) formatter;

  @override
  State<PinLockoutView> createState() => _PinLockoutViewState();
}

class _PinLockoutViewState extends State<PinLockoutView> {
  Timer? _timer;

  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _update();
  }

  @override
  void didUpdateWidget(PinLockoutView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.until != widget.until) {
      _update();
    }
  }

  void _update() {
    _timer?.cancel();

    final remaining = widget.until.difference(clock.now());

    if (remaining <= Duration.zero) {
      if (mounted) {
        setState(() {
          _remaining = Duration.zero;
        });
      }

      return;
    }

    if (mounted) {
      setState(() {
        _remaining = remaining;
      });
    }

    _scheduleNextUpdate(remaining);
  }

  void _scheduleNextUpdate(Duration remaining) {
    final delay = _nextUpdateDelay(remaining);

    _timer = Timer(delay, _update);
  }

  Duration _nextUpdateDelay(Duration remaining) {
    if (remaining <= const Duration(minutes: 1)) {
      final milliseconds = remaining.inMilliseconds % 1000;

      return Duration(
        milliseconds: milliseconds == 0 ? 1000 : milliseconds,
      );
    }

    if (remaining <= const Duration(hours: 1)) {
      // we're displaying minutes, so update at the next
      // whole-minute boundary.
      final seconds = remaining.inSeconds % 60;

      return Duration(
        seconds: seconds == 0 ? 60 : seconds,
      );
    }

    // we're displaying hours, so update at the next
    // whole-hour boundary.
    final minutes = remaining.inMinutes % 60;
    final seconds = remaining.inSeconds % 60;

    final secondsIntoHour = (minutes * 60) + seconds;

    return Duration(
      seconds: secondsIntoHour == 0
          ? const Duration(hours: 1).inSeconds
          : const Duration(hours: 1).inSeconds - secondsIntoHour,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_remaining <= Duration.zero) {
      return const SizedBox.shrink();
    }

    return widget.formatter(_remaining);
  }
}
