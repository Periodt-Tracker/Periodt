import 'package:app/core/forms/engine/validation_result.dart';
import 'package:flutter/material.dart';

enum NoteValidationError {
  empty,
  tooLong,
}

@immutable
class NoteDetails {
  const NoteDetails({required this.note});

  final Note note;
}

@immutable
class Note {
  const Note._({required this.value});

  final String value;

  static ValidationResult<Note, NoteValidationError> tryFrom(String note) {
    if (note.length > 2048) {
      return const Invalid(NoteValidationError.tooLong);
    }

    return Valid(Note._(value: note));
  }
}
