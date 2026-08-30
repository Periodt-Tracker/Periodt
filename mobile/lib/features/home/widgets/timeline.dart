import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:periodt/core/forcast/backend/base.dart';
import 'package:periodt/core/theme/app.dart';

final weekDayFormatter = DateFormat(DateFormat.ABBR_WEEKDAY);
final dayFormatter = DateFormat(DateFormat.DAY);

const dayHorizontalMargin = 4.0;
const dayInternalWidth = 54.0;
const dayWidth = dayInternalWidth + dayHorizontalMargin * 2;

class _SnappingSimulation extends Simulation {
  final Simulation parent;
  final ScrollMetrics position;
  final double itemWidth;

  late final double target;

  _SnappingSimulation(this.parent, this.position, this.itemWidth) {
    // Predict where the parent simulation would end
    final estimatedFinal = parent.x(double.infinity);

    final item = estimatedFinal / itemWidth;
    target = item.roundToDouble() * itemWidth;
  }

  @override
  double x(double time) {
    // Follow normal physics first
    final current = parent.x(time);

    // When parent is nearly done → snap
    if (parent.isDone(time)) {
      return target;
    }

    return current;
  }

  @override
  double dx(double time) => parent.dx(time);

  @override
  bool isDone(double time) => parent.isDone(time);
}

class SnapScrollPhysics extends ScrollPhysics {
  final double itemWidth;

  const SnapScrollPhysics({required this.itemWidth, super.parent});

  @override
  SnapScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return SnapScrollPhysics(
      itemWidth: itemWidth,
      parent: buildParent(ancestor),
    );
  }

  double _getSnapTarget(double pixels) {
    final item = pixels / itemWidth;
    return item.roundToDouble() * itemWidth;
  }

  @override
  Simulation? createBallisticSimulation(
    ScrollMetrics position,
    double velocity,
  ) {
    // Let parent handle normal fling
    final simulation = super.createBallisticSimulation(position, velocity);

    if (simulation == null) return null;

    return _SnappingSimulation(simulation, position, itemWidth);
  }
}

class CycleTimeline extends HookWidget {
  final ScrollController controller;
  final List<ForecastDay> days;

  const CycleTimeline({
    super.key,
    required this.days,
    required this.controller,
  });

  Color _getDayColour(ForecastDay day) {
    switch (day.phase) {
      case CyclePhase.period:
        return PeriodtTheme.period.primary;
      case CyclePhase.follicular:
        return PeriodtTheme.follicular.primary;
      case CyclePhase.ovulation:
        return PeriodtTheme.ovulation.primary;
      case CyclePhase.luteal:
        return PeriodtTheme.luteal.primary;
    }
  }

  Widget _cycleDay(ForecastDay day) {
    final dayNumber = weekDayFormatter.format(day.date);
    final dayName = dayFormatter.format(day.date);

    return Container(
      width: dayInternalWidth,
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: dayHorizontalMargin),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            dayName,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: PeriodtTheme.period.primary,
            ),
          ),
          Text(dayNumber, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: ListView(
        scrollDirection: Axis.horizontal,
        controller: controller,
        padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 2 - dayWidth / 2,
        ),
        children: days.map(_cycleDay).toList(),
      ),
    );
  }
}
