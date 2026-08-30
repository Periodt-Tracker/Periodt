import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:periodt/core/forcast/backend/base.dart';
import 'package:periodt/core/theme/app.dart';
import 'package:periodt/gen/assets.gen.dart';

const size = Size(250, 250);

class Phase {
  final int days;
  final Color color;

  const Phase({required this.days, required this.color});
}

class CycleData {
  final int period;
  final int follicular;
  final int ovulation;
  final int luteal;

  CycleData({
    required this.period,
    required this.follicular,
    required this.ovulation,
    required this.luteal,
  });

  int get days => period + follicular + ovulation + luteal;
}

class _WheelPainter extends CustomPainter {
  final double angle;
  final int segments;
  final CycleData data;

  _WheelPainter({
    required this.angle,
    required this.segments,
    required this.data,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(angle);
    canvas.translate(-center.dx, -center.dy);

    canvas.drawCircle(center, radius + 16, Paint()..color = Colors.white);
    canvas.drawCircle(
      center,
      radius - 16,
      Paint()..color = PeriodtTheme.period.light,
    );

    final gap = 0.2;
    final total = data.days;

    final phases = [
      Phase(days: data.period, color: PeriodtTheme.period.primary),
      Phase(days: data.follicular, color: PeriodtTheme.follicular.primary),
      Phase(days: data.ovulation, color: PeriodtTheme.ovulation.primary),
      Phase(days: data.luteal, color: PeriodtTheme.luteal.primary),
    ];

    double startAngle = -pi / 2;
    for (final phase in phases) {
      final sweep = 2 * pi * (phase.days / total) - gap;

      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round
        ..color = phase.color;

      canvas.drawArc(rect, startAngle, sweep, false, paint);

      startAngle += sweep + gap;
    }

    canvas.restore();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is _WheelPainter &&
        other.angle == angle &&
        other.segments == segments &&
        other.data == data;
  }

  @override
  int get hashCode => Object.hash(angle, segments, data);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate != this;
}

class CycleWheel extends HookWidget {
  final double rotation;
  final List<ForecastCycle> cycles;
  final void Function(double)? onRotationChanged;

  const CycleWheel({
    super.key,
    required this.rotation,
    required this.cycles,
    required this.onRotationChanged,
  });

  int? get cycleIndex {
    final totalCycles = cycles.length;

    if (totalCycles == 0) {
      return null;
    }

    double progress = rotation / (2 * pi);
    return progress.round().clamp(0, totalCycles - 1);
  }

  ForecastCycle? get currentCycle {
    final index = cycleIndex;

    if (index == null) {
      return null;
    }

    return cycles[index];
  }

  int? get dayIndex {
    final cycle = currentCycle;

    if (cycle == null) {
      return null;
    }

    final internalRotation = rotation % (2 * pi);
    final progress = internalRotation / (2 * pi);

    final totalDays = cycle.days.length;

    final rawDay = (progress * totalDays);

    return rawDay.round().clamp(0, totalDays - 1);
  }

  ForecastDay? get currentDay {
    final index = dayIndex;

    if (index == null) {
      return null;
    }

    final cycle = currentCycle;

    if (cycle == null) {
      return null;
    }

    return cycle.days[index];
  }

  String get text {
    final cycle = currentCycle;
    final index = dayIndex;

    if (cycle == null || index == null) {
      return "No forecast";
    }

    final day = cycle.days[index];

    if (day.phase == CyclePhase.period) {
      return "Day ${index + 1} of period";
    } else {
      return "Period in ${cycle.days.length - index} days";
    }
  }

  @override
  Widget build(BuildContext context) {
    if (cycleIndex == null) {
      return Container();
    }

    final center = size.center(Offset.zero);

    final localRotation = useState<double>(rotation);
    final prevAngle = useState<double?>(null);

    useEffect(() {
      localRotation.value = rotation;
      return null;
    }, [rotation]);

    final data = CycleData(period: 5, follicular: 5, ovulation: 3, luteal: 14);

    final controller = useAnimationController(
      duration: const Duration(milliseconds: 200),
    );

    double normalizeAngle(double angle) {
      angle %= (2 * pi);
      if (angle < 0) angle += 2 * pi;
      return angle;
    }

    double shortestAngleDelta(double from, double to) {
      double delta = (to - from) % (2 * pi);

      if (delta > pi) {
        delta -= 2 * pi;
      } else if (delta < -pi) {
        delta += 2 * pi;
      }

      return normalizeAngle(delta);
    }

    double snapRotationToDay(double rotation, int totalDays) {
      final anglePerDay = 2 * pi / totalDays;

      final normalized = normalizeAngle(rotation);

      final day = (normalized / anglePerDay).round();

      return day * anglePerDay;
    }

    void snapAnimated() {
      final target = snapRotationToDay(localRotation.value, data.days);
      final current = localRotation.value;

      final delta = shortestAngleDelta(current, target);
      final end = current + delta;

      final animation = Tween<double>(
        begin: localRotation.value,
        end: end,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOut));

      controller
        ..reset()
        ..forward();

      controller.addListener(() {
        localRotation.value = animation.value;
        onRotationChanged?.call(localRotation.value);
      });
    }

    return GestureDetector(
      onPanStart: (details) => prevAngle.value = atan2(
        details.localPosition.dy - center.dy,
        details.localPosition.dx - center.dx,
      ),
      onPanUpdate: (details) {
        final currentAngle = atan2(
          details.localPosition.dy - center.dy,
          details.localPosition.dx - center.dx,
        );
        final delta = currentAngle - prevAngle.value!;
        localRotation.value = normalizeAngle(localRotation.value + delta);
        prevAngle.value = currentAngle;

        onRotationChanged?.call(localRotation.value);
      },
      onPanEnd: (_) => snapAnimated(),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: size,
            painter: _WheelPainter(
              segments: 4,
              angle: localRotation.value,
              data: data,
            ),
          ),
          Column(
            children: [
              Image.asset(
                Assets.blobs.welcome.welcome512.path,
                width: 128,
                height: 128,
                fit: BoxFit.contain,
              ),
              Text(text),
            ],
          ),
        ],
      ),
    );
  }
}
