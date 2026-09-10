import 'dart:async';

import 'package:app/core/settings/settings_cubit.dart';
import 'package:app/core/settings/settings_state.dart';
import 'package:app/features/security/bloc/security_event.dart';
import 'package:app/features/security/bloc/security_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  SecurityBloc({required SettingsCubit settings})
    : _settings = settings,
      super(const SecurityState.loading()) {
    _settingsSubscription = _settings.stream.listen((state) {
      add(const SecurityEvent.settingsUpdated());
    });

    on<SettingsUpdatedEvent>(_onSettingsUpdated);

    if (_settings.state is SettingsValid) {
      add(const SecurityEvent.settingsUpdated());
    }
  }

  final SettingsCubit _settings;
  late final StreamSubscription<SettingsState> _settingsSubscription;

  void _onSettingsUpdated(
    SettingsUpdatedEvent event,
    Emitter<SecurityState> emit,
  ) {
    final settingsState = _settings.state;

    final settings = switch (settingsState) {
      SettingsValid(:final settings) => settings,
      _ => null,
    };

    if (settings == null) {
      emit(const SecurityState.loading());
      return;
    }

    final method = settings.security.method;

    if (method == null) {
      emit(const SecurityState.unlocked());
    } else {
      emit(SecurityState.locked(method));
    }
  }
}
