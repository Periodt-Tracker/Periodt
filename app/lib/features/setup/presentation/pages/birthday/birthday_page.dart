import 'package:app/app/theme/base.dart';
import 'package:app/core/forms/widgets/date_field.dart';
import 'package:app/core/utilities/date.dart';
import 'package:app/features/setup/bloc/setup_wizard_bloc.dart';
import 'package:app/features/setup/bloc/wizard_event.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/presentation/pages/birthday/birthday_field.dart';
import 'package:app/features/setup/presentation/pages/birthday/birthday_form_cubit.dart';
import 'package:app/features/setup/presentation/pages/birthday/birthday_form_state.dart';
import 'package:app/features/setup/presentation/widgets/form_layout.dart';
import 'package:clock/clock.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BirthdayPage extends StatelessWidget {
  const BirthdayPage(this._wizard, {super.key});

  final SetupWizardBloc _wizard;

  void _onSubmit(BirthdayDetails details) {
    _wizard.add(SetupWizardEvent.dateOfBirthSubmitted(birthday: details));
  }

  Widget _form(BirthdayFormCubit cubit, BirthdayFormState state) {
    final maximumDate = clock.daysFromNow(1);
    final minimumDate = clock.yearsAgo(120);

    return FormLayout(
      title: 'What is your birthday?',
      buttonText: 'Next',
      onSubmit: state.birthday.isValid ? cubit.submit : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            height: 268,
            child: CupertinoTheme(
              data: CupertinoThemeData(
                textTheme: CupertinoTextThemeData(
                  dateTimePickerTextStyle:
                      PeriodtTheme.light.textTheme.titleMedium,
                ),
              ),
              child: PeriodtDateField<DateOnly, BirthdayFieldError>(
                field: cubit.state.birthday,
                onChanged: cubit.birthdayChanged,
                onTouched: cubit.birthdayTouched,
                maximumDate: maximumDate,
                minimumDate: minimumDate,
                errorText: (error) => switch (error) {
                  BirthdayFieldError.inFuture =>
                    'Birthday cannot be in the future',
                  BirthdayFieldError.tooOld =>
                    'fucking world record holder, you are too old',
                  BirthdayFieldError.required => 'Birthday is required',
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'This helps Periodt. work out your cycle and fertility window. The information will never leave your phone',
            style: PeriodtTheme.light.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final initialBirthday = DateTime(2007, 5, 15);

    final cubit = BirthdayFormCubit(
      initialBirthday: initialBirthday,
      onSubmit: _onSubmit,
    );

    return BlocBuilder<BirthdayFormCubit, BirthdayFormState>(
      bloc: cubit,
      builder: (context, state) => _form(cubit, state),
    );
  }
}
