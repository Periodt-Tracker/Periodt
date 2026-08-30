import 'package:flutter/material.dart';

/// Defines the rendering state of a specific day in relation to the provided date ranges.
enum DayRangeState { none, start, inRange, end, single }

class ScrollableCalendar extends StatefulWidget {
  final DateTime? initialMonth;
  final List<DateTimeRange> ranges;
  final void Function(DateTime date)? onDateTap;
  final void Function(DateTime date)? onDateLongPress;

  const ScrollableCalendar({
    super.key,
    this.initialMonth,
    this.ranges = const [],
    this.onDateTap,
    this.onDateLongPress,
  });

  @override
  State<ScrollableCalendar> createState() => _ScrollableCalendarState();
}

class _ScrollableCalendarState extends State<ScrollableCalendar> {
  late final DateTime _baseMonth;
  final Key _centerKey = const ValueKey('calendar-center');

  @override
  void initState() {
    super.initState();
    // Normalize initial date to the 1st of the month at midnight
    final initial = widget.initialMonth ?? DateTime.now();
    _baseMonth = CalendarDateUtils.normalizeToMonth(initial);
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      center: _centerKey,
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Past months (scrolls upwards)
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            // index 0 -> 1 month ago, index 1 -> 2 months ago
            final monthOffset = -(index + 1);
            return _buildMonthItem(context, monthOffset);
          }),
        ),
        // Future and current months (scrolls downwards)
        SliverList(
          key: _centerKey,
          delegate: SliverChildBuilderDelegate((context, index) {
            // index 0 -> current, index 1 -> next month
            return _buildMonthItem(context, index);
          }),
        ),
      ],
    );
  }

  Widget _buildMonthItem(BuildContext context, int monthOffset) {
    final targetMonth = CalendarDateUtils.addMonths(_baseMonth, monthOffset);
    return MonthView(
      targetMonth: targetMonth,
      ranges: widget.ranges,
      onDateTap: widget.onDateTap,
      onDateLongPress: widget.onDateLongPress,
    );
  }
}

class MonthView extends StatelessWidget {
  final DateTime targetMonth;
  final List<DateTimeRange> ranges;
  final void Function(DateTime date)? onDateTap;
  final void Function(DateTime date)? onDateLongPress;

