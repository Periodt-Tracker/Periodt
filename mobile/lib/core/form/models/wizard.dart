import 'package:flutter/material.dart';
import 'package:periodt/core/form/models/form.dart';

typedef SubmitFunction<T> = void Function(T value);

abstract class PeriodtWizardController<T> extends ChangeNotifier {
  final PageController controller = PageController();

  List<PeriodtFormPage> get steps;

  void submit(T value);

  int currentStep = 0;

  bool next() {
    if (!pageValid) {
      return false;
    }

    if (isLastPage) {
      submit(value);
      return true;
    }

    controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    currentStep++;
    notifyListeners();

    return true;
  }

  bool back({int? to}) {
    final targetPage = to ?? currentStep - 1;

    if (targetPage < 0 || targetPage >= currentStep) {
      return false;
    }

    controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    currentStep--;
    notifyListeners();

    return true;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  T get value;

  Listenable get listenable =>
      Listenable.merge([controller, ...steps.map((step) => step.listenable)]);

  PeriodtFormPage get current => steps[currentStep];

  int get stepCount => steps.length;

  bool get isLastPage => currentStep == stepCount - 1;

  bool get pageValid => current.isValid;

  bool get pageSkippable => current.skippable;

  bool get canGoBack => currentStep > 0;

  bool get canContinue => pageValid && !isLastPage;

  bool get isValid => steps.every((step) => step.isValid);
}
