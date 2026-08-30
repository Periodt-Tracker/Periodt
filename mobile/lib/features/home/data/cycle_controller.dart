import 'package:flutter/material.dart';

import '../widgets/timeline.dart';

extension CycleController on ScrollController {
  double _intoOffset(int index) => index * dayWidth;

  void animateToDay(int dayIndex) {
    final targetOffset = _intoOffset(dayIndex);

    animateTo(
      targetOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void jumpToDay(int dayIndex) {
    final targetOffset = _intoOffset(dayIndex);

    jumpTo(targetOffset);
  }
}
