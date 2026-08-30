import 'package:periodt/core/form/models/field.dart';
import 'package:periodt/core/form/models/form.dart';
import 'package:periodt/core/settings/models.dart';
import 'package:periodt/core/widgets/form/validator/base.dart';

class UserPageState extends PeriodtFormPage {
  UserPageState.initial();

  final name = PeriodtField(
    '',
    validators: [
      Validator.required('Name is required'),
      Validator.minLength(3, 'Name is too short'),
      Validator.maxLength(128, 'Name is too long'),
    ],
  );

  UserSettings intoUserSettings() {
    return UserSettings(name: name.field);
  }

  @override
  bool get skippable => false;

  @override
  List<PeriodtField> get fields => [name];
}
