import 'package:periodt/core/conditions/constants.dart';
import 'package:periodt/core/form/models/field.dart';
import 'package:periodt/core/form/models/form.dart';
import 'package:periodt/core/widgets/form/validator/base.dart';

class BleedingPage extends PeriodtFormPage {
  final bleedingLevel = PeriodtField<BleedingLevel?, String>(
    null,
    validators: [Validator.required("Must specify a bleeding level")],
  );

  final spotting = PeriodtField<bool?, String>(
    null,
    validators: [Validator.required("Must specify spotting")],
  );

  final clots = PeriodtField<bool?, String>(
    null,
    validators: [Validator.required("Must specify clots")],
  );

  @override
  List<PeriodtField<dynamic, dynamic>> get fields => [
    bleedingLevel,
    spotting,
    clots,
  ];

  @override
  bool get skippable => true;
}
