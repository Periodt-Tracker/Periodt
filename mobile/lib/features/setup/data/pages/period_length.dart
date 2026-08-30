import 'package:periodt/core/form/models/form.dart';
import 'package:periodt/core/utilities/range.dart';
import 'package:periodt/core/form/models/field.dart';
import 'package:periodt/core/widgets/form/validator/base.dart';

const defaultPeriodLength = Range(lower: 4, upper: 6);

class PeriodLengthPageState extends PeriodtFormPage {
  final PeriodtField<Range<int>, String> periodLength =
      PeriodtField<Range<int>, String>(
        defaultPeriodLength,
        validators: [Validator.required('Period length is required')],
      );

  PeriodLengthPageState.initial();

  @override
  bool get skippable => true;

  @override
  List<PeriodtField> get fields => [periodLength];
}