  const MonthView({
    super.key,
    required this.targetMonth,
    required this.ranges,
    this.onDateTap,
    this.onDateLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);
    final theme = Theme.of(context);

    final daysInMonth = CalendarDateUtils.getDaysInMonth(
      targetMonth.year,
      targetMonth.month,
    );

    // Locale-aware first day of week (Sunday = 0, Monday = 1, etc.)
    final firstDayOfWeek = localizations.firstDayOfWeekIndex;

    // Calculate empty leading cells based on the first weekday of this month
    final firstDayOfMonth = DateTime(targetMonth.year, targetMonth.month, 1);

    // DateTime.weekday is 1 (Mon) to 7 (Sun). Convert to 0 (Sun) to 6 (Sat)
    final firstWeekdayStandard = firstDayOfMonth.weekday % 7;
    int leadingEmptyCells = firstWeekdayStandard - firstDayOfWeek;
    if (leadingEmptyCells < 0) {
      leadingEmptyCells += 7;
    }

    return RepaintBoundary(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Month Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Text(
                localizations.formatMonthYear(targetMonth),
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Weekday Labels Row
            Row(
              children: List.generate(7, (index) {
                // Shift based on locale's first day of week
                final dayIndex = (firstDayOfWeek + index) % 7;
                // MaterialLocalizations provides 1-indexed weekday abbreviations
                // where 1 = Sunday, 2 = Monday ... 7 = Saturday.
                final label = localizations.narrowWeekdays[dayIndex];
                return Expanded(
                  child: Center(
                    child: Text(
                      label,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 8),

            // Grid of days
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                childAspectRatio: 1.0,
                crossAxisSpacing: 0,
                mainAxisSpacing: 0,
              ),
              itemCount: leadingEmptyCells + daysInMonth,
              itemBuilder: (context, index) {
                if (index < leadingEmptyCells) {
                  return const SizedBox.shrink(); // Empty grid cell
                }

                final dayNumber = index - leadingEmptyCells + 1;
                final currentDate = DateTime(
                  targetMonth.year,
                  targetMonth.month,
                  dayNumber,
                );

                final state = CalendarDateUtils.getDayRangeState(
                  currentDate,
                  ranges,
                );
                final isToday = CalendarDateUtils.isSameDay(
                  currentDate,
                  DateTime.now(),
                );

                return DayTile(
                  date: currentDate,
                  state: state,
                  isToday: isToday,
                  onTap: onDateTap,
                  onLongPress: onDateLongPress,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DayTile extends StatelessWidget {
  final DateTime date;
  final DayRangeState state;
  final bool isToday;
  final void Function(DateTime)? onTap;
  final void Function(DateTime)? onLongPress;

  const DayTile({
    super.key,
    required this.date,
    required this.state,
    this.isToday = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Determine visuals based on state
    Color? backgroundColor;
    Color? textColor = colorScheme.onSurface;
    BoxShape shape = BoxShape.circle;
    BorderRadius? borderRadius;

    switch (state) {
      case DayRangeState.single:
        backgroundColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        break;
      case DayRangeState.start:
        backgroundColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        shape = BoxShape.rectangle;
        borderRadius = const BorderRadius.horizontal(left: Radius.circular(50));
        break;
      case DayRangeState.end:
        backgroundColor = colorScheme.primary;
        textColor = colorScheme.onPrimary;
        shape = BoxShape.rectangle;
        borderRadius = const BorderRadius.horizontal(
          right: Radius.circular(50),
        );
        break;
      case DayRangeState.inRange:
        backgroundColor = colorScheme.primaryContainer;
        textColor = colorScheme.onPrimaryContainer;
        shape = BoxShape.rectangle;
        break;
      case DayRangeState.none:
      default:
        backgroundColor = Colors.transparent;
        break;
    }

    // Wrap in standard visual layouts based on shape
    Widget tileContent = Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: borderRadius != null ? BoxShape.rectangle : shape,
        borderRadius: borderRadius,
        border: isToday && state == DayRangeState.none
            ? Border.all(color: colorScheme.primary, width: 1.5)
            : null,
      ),
      child: Center(
        child: Text(
          '${date.day}',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: isToday || state != DayRangeState.none
                ? FontWeight.bold
                : FontWeight.normal,
          ),
        ),
      ),
    );

    // Apply semantics and gestures
    return Semantics(
      label: MaterialLocalizations.of(context).formatFullDate(date),
      button: true,
      selected: state != DayRangeState.none,
      child: InkWell(
        customBorder: borderRadius != null
            ? RoundedRectangleBorder(borderRadius: borderRadius)
            : const CircleBorder(),
        onTap: onTap != null ? () => onTap!(date) : null,
        onLongPress: onLongPress != null ? () => onLongPress!(date) : null,
        child: tileContent,
      ),
    );
  }
}

/// Pure functions handling date logic, math, and range intersection.
class CalendarDateUtils {
  /// Strips time components safely to avoid timezone/DST shifting issues
  static DateTime normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Normalizes to the first day of the month
  static DateTime normalizeToMonth(DateTime date) {
    return DateTime(date.year, date.month, 1);
  }

  /// Safe month arithmetic (handles leap years and month boundaries)
  static DateTime addMonths(DateTime monthDate, int offset) {
    final normalized = normalizeToMonth(monthDate);
    // Integer division to find year shift, modulo for month shift
    final yearOffset = (normalized.month - 1 + offset) ~/ 12;
    var newMonth = (normalized.month + offset) % 12;
    if (newMonth == 0) newMonth = 12; // Modulo 12 yields 0 for December

    // Adjust year if modulo result was negative (scrolling backward)
    final adjustedYear =
        normalized.year +
        yearOffset +
        ((normalized.month - 1 + offset) < 0 ? -1 : 0);

    return DateTime(adjustedYear, newMonth, 1);
  }

  /// Returns the actual number of days in a given month and year
  static int getDaysInMonth(int year, int month) {
    // Setting day to 0 of the *next* month yields the last day of the *current* month.
    return DateTime(year, month + 1, 0).day;
  }

  /// Checks if two dates fall on the exact same calendar day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Evaluates a date against a list of ranges, resolving merge rules.
  static DayRangeState getDayRangeState(
    DateTime date,
    List<DateTimeRange> ranges,
  ) {
    if (ranges.isEmpty) return DayRangeState.none;

    final target = normalizeDate(date);
    DayRangeState resolvedState = DayRangeState.none;

    for (final range in ranges) {
      final start = normalizeDate(range.start);
      final end = normalizeDate(range.end);

      if (isSameDay(target, start) && isSameDay(target, end)) {
        return DayRangeState.single; // Highest priority, exit early
      }

      if (isSameDay(target, start)) {
        resolvedState = DayRangeState.start;
      } else if (isSameDay(target, end)) {
        resolvedState = DayRangeState.end;
      } else if (target.isAfter(start) && target.isBefore(end)) {
        // If it's already a start/end of an overlapping range, keep that visual edge.
        if (resolvedState == DayRangeState.none) {
          resolvedState = DayRangeState.inRange;
        }
      }
    }
    return resolvedState;
  }
}
