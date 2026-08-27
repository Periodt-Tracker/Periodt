import 'package:app/core/logging/app_logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// A [BlocObserver] that logs every event, transition, and error across all
/// blocs, for free, with no per-bloc setup.
///
/// Only logs *type names* for events/states — never their field values —
/// since bloc states in this app will often carry domain data (cycle
/// entries, symptoms, notes). If a specific transition needs more context
/// for debugging, log it explicitly from inside that bloc with a
/// hand-picked, reviewed-safe payload — don't widen what this global
/// observer captures.
///
/// Install once in `main()`, after `AppLoggerInitializer.init()`:
/// ```dart
/// Bloc.observer = AppBlocObserver();
/// ```
class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    AppLogger.instance.debug(bloc.runtimeType.toString(), 'Created');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    AppLogger.instance.debug(bloc.runtimeType.toString(), 'Event received', {
      'event': event.runtimeType.toString(),
    });
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    AppLogger.instance.debug(bloc.runtimeType.toString(), 'Transition', {
      'event': transition.event.runtimeType.toString(),
      'from': transition.currentState.runtimeType.toString(),
      'to': transition.nextState.runtimeType.toString(),
    });
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    AppLogger.instance.debug(bloc.runtimeType.toString(), 'State changed', {
      'from': change.currentState.runtimeType.toString(),
      'to': change.nextState.runtimeType.toString(),
    });
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    AppLogger.instance.error(
      bloc.runtimeType.toString(),
      'Bloc error',
      error: error,
      stackTrace: stackTrace,
    );
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    AppLogger.instance.debug(bloc.runtimeType.toString(), 'Closed');
  }
}
