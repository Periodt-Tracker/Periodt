import 'package:app/core/forms/engine/field.dart';
import 'package:app/core/forms/engine/validation_result.dart';
import 'package:app/features/daily_log/domain/notes.dart';

class NoteFieldInput extends PeriodtInput<String, Note, NoteValidationError> {
  const NoteFieldInput.pure() : super.pure('');

  const NoteFieldInput.dirty(super.value) : super.dirty();

  @override
  ValidationResult<Note, NoteValidationError> validate(String value) {
    return Note.tryFrom(value);
  }
}
