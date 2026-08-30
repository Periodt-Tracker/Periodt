import 'package:app/core/settings/settings.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_event.freezed.dart';

@freezed
sealed class AppEvent with _$AppEvent {
  const factory AppEvent.started() = AppStarted;

  const factory AppEvent.setupComplete(PeriodtSettings settings) =
      AppConfigured;
}
