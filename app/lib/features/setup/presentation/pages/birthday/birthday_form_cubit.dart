import 'package:app/core/forms/engine/form_status.dart';
import 'package:app/core/utilities/date.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/presentation/pages/birthday/birthday_field.dart';
import 'package:app/features/setup/presentation/pages/birthday/birthday_form_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BirthdayFormCubit extends Cubit<BirthdayFormState> {
  BirthdayFormCubit({required DateTime initialBirthday, required this.onSubmit})
    : super(BirthdayFormState.initial(initialBirthday: initialBirthday));

  final void Function(BirthdayDetails) onSubmit;

  void birthdayChanged(DateTime? birthday) {
    final newBirthday = BirthdayFieldInput.dirty(birthday);

    emit(state.copyWith(birthday: newBirthday));
  }

  void birthdayTouched() {
    final newBirthday = BirthdayFieldInput.dirty(state.birthday.value);

    emit(state.copyWith(birthday: newBirthday));
  }

  void _handleValidSubmit(DateOnly birthday) {
    final dateTimeBirthday = birthday.toDateTime();

    final newState = state.copyWith(
      birthday: BirthdayFieldInput.dirty(dateTimeBirthday),
      status: PeriodtFormStatus.inProgress,
    );

    emit(newState);

    final details = BirthdayDetails(birthday: birthday);
    onSubmit(details);
  }

  void _handleInvalidSubmit(_) {
    final newState = state.copyWith(
      birthday: BirthdayFieldInput.dirty(state.birthday.value),
      status: PeriodtFormStatus.failure,
    );

    emit(newState);
  }

  void submit() {
    state.birthday.fold(
      valid: _handleValidSubmit,
      invalid: _handleInvalidSubmit,
    );
  }
}
