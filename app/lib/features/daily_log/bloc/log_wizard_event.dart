import 'package:app/core/forms/engine/skippable_page.dart';
import 'package:app/features/daily_log/domain/bleeding.dart';
import 'package:app/features/daily_log/domain/notes.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'log_wizard_event.freezed.dart';

@freezed
sealed class LogWizardEvent with _$LogWizardEvent {
  const factory LogWizardEvent.bleedingSubmitted({
    required BleedingType bleeding,
  }) = BleedingSubmitted;

  const factory LogWizardEvent.notesSubmitted({
    required OptionalPage<NoteDetails> notes,
  }) = NotesSubmitted;
}
