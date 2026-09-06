import 'package:app/core/forms/engine/form_status.dart';
import 'package:app/features/setup/domain/period.dart';
import 'package:app/features/setup/presentation/pages/period_metadata/cycle_length_field.dart';
import 'package:app/features/setup/presentation/pages/period_metadata/period_duration_field.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'period_metadata_form_state.freezed.dart';

@freezed
class PeriodMetadataFormState with _$PeriodMetadataFormState {
  const PeriodMetadataFormState._({
    required this.status,
    required this.cycleLength,
    required this.periodDuration,
  });

  factory PeriodMetadataFormState.initial() {
    return const PeriodMetadataFormState._(
      cycleLength: CycleLengthFieldInput.pure(),
      periodDuration: PeriodDurationFieldInput.pure(),
      status: PeriodtFormStatus.initial,
    );
  }

  factory PeriodMetadataFormState.fromDetails(PeriodMetadata? details) {
    return PeriodMetadataFormState._(
      cycleLength: CycleLengthFieldInput.dirty(details?.cycleLength),
      periodDuration: PeriodDurationFieldInput.dirty(details?.periodLength),
      status: PeriodtFormStatus.initial,
    );
  }

  bool get isValid => cycleLength.isValid && periodDuration.isValid;

  @override
  final CycleLengthFieldInput cycleLength;

  @override
  final PeriodDurationFieldInput periodDuration;

  @override
  final PeriodtFormStatus status;
}
