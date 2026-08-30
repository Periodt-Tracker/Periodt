import 'package:app/core/forms/engine/form_status.dart';
import 'package:app/features/daily_log/presentation/notes/note_field.dart';
import 'package:flutter/material.dart';

@immutable
class NoteFormState {
  final NoteFieldInput note;
  final PeriodtFormStatus status;

  const NoteFormState({
    this.note = const NoteFieldInput.pure(),
    this.status = PeriodtFormStatus.initial,
  });

  NoteFormState copyWith({NoteFieldInput? note, PeriodtFormStatus? status}) {
    return NoteFormState(
      note: note ?? this.note,
      status: status ?? this.status,
    );
  }
}
