import 'package:app/app/theme/base.dart';
import 'package:app/features/setup/bloc/setup_wizard_bloc.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/presentation/pages/birthday/birthday_page.dart';
import 'package:app/features/setup/presentation/pages/contraception/contraception_page.dart';
import 'package:app/features/setup/presentation/pages/name/name_page.dart';
import 'package:app/features/setup/presentation/pages/period/period_page.dart';
import 'package:app/features/setup/presentation/pages/period_metadata/period_metadata_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

const maxPageCount = 4;

const minimumProgress = 0.1;
const maximumProgress = 0.9;

class SetupPage extends StatefulWidget {
  const SetupPage({super.key});

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  @override
  void initState() {
    super.initState();
    _wizard = SetupWizardBloc();
  }

  @override
  Future<void> dispose() async {
    super.dispose();

    await _wizard.close();
  }

  late final SetupWizardBloc _wizard;

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
          child: SizedBox(
            height: 12,
            child: Stack(
              children: [
                Container(
                  color: PeriodtTheme.surfacePink,
                ),
                FractionallySizedBox(
                  widthFactor: state.progress,
                  child: Container(
                    decoration: BoxDecoration(
                      color: PeriodtTheme.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _pageContent(SetupWizardBloc wizard) {
    return switch (wizard.state) {
      NamePageState() => NamePage(wizard),

      BirthdayPageState() => BirthdayPage(wizard),

      ContraceptionPageState() => ContraceptionPage(wizard),

      NoContraceptionPeriodPageState() => PeriodPage(wizard),

      NoContraceptionPeriodMetadataPageState() => PeriodMetadataPage(wizard),

      PillDetailsPageState() => throw UnimplementedError(),

      HormonalIudDetailsPageState() => throw UnimplementedError(),

      CopperIudDetailsPageState() => throw UnimplementedError(),

      CopperIudPeriodsPageState() => PeriodPage(wizard),

      CopperIudPeriodMetadataPageState() => PeriodMetadataPage(wizard),

      CopperIudAndPillIudDetailsPageState() => throw UnimplementedError(),

      CopperIudAndPillPillDetailsPageState() => throw UnimplementedError(),

      HormonalIudAndPillIudDetailsPageState() => throw UnimplementedError(),

      HormonalIudAndPillPillDetailsPageState() => throw UnimplementedError(),

      NoContraceptionCompletedState() => throw UnimplementedError(),

      PillCompletedState() => throw UnimplementedError(),

      HormonalIudCompletedState() => throw UnimplementedError(),

      CopperIudCompletedState() => throw UnimplementedError(),

      CopperIudAndPillCompletedState() => throw UnimplementedError(),

      HormonalIudAndPillCompletedState() => throw UnimplementedError(),
    };
  }

  Widget _page(SetupWizardBloc wizard) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 350),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
      child: KeyedSubtree(
        key: ValueKey(wizard.state.runtimeType),
        child: _pageContent(wizard),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: BlocBuilder<SetupWizardBloc, SetupWizardState>(
            bloc: _wizard,
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _progressBar(state),
                  const SizedBox(height: 32),
                  Expanded(child: _page(_wizard)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
