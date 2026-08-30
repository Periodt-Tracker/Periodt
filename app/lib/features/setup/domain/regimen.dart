import 'package:app/core/utilities/date.dart';

sealed class Regimen {
  const Regimen();
}

class ContinuousRegimen extends Regimen {
  const ContinuousRegimen();
}

class CyclicalRegimen extends Regimen {
  final int daysOn;
  final int daysOff;
  final DateOnly lastStartedOn;

  const CyclicalRegimen({
    required this.daysOn,
    required this.daysOff,
    required this.lastStartedOn,
  });
}
