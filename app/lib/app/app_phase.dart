import 'package:app/core/settings/settings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_phase.freezed.dart';

@freezed
sealed class AppPhase with _$AppPhase {
  const factory AppPhase.startup() = Startup;

  const factory AppPhase.setup() = Setup;

  const factory AppPhase.ready(PeriodtSettings settings) = Ready;
}
