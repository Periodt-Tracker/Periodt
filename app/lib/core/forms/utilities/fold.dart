import 'package:app/core/forms/engine/field.dart';

R foldAll2<RA, VA, EA, RB, VB, EB, R>(
  PeriodtInput<RA, VA, EA> a,
  PeriodtInput<RB, VB, EB> b, {
  required R Function(VA a, VB b) valid,
  required R Function() invalid,
}) {
  final av = a.transformed, bv = b.transformed;
  if (av != null && bv != null) return valid(av, bv);
  return invalid();
}

R foldAll3<RA, VA, EA, RB, VB, EB, RC, VC, EC, R>(
  PeriodtInput<RA, VA, EA> a,
  PeriodtInput<RB, VB, EB> b,
  PeriodtInput<RC, VC, EC> c, {
  required R Function(VA a, VB b, VC c) valid,
  required R Function() invalid,
}) {
  final av = a.transformed, bv = b.transformed, cv = c.transformed;
  if (av != null && bv != null && cv != null) return valid(av, bv, cv);
  return invalid();
}
