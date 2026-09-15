import 'package:app/core/forms/widgets/text_field.dart';
import 'package:app/features/setup/bloc/setup_wizard_bloc.dart';
import 'package:app/features/setup/bloc/wizard_event.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/presentation/pages/name/name_field_input.dart';
import 'package:app/features/setup/presentation/pages/name/name_form_cubit.dart';
import 'package:app/features/setup/presentation/pages/name/name_form_state.dart';
import 'package:app/features/setup/presentation/widgets/form_layout.dart';
import 'package:app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NamePage extends StatelessWidget {
  const NamePage(this._wizard, {super.key});

  final SetupWizardBloc _wizard;

  void _onSubmit(NameDetails details) {
    _wizard.add(SetupWizardEvent.nameSubmitted(name: details));
  }

  /// Builds the form widget for the name input page.
  ///
  /// This widget consists of a text field for the user to input their name and
  /// a button to submit the form. It uses the provided [NameFormCubit] to
  /// manage the form state and validation.
  ///
  Widget _form(NameFormCubit cubit, NameFormState state) {
    return FormLayout(
      title: t.setup.name.title,
      buttonText: t.setup.name.action,
      onSubmit: state.isValid ? cubit.trySubmit : null,
      child: Expanded(
        child: PeriodtTextField(
          field: cubit.state.name,
          onChanged: cubit.nameChanged,
          onTouched: cubit.nameTouched,
          placeholder: t.setup.name.placeholder,
          label: t.setup.name.description,
          errorText: (error) => switch (error) {
            NameFieldError.empty => t.setup.name.error.empty,
            NameFieldError.tooShort => t.setup.name.error.tooShort,
            NameFieldError.tooLong => t.setup.name.error.tooLong,
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = NameFormCubit(onSubmit: _onSubmit);

    return Column(
      children: [
        Expanded(
          child: BlocBuilder<NameFormCubit, NameFormState>(
            bloc: cubit,
            builder: (context, state) => _form(cubit, state),
          ),
        ),
      ],
    );
  }
}
