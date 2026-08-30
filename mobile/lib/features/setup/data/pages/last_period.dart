import 'package:periodt/core/form/models/field.dart';
import 'package:periodt/core/form/models/form.dart';
import 'package:periodt/core/widgets/form/validator/base.dart';

class LastPeriodPageState extends PeriodtFormPage {
  final lastPeriod = PeriodtField<List<DateTime?>?, String>(
    null,
    validators: [Validator.required('Last period date is required')],
  );

  LastPeriodPageState.initial();

  @override
  List<PeriodtField> get fields => [lastPeriod];
}
