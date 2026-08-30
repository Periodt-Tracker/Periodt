import 'package:app/features/setup/bloc/wizard_event.dart';
import 'package:app/features/setup/bloc/wizard_state.dart';
import 'package:app/features/setup/domain/contraception_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A [Bloc] that manages the state of the setup wizard.
///
/// It listens for [SetupWizardEvent]s and updates the [SetupWizardState] accordingly.
/// The wizard progresses through various stages, including name submission, date of birth submission,
/// contraception selection, period details submission, and more.
///
class SetupWizardBloc extends Bloc<SetupWizardEvent, SetupWizardState> {
  SetupWizardBloc() : super(const NamePageState()) {
    on<NameSubmitted>(_onNameSubmitted);

    on<DateOfBirthSubmitted>(_onDateOfBirthSubmitted);

    on<ContraceptionSubmitted>(_onContraceptionSubmitted);

    on<OnPeriodsSubmitted>(_onPeriodSubmitted);

    on<OnPeriodMetadataSubmitted>(_onPeriodMetadataSubmitted);

    on<OnIudDetailsSubmitted>(_onIudDetailsSubmitted);

    // Handle pill details submission
    //
    // Handles both `CopperIud` and `HormonalIud` cases as well as those in
    // combination with pills
    //
    on<OnPillDetailsSubmitted>(_onPillDetailsSubmitted);
  }

  void _onNameSubmitted(NameSubmitted event, Emitter<SetupWizardState> emit) {
    emit(BirthdayPageState(name: event.name));
  }

  void _onDateOfBirthSubmitted(
    DateOfBirthSubmitted event,
    Emitter<SetupWizardState> emit,
  ) {
    if (state case BirthdayPageState(:final name)) {
      final update = ContraceptionPageState(
        name: name,
        birthday: event.birthday,
      );

      emit(update);
    }
  }

  void _onContraceptionSubmitted(
    ContraceptionSubmitted event,
    Emitter<SetupWizardState> emit,
  ) {
    if (state case ContraceptionPageState(:final name, :final birthday)) {
      final update = switch (event.type) {
        ContraceptionType.none => NoContraceptionPeriodPageState(
          name: name,
          birthday: birthday,
        ),

        ContraceptionType.pill => PillDetailsPageState(
          name: name,
          birthday: birthday,
        ),

        ContraceptionType.hormonalIud => HormonalIudDetailsPageState(
          name: name,
          birthday: birthday,
        ),

        ContraceptionType.copperIud => CopperIudDetailsPageState(
          name: name,
          birthday: birthday,
        ),

        ContraceptionType.hormonalIudAndPill =>
          HormonalIudAndPillIudDetailsPageState(
            name: name,
            birthday: birthday,
          ),

        ContraceptionType.copperIudAndPill =>
          CopperIudAndPillIudDetailsPageState(
            name: name,
            birthday: birthday,
          ),
      };

      emit(update);
    }
  }

  void _onPeriodSubmitted(
    OnPeriodsSubmitted event,
    Emitter<SetupWizardState> emit,
  ) {
    final update = switch (state) {
      NoContraceptionPeriodPageState(:final name, :final birthday) =>
        NoContraceptionPeriodMetadataPageState(
          name: name,
          birthday: birthday,
          lastPeriods: event.lastPeriods,
        ),

      CopperIudPeriodsPageState(
        :final name,
        :final birthday,
        :final iudDetails,
      ) =>
        CopperIudPeriodMetadataPageState(
          name: name,
          birthday: birthday,
          iudDetails: iudDetails,
          lastPeriods: event.lastPeriods,
        ),

      _ => null,
    };

    if (update != null) {
      emit(update);
    }
  }

  void _onPeriodMetadataSubmitted(
    OnPeriodMetadataSubmitted event,
    Emitter<SetupWizardState> emit,
  ) {
    final update = switch (state) {
      NoContraceptionPeriodMetadataPageState(
        :final name,
        :final birthday,
        :final lastPeriods,
      ) =>
        NoContraceptionCompletedState(
          name: name,
          birthday: birthday,
          lastPeriods: lastPeriods,
          metadata: event.metadata,
        ),

      CopperIudPeriodMetadataPageState(
        :final name,
        :final birthday,
        :final iudDetails,
        :final lastPeriods,
      ) =>
        CopperIudCompletedState(
          name: name,
          birthday: birthday,
          iudDetails: iudDetails,
          lastPeriods: lastPeriods,
          metadata: event.metadata,
        ),

      _ => null,
    };

    if (update != null) {
      emit(update);
    }
  }

  void _onIudDetailsSubmitted(
    OnIudDetailsSubmitted event,
    Emitter<SetupWizardState> emit,
  ) {
    final update = switch (state) {
      CopperIudDetailsPageState(:final name, :final birthday) =>
        CopperIudPeriodsPageState(
          name: name,
          birthday: birthday,
          iudDetails: event.iudDetails,
        ),

      HormonalIudDetailsPageState(:final name, :final birthday) =>
        HormonalIudCompletedState(
          name: name,
          birthday: birthday,
          iudDetails: event.iudDetails,
        ),

      CopperIudAndPillIudDetailsPageState(:final name, :final birthday) =>
        CopperIudAndPillPillDetailsPageState(
          name: name,
          birthday: birthday,
          iudDetails: event.iudDetails,
        ),

      HormonalIudAndPillIudDetailsPageState(:final name, :final birthday) =>
        HormonalIudAndPillPillDetailsPageState(
          name: name,
          birthday: birthday,
          iudDetails: event.iudDetails,
        ),

      _ => null,
    };

    if (update != null) {
      emit(update);
    }
  }

  void _onPillDetailsSubmitted(
    OnPillDetailsSubmitted event,
    Emitter<SetupWizardState> emit,
  ) {
    final update = switch (state) {
      PillDetailsPageState(:final name, :final birthday) => PillCompletedState(
        name: name,
        birthday: birthday,
        pillDetails: event.pillDetails,
      ),

      CopperIudAndPillPillDetailsPageState(
        :final name,
        :final birthday,
        :final iudDetails,
      ) =>
        CopperIudAndPillCompletedState(
          name: name,
          birthday: birthday,
          iudDetails: iudDetails,
          pillDetails: event.pillDetails,
        ),

      HormonalIudAndPillPillDetailsPageState(
        :final name,
        :final birthday,
        :final iudDetails,
      ) =>
        HormonalIudAndPillCompletedState(
          name: name,
          birthday: birthday,
          iudDetails: iudDetails,
          pillDetails: event.pillDetails,
        ),

      _ => null,
    };

    if (update != null) {
      emit(update);
    }
  }
}
