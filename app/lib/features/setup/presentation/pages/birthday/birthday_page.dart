import 'package:app/core/forms/widgets/date_field.dart';
import 'package:app/core/utilities/date.dart';
import 'package:app/features/setup/bloc/setup_wizard_bloc.dart';
import 'package:app/features/setup/bloc/wizard_event.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/presentation/pages/birthday/birthday_field.dart';
import 'package:app/features/setup/presentation/pages/birthday/birthday_form_cubit.dart';
import 'package:app/features/setup/presentation/pages/birthday/birthday_form_state.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BirthdayPage extends StatelessWidget {
  const BirthdayPage(this._wizard, {super.key});

  final SetupWizardBloc _wizard;

  void _onSubmit(BirthdayDetails details) {
    _wizard.add(SetupWizardEvent.dateOfBirthSubmitted(birthday: details));
  }

  Widget _form(BirthdayFormCubit cubit, BirthdayFormState state) {
    final maximumDate = clock.now();
    final minimumDate = clock.yearsAgo(120);

    return Column(
      children: [
        PeriodtDateField<DateOnly, BirthdayFieldError>(
          field: cubit.state.birthday,
          onChanged: cubit.birthdayChanged,
          onTouched: cubit.birthdayTouched,
          maximumDate: maximumDate,
          minimumDate: minimumDate,
          errorText: (error) => switch (error) {
            BirthdayFieldError.inFuture => 'Birthday cannot be in the future',
            BirthdayFieldError.tooOld =>
              'fucking world record holder, you are too old',
            BirthdayFieldError.required => 'Birthday is required',
          },
        ),
        ElevatedButton(
          onPressed: cubit.submit,
          child: const Text('Next'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = BirthdayFormCubit(onSubmit: _onSubmit);

    return BlocBuilder<BirthdayFormCubit, BirthdayFormState>(
      bloc: cubit,
      builder: (context, state) => _form(cubit, state),
    );
  }
}
