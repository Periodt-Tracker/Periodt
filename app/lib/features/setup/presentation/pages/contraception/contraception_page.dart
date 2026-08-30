import 'package:app/core/forms/widgets/text_field.dart';
import 'package:app/features/setup/bloc/setup_wizard_bloc.dart';
import 'package:app/features/setup/bloc/wizard_event.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/domain/contraception_type.dart';
import 'package:app/features/setup/presentation/pages/contraception/contraception_form_cubit.dart';
import 'package:app/features/setup/presentation/pages/name/name_field_input.dart';
import 'package:app/features/setup/presentation/pages/name/name_form_cubit.dart';
import 'package:app/features/setup/presentation/pages/name/name_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContraceptionPage extends StatelessWidget {
  const ContraceptionPage({required this.wizard, super.key});

  final SetupWizardBloc wizard;

  void _onSubmit(ContraceptionType details) {
    wizard.add(SetupWizardEvent.contraceptionSubmitted(type: details));
  }

  Widget _form(ContraceptionFormCubit cubit, NameFormState state) {
    return Column(
      children: [
        PeriodtTextField(
          field: cubit.state.name,
          onChanged: cubit.nameChanged,
          onTouched: cubit.nameTouched,
          errorText: (error) => switch (error) {
            NameFieldError.empty => 'Name cannot be empty',
            NameFieldError.tooShort => 'Name is too short',
            NameFieldError.tooLong => 'Name is too long',
          },
        ),
        ElevatedButton(
          onPressed: cubit.trySubmit,
          child: const Text('Next'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = NameFormCubit(onSubmit: _onSubmit);

    return BlocBuilder<NameFormCubit, NameFormState>(
      bloc: cubit,
      builder: (context, state) => _form(cubit, state),
    );
  }
}
