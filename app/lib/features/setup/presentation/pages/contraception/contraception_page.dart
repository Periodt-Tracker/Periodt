import 'package:app/app/theme/base.dart';
import 'package:app/core/forms/widgets/tile_field.dart';
import 'package:app/features/setup/bloc/setup_wizard_bloc.dart';
import 'package:app/features/setup/bloc/wizard_event.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/domain/contraception_type.dart';
import 'package:app/features/setup/presentation/pages/contraception/contraception_field.dart';
import 'package:app/features/setup/presentation/pages/contraception/contraception_form_cubit.dart';
import 'package:app/features/setup/presentation/pages/contraception/contraception_form_state.dart';
import 'package:app/features/setup/presentation/pages/contraception/contraception_icon.dart';
import 'package:app/features/setup/presentation/widgets/form_layout.dart';
import 'package:app/i18n/strings.g.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContraceptionPage extends StatelessWidget {
  const ContraceptionPage(this._wizard, {super.key});

  final SetupWizardBloc _wizard;

  void _onSubmit(ContraceptionDetails details) {
    _wizard.add(
      SetupWizardEvent.contraceptionSubmitted(type: details.contraceptionType),
    );
  }

  Widget _contraceptionTile(Method method, bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        border: Border.all(
          color: switch (selected) {
            true => PeriodtTheme.periodPrimary,
            _ => Colors.transparent,
          },
          width: 6,
        ),
        borderRadius: BorderRadius.circular(16),
        color: PeriodtTheme.surface,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          ContraceptionIcon(method: method, size: 92),
          Text(method.name),
        ],
      ),
    );
  }

  Widget _form(ContraceptionFormCubit cubit, ContraceptionFormState state) {
    return FormLayout(
      title: t.setup.contraception.title,
      buttonText: t.setup.contraception.action,
      onSubmit: cubit.trySubmit,
      child: Expanded(
        child:
            PeriodtTileField<
              Method,
              ContraceptionType,
              ContraceptionFieldError
            >(
              items: Method.values.toSet(),
              field: state.type,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              onChanged: cubit.contraceptionChanged,
              onTouched: cubit.contraceptionTouched,
              errorText: (error) => switch (error) {
                ContraceptionFieldError.invalidCombination =>
                  t.setup.contraception.error.invalidCombination,
              },
              builder: (context, value, selected) =>
                  _contraceptionTile(value, selected),
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = ContraceptionFormCubit(onSubmit: _onSubmit);

    return BlocBuilder<ContraceptionFormCubit, ContraceptionFormState>(
      bloc: cubit,
      builder: (context, state) => _form(cubit, state),
    );
  }
}
