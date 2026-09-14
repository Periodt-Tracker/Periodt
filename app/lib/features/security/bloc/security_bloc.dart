import 'package:app/core/settings/settings.dart';
import 'package:app/features/security/bloc/security_event.dart';
import 'package:app/features/security/bloc/security_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SecurityBloc extends Bloc<SecurityEvent, SecurityState> {
  SecurityBloc(PeriodtSettings settings) : super(_initialState(settings)) {
    on<UnlockedEvent>(_onUnlock);
  }

  static SecurityState _initialState(PeriodtSettings settings) {
    final method = settings.security.method;

    if (method == null) {
      return const SecurityLoading();
    }

    return SecurityLocked(method);
  }

  void _onUnlock(UnlockedEvent event, Emitter<SecurityState> emit) {
    emit(const SecurityUnlocked());
  }
}
