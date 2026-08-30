import 'package:flutter/foundation.dart';
import 'field.dart';

typedef SubmitFunction<T> = void Function(T value);

/// Represents a single page or section within a form wizard.
///
/// Operates as a scoped [ChangeNotifier] that listens to its own [fields].
/// It only alerts its listeners (e.g., the WizardController) when the *overall* /// validity of the page changes, preventing excessive rebuilds on every keystroke.
abstract class PeriodtFormPage extends ChangeNotifier {
  /// Tracks the previous validity state to determine if listeners should be notified.
  bool _previousValidState = false;

  PeriodtFormPage() {
    for (var field in fields) {
      field.addListener(_onFieldChanged);
    }
    // Initialize the starting state
    _previousValidState = isValid;
  }

  /// The list of [PeriodtField] instances contained on this page.
  List<PeriodtField> get fields;

  /// Whether the user is allowed to skip this page without filling it out.
  bool get skippable => false;

  /// Internal listener attached to all fields.
  void _onFieldChanged() {
    final currentValidState = isValid;
    if (_previousValidState != currentValidState) {
      _previousValidState = currentValidState;
      notifyListeners();
    }
  }

  /// Returns `true` if every field on this page is valid.
  bool get isValid => fields.every((field) => field.isValid);

  /// Returns `true` if no fields on this page have been touched.
  bool get isPure => fields.every((field) => !field.touched);

  /// Returns `true` if at least one field on this page has been touched.
  bool get isDirty => !isPure;

  /// Marks all fields on this page as touched.
  ///
  /// Typically called when a user attempts to submit or skip the page prematurely,
  /// forcing the UI to reveal any hidden validation errors.
  void touchAll() {
    for (var field in fields) {
      field.touch();
    }
  }

  @override
  void dispose() {
    for (var field in fields) {
      field.removeListener(_onFieldChanged);
      field.dispose();
    }
    super.dispose();
  }
}
