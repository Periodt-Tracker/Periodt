import 'package:periodt/core/form/models/form.dart';
import 'package:periodt/core/utilities/range.dart';
import 'package:periodt/core/form/models/field.dart';
import 'package:periodt/core/widgets/form/validator/base.dart';

const defaultCycleRange = Range(lower: 26, upper: 28);

class CycleLengthPageState extends PeriodtFormPage {
  final cycleLength = PeriodtField(
    defaultCycleRange,
    validators: [Validator.required('Cycle length is required')],
  );

  CycleLengthPageState.initial();

  @override
  bool get skippable => true;

  @override
  List<PeriodtField> get fields => [cycleLength];
}
