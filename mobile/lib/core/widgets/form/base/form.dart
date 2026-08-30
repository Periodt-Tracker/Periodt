import 'package:periodt/core/widgets/form/base/field.dart';

abstract class FormState {
  const FormState();

  bool get valid {
    for (final page in pages) {
      if (!page.valid) {
        return false;
      }
    }

    return fields.every((field) => field.isValid());
  }

  void touchAll() {
    for (final feild in fields) {
      feild.touch();
    }

    for (final page in pages) {
      page.touchAll();
    }
  }

  List<FormField<dynamic>> get fields => [];

  List<FormState> get pages => [];
}
