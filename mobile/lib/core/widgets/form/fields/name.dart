import 'package:formz/formz.dart';

enum NameError { empty, tooShort, tooLong }

class NameField extends FormzInput<String, NameError> {
  static const defaultName = '';

  static const maxNameLength = 128;
  static const minNameLength = 2;

  const NameField.pure({String initalValue = ''}) : super.pure(initalValue);

  const NameField.dirty(super.value) : super.dirty();

  @override
  NameError? validator(String value) {
    if (value.isEmpty) {
      return NameError.empty;
    }

    if (value.length < minNameLength) {
      return NameError.tooShort;
    }

    if (value.length > maxNameLength) {
      return NameError.tooLong;
    }

    return null;
  }
}
