import 'package:app/app/theme/base.dart';
import 'package:app/features/setup/bloc/setup_wizard_bloc.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/presentation/pages/birthday/birthday_page.dart';
import 'package:app/features/setup/presentation/pages/name/name_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const maxPageCount = 4;

const minimumProgress = 0.1;
const maximumProgress = 0.9;

class SetupPage extends StatelessWidget {
  const SetupPage({required this.wizard, super.key});

  final SetupWizardBloc wizard;

  // in general we want to avoid the progress bar ever going backwards
  // and so we shall always show the completion against the furthest
  // possible page remaining.
  //
  // although this does still lead to some slightly funky ux so maybe
  // something we should look into a little heavier
  //
  double progress(SetupWizardState state) {
    final progress = state.progress;

    return progress.clamp(minimumProgress, maximumProgress);
  }

  Widget _progressBar(SetupWizardState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          'Periodt.',
          style: GoogleFonts.outfit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: PeriodtTheme.primary,
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(999),
          child: const LinearProgressIndicator(
            value: 0.3,
            minHeight: 12,
            backgroundColor: PeriodtTheme.surfacePink,
            valueColor: AlwaysStoppedAnimation(PeriodtTheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _pageContent(SetupWizardBloc wizard, SetupWizardState state) {
    return switch (state) {
      NamePageState() => NamePage(wizard),
      // TODO: Handle this case.
      BirthdayPageState() => BirthdayPage(wizard),
      // TODO: Handle this case.
      ContraceptionPageState() => throw UnimplementedError(),
      // TODO: Handle this case.
      NoContraceptionPeriodPageState() => throw UnimplementedError(),
      // TODO: Handle this case.
      NoContraceptionPeriodMetadataPageState() => throw UnimplementedError(),
      // TODO: Handle this case.
      PillDetailsPageState() => throw UnimplementedError(),
      // TODO: Handle this case.
      HormonalIudDetailsPageState() => throw UnimplementedError(),
      // TODO: Handle this case.
      CopperIudDetailsPageState() => throw UnimplementedError(),
      // TODO: Handle this case.
      CopperIudPeriodsPageState() => throw UnimplementedError(),
      // TODO: Handle this case.
      CopperIudPeriodMetadataPageState() => throw UnimplementedError(),
      // TODO: Handle this case.
      CopperIudAndPillIudDetailsPageState() => throw UnimplementedError(),
      // TODO: Handle this case.
      CopperIudAndPillPillDetailsPageState() => throw UnimplementedError(),
      // TODO: Handle this case.
      HormonalIudAndPillIudDetailsPageState() => throw UnimplementedError(),
      // TODO: Handle this case.
      HormonalIudAndPillPillDetailsPageState() => throw UnimplementedError(),
      // TODO: Handle this case.
      NoContraceptionCompletedState() => throw UnimplementedError(),
      // TODO: Handle this case.
      PillCompletedState() => throw UnimplementedError(),
      // TODO: Handle this case.
      HormonalIudCompletedState() => throw UnimplementedError(),
      // TODO: Handle this case.
      CopperIudCompletedState() => throw UnimplementedError(),
      // TODO: Handle this case.
      CopperIudAndPillCompletedState() => throw UnimplementedError(),
      // TODO: Handle this case.
      HormonalIudAndPillCompletedState() => throw UnimplementedError(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _progressBar(wizard),
              const SizedBox(height: 16),
              Expanded(child: _pageContent(wizard.state)),
            ],
          ),
        ),
      ),
    );
  }
}
