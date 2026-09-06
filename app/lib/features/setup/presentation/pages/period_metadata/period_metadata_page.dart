import 'package:app/app/theme/base.dart';
import 'package:app/core/forms/widgets/number_field.dart';
import 'package:app/core/forms/widgets/scrollable_integer_field.dart';
import 'package:app/features/setup/bloc/setup_wizard_bloc.dart';
import 'package:app/features/setup/bloc/wizard_event.dart';
import 'package:app/features/setup/domain/period.dart';
import 'package:app/features/setup/presentation/pages/period_metadata/cycle_length_field.dart';
import 'package:app/features/setup/presentation/pages/period_metadata/period_duration_field.dart';
import 'package:app/features/setup/presentation/pages/period_metadata/period_metadata_form_cubit.dart';
import 'package:app/features/setup/presentation/pages/period_metadata/period_metadata_form_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PeriodMetadataPage extends StatelessWidget {
  const PeriodMetadataPage(this._wizard, {super.key});

  final SetupWizardBloc _wizard;

  void _onSubmit(PeriodMetadata state) {
    _wizard.add(SetupWizardEvent.onPeriodMetadataSubmitted(metadata: state));
  }

  Widget _form(BuildContext context, PeriodMetadataFormCubit cubit) {
    return Column(
      children: [
        PeriodtIntegerField<int, CycleLengthFieldError>(
          field: cubit.state.cycleLength,
          onChanged: cubit.onCycleLengthChanged,
          onTouched: cubit.onCycleLengthTouched,
          placeholder: 'Enter your cycle length',
          label: 'Cycle length (days)',
          errorText: (error) => switch (error) {
            CycleLengthFieldError.required => 'Cycle length cannot be empty',
            CycleLengthFieldError.tooShort => 'Cycle length is too short',
            CycleLengthFieldError.tooLong => 'Cycle length is too long',
          },
          decoration: const InputDecoration(
            prefixIcon: SizedBox(
              width: 48,
              child: Center(
                child: FaIcon(FontAwesomeIcons.solidClock),
              ),
            ),
          ),
        ),

        PeriodtIntegerField<int, PeriodDurationFieldError>(
          field: cubit.state.periodDuration,
          onChanged: cubit.onPeriodDurationChanged,
          onTouched: cubit.onPeriodDurationTouched,
          placeholder: 'Enter your period duration',
          label: 'Period duration (days)',
          errorText: (error) => switch (error) {
            PeriodDurationFieldError.required =>
              'Period duration cannot be empty',
            PeriodDurationFieldError.tooShort => 'Period duration is too short',
            PeriodDurationFieldError.tooLong => 'Period duration is too long',
          },
          decoration: InputDecoration(
            prefixIcon: const SizedBox(
              width: 48,
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.solidClock,
                  size: 24,
                  color: Color(0x988000000),
                ),
              ),
            ),
            suffixIcon: SizedBox(
              width: 72,
              child: Center(
                child: Text(
                  'days',
                  style: PeriodtTheme.light.textTheme.bodyLarge,
                ),
              ),
            ),
          ),
        ),

        PeriodtScrollableField<int?, int, CycleLengthFieldError>(
          field: cubit.state.cycleLength,
          onChanged: (_) => {},
          onTouched: () => {},
          values: List.generate(100, (index) => index + 1),
          formatter: (value) => '$value Days',
          errorText: (error) => switch (error) {
            CycleLengthFieldError.required => 'Cycle length cannot be empty',
            CycleLengthFieldError.tooShort => 'Cycle length is too short',
            CycleLengthFieldError.tooLong => 'Cycle length is too long',
          },
        ),

        const Spacer(),

        ElevatedButton(
          onPressed: cubit.state.isValid ? cubit.trySubmit : null,
          child: const Text('Complete setup!'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final cubit = PeriodMetadataFormCubit(onSubmit: _onSubmit);

    return BlocBuilder<PeriodMetadataFormCubit, PeriodMetadataFormState>(
      bloc: cubit,
      builder: (context, state) => _form(context, cubit),
    );
  }
}
