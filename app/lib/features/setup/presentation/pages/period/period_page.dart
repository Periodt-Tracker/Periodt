import 'package:app/app/theme/base.dart';
import 'package:app/features/setup/bloc/setup_wizard_bloc.dart';
import 'package:app/features/setup/bloc/wizard_event.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/domain/period.dart';
import 'package:app/features/setup/presentation/pages/period/period_details_form_cubit.dart';
import 'package:app/features/setup/presentation/pages/period/period_details_form_state.dart';
import 'package:app/features/setup/presentation/pages/period/period_form_cubit.dart';
import 'package:app/features/setup/presentation/pages/period/period_form_state.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PeriodPage extends StatelessWidget {
  const PeriodPage(this._wizard, {super.key});

  final SetupWizardBloc _wizard;

  void _onSubmit(LastPeriodDetails details) {
    _wizard.add(SetupWizardEvent.onPeriodsSubmitted(lastPeriods: details));
  }

  Widget _periodDetailsForm(BuildContext context) {
    final cubit = PeriodDetailsFormCubit(
      onSubmit: (details) => Navigator.of(context).pop(details),
    );

    return AlertDialog(
      content: BlocBuilder<PeriodDetailsFormCubit, PeriodDetailsFormState>(
        bloc: cubit,
        builder: (context, state) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.maxFinite,
                child: CalendarDatePicker2(
                  config: CalendarDatePicker2Config(
                    calendarType: CalendarDatePicker2Type.range,
                    disableModePicker: true,
                  ),
                  value: cubit.state.details.value,
                  onValueChanged: cubit.onDetailsChanged,
                ),
              ),

              ElevatedButton.icon(
                onPressed: cubit.state.details.isValid ? cubit.trySubmit : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  textStyle: PeriodtTheme.light.textTheme.titleMedium,
                ),
                icon: const FaIcon(FontAwesomeIcons.plus, size: 16),
                label: const Text('Add Period'),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _openDatePicker(
    BuildContext context,
    PeriodFormCubit form,
  ) async {
    final details = await showDialog<PeriodDetails?>(
      context: context,
      builder: _periodDetailsForm,
    );

    if (details != null) {
      form.onPeriodAdded(details);
    }
  }

  Widget _form(BuildContext context, PeriodFormCubit form) {
    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          itemCount: form.state.periods.value.length,
          itemBuilder: (context, index) {
            final period = form.state.periods.value[index];
            return ListTile(
              title: Text('${period.start} - ${period.end}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => {},
              ),
            );
          },
        ),
        ElevatedButton.icon(
          onPressed: () => _openDatePicker(context, form),
          icon: const FaIcon(FontAwesomeIcons.plus),
          label: const Text('Add Period'),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            textStyle: PeriodtTheme.light.textTheme.titleMedium,
          ),
        ),
        const Spacer(),
        ElevatedButton(
          onPressed: form.trySubmit,
          child: const Text('Submit'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final form = PeriodFormCubit(onSubmit: _onSubmit);

    return BlocBuilder<PeriodFormCubit, PeriodFormState>(
      bloc: form,
      builder: (context, state) => _form(context, form),
    );
  }
}
