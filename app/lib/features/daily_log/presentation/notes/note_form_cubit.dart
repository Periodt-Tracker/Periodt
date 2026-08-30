import 'package:app/core/forms/engine/form_status.dart';
import 'package:app/features/daily_log/domain/notes.dart';
import 'package:app/features/daily_log/presentation/notes/note_field.dart';
import 'package:app/features/daily_log/presentation/notes/note_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteFormCubit extends Cubit<NoteFormState> {
  NoteFormCubit({required this.onSubmit}) : super(const NoteFormState());

  final void Function(NoteDetails) onSubmit;

  void noteChanged(String value) {
    final newNote = NoteFieldInput.dirty(value);

    emit(state.copyWith(note: newNote));
  }

  void noteTouched() {
    if (state.note.isDirty) {
      return;
    }

    emit(state.copyWith(note: NoteFieldInput.dirty(state.note.value)));
  }

  NoteDetails _handleValidSubmit(Note note) {
    final newState = state.copyWith(
      note: NoteFieldInput.dirty(note.value),
      status: PeriodtFormStatus.inProgress,
    );

    emit(newState);
    return NoteDetails(note: note);
  }

  void _handleInvalidSubmit(_) {
    final newState = state.copyWith(
      note: NoteFieldInput.dirty(state.note.value),
      status: PeriodtFormStatus.failure,
    );

    emit(newState);
  }

  NoteDetails? submit() {
    return state.note.fold(
      valid: _handleValidSubmit,
      invalid: _handleInvalidSubmit,
    );
  }
}
