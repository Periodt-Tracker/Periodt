import 'dart:async';

import 'package:app/core/settings/settings.dart';
import 'package:app/core/settings/settings_cubit.dart';
import 'package:app/core/settings/settings_state.dart';
import 'package:app/features/security/bloc/security_event.dart';
import 'package:app/features/security/bloc/security_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  SecurityBloc({required SettingsCubit settings})
    : _settings = settings,
      super(const SecurityState.locked()) {
    _settingsSubscription = _settings.stream.listen((state) {
      add(const SecurityEvent.settingsUpdated());
    });

    on<SettingsUpdatedEvent>(_onSettingsUpdated);
    on<PinSetEvent>(_onPinSet);
  }

  final SettingsCubit _settings;

  late final StreamSubscription<SettingsState> _settingsSubscription;

  void _onSettingsUpdated(
    SettingsUpdatedEvent event,
    Emitter<SecurityState> emit,
  ) {
    switch (_settings.state) {
      case SettingsLoading() || SettingsMissing() || SettingsInvalid():
        emit(const SecurityState.locked());

      case SettingsValid(:final settings):
        switch (settings.security.method) {
          case SecurityMethod.none:
            emit(const SecurityState.authenticated());

          case SecurityMethod.pin:
            emit(const SecurityState.pinRequired());

          case SecurityMethod.device:
            emit(const SecurityState.deviceLoginRequired());
        }
    }
  }

  void _onPinSet(PinSetEvent event, Emitter<SecurityState> emit) {
    emit(const SecurityState.pinLoading());
  }
}
