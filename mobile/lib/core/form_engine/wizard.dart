import 'package:flutter/material.dart';
import 'package:periodt/core/form_engine/page.dart';

abstract class PeriodtWizard extends ChangeNotifier {
  final PageController pageController = PageController();

  int _currentStep = 0;

  List<PeriodtWizardPage> get pages;

  int get currentPageIndex => _currentStep;

  int get totalPages => pages.length;
}
