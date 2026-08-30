import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'form.dart';

/// A controller that manages pagination, validation, and submission of a multi-step form.
abstract class PeriodtWizardController<T> extends ChangeNotifier {
  /// The underlying Flutter [PageController] used to animate between form steps.
  final PageController pageController = PageController();

  int _currentStep = 0;

  PeriodtWizardController() {
    current.addListener(_onCurrentPageChanged);
  }

  /// The ordered list of pages that make up this wizard.
  List<PeriodtFormPage> get steps;

  /// Compiles and returns the final value [T] representing the entire form's data.
  T get value;

  /// Called when the wizard successfully reaches the end and the final "Next" or "Submit"
  /// action is triggered.
  void submit(T value);

  /// The index of the active step.
  int get currentStep => _currentStep;

  /// Returns the [PeriodtFormPage] instance of the currently active step.
  PeriodtFormPage get current => steps[_currentStep];

  /// The total number of steps in the wizard.
  int get stepCount => steps.length;

  /// Returns `true` if the user is on the final step of the wizard.
  bool get isLastPage => _currentStep == stepCount - 1;

  /// Returns `true` if the current page is valid.
  bool get pageValid => current.isValid;

  /// Returns `true` if the current page is configured to be skippable.
  bool get pageSkippable => current.skippable;

  /// Returns `true` if there is a previous page to go back to.
  bool get canGoBack => _currentStep > 0;

  /// Returns `true` if the user is allowed to proceed to the next step.
  bool get canContinue => pageValid || pageSkippable;

  /// Internal listener that triggers when the current page toggles between valid/invalid.
  void _onCurrentPageChanged() {
    notifyListeners();
  }

  /// Attempts to advance to the next step or submit the form.
  ///
  /// If the current page is invalid and not skippable, it will call `touchAll()`
  /// on the current page to display errors and return `false`.
  ///
  /// Returns `true` if the transition or submission was successful.
  bool next() {
    if (!canContinue) {
      current.touchAll();
      return false;
    }

    if (isLastPage) {
      submit(value);
      return true;
    }

    _transitionPage(1);
    return true;
  }

  /// Attempts to navigate backwards in the wizard.
  ///
  /// You can optionally provide a specific [to] index.
  /// Returns `true` if the backward transition was successful.
  bool back({int? to}) {
    final targetStep = to ?? _currentStep - 1;
    if (targetStep < 0 || targetStep >= _currentStep) return false;

    _transitionPage(targetStep - _currentStep);
    return true;
  }

  /// Handles animating the [pageController] and migrating listeners.
  void _transitionPage(int delta) {
    current.removeListener(_onCurrentPageChanged);
    _currentStep += delta;
    current.addListener(_onCurrentPageChanged);

    pageController.animateToPage(
      _currentStep,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    notifyListeners();
  }

  @override
  void dispose() {
    current.removeListener(_onCurrentPageChanged);
    pageController.dispose();
    super.dispose();
  }
}
