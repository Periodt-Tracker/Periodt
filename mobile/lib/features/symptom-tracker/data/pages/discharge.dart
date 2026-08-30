import 'package:periodt/core/conditions/constants.dart';
import 'package:periodt/core/form/models/field.dart';
import 'package:periodt/core/form/models/form.dart';
import 'package:periodt/core/widgets/form/validator/base.dart';

class DischargePage extends PeriodtFormPage {
  final colour = PeriodtField<DischargeColour?, String>(
    null,
    validators: [Validator.required("You must specify a colour")],
  );

  final odor = PeriodtField<DischargeOdor?, String>(
    null,
    validators: [Validator.required("You must specify an odor")],
  );

  final consistency = PeriodtField<DischargeConsistency?, String>(
    null,
    validators: [Validator.required("You must specify a consistency")],
  );

  // DischardgeLogBuilder intoLog() {
  //   return DischardgeLogBuilder(
  //     colour: colour.value,
  //     odor: odor.value,
  //     consistency: consistency.value,
  //   );
  // }

  @override
  List<PeriodtField<dynamic, dynamic>> get fields => [
    colour,
    odor,
    consistency,
  ];

  @override
  bool get skippable => true;
}
