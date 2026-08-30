import 'package:periodt/core/conditions/constants.dart';
import 'package:periodt/core/database/models/daily-log.dart';
import 'package:periodt/core/form/models/field.dart';
import 'package:periodt/core/form/models/form.dart';
import 'package:periodt/core/widgets/form/validator/base.dart';

class MoodPage extends PeriodtFormPage {
  final moodType = PeriodtField<Mood?, String>(
    null,
    validators: [Validator.required("You must specify a mood")],
  );

  MoodLogBuilder intoLog() {
    return MoodLogBuilder(moodType: moodType.value.toString());
  }

  @override
  bool get skippable => true;

  @override
  List<PeriodtField> get fields => [moodType];
}
