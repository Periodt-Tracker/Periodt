import 'package:periodt/core/form/models/field.dart';
import 'package:periodt/core/form/models/form.dart';
import 'package:periodt/core/widgets/form/validator/base.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

abstract class PeriodLogForm {
  final range = PeriodtField<PickerDateRange?, String>(
    null,
    validators: [Validator.required("Must specify a range")],
  );

  PeriodLogForm.initial();

  List<PeriodtField> get fields => [range];
}
