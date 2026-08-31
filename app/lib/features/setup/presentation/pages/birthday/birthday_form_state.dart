import 'package:app/core/forms/engine/form_status.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/presentation/pages/birthday/birthday_field.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'birthday_form_state.freezed.dart';

@freezed
class BirthdayFormState with _$BirthdayFormState {
  final BirthdayFieldInput birthday;
  final PeriodtFormStatus status;

  const BirthdayFormState({required this.birthday, required this.status});

  factory BirthdayFormState.initial({DateTime? initialBirthday}) {
    return BirthdayFormState(
      birthday: BirthdayFieldInput.pure(initialBirthday),
      status: PeriodtFormStatus.initial,
    );
  }

  factory BirthdayFormState.fromDetails(BirthdayDetails details) {
    return BirthdayFormState(
      birthday: BirthdayFieldInput.dirty(details.birthday.toDateTime()),
      status: PeriodtFormStatus.initial,
    );
  }
}
