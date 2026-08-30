import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:periodt/core/form/models/form.dart';
import 'package:periodt/core/form/models/wizard.dart';
import 'package:periodt/core/settings/models.dart';
import 'package:periodt/core/utilities/range.dart';
import 'package:periodt/features/setup/data/pages/cycle_length.dart';
import 'package:periodt/features/setup/data/pages/last_period.dart';
import 'package:periodt/features/setup/data/pages/period_length.dart';
import 'package:periodt/features/setup/data/pages/user.dart';

class SetupFormState {
  final String name;
  final Range<int> cycleLength;
  final Range<int> periodLength;
  final Range<DateTime> lastPeriod;

  SetupFormState({
    required this.name,
    required this.cycleLength,
    required this.periodLength,
    required this.lastPeriod,
  });
}

class SetupFormController extends PeriodtWizardController<SetupFormState> {
  final UserPageState user = UserPageState.initial();
  final CycleLengthPageState cycleLength = CycleLengthPageState.initial();
  final PeriodLengthPageState periodLength = PeriodLengthPageState.initial();
  final LastPeriodPageState lastPeriod = LastPeriodPageState.initial();

  final SubmitFunction<SetupFormState> onSubmit;

  SetupFormController({required this.onSubmit});

  @override
  List<PeriodtFormPage> get steps => [
    user,
    cycleLength,
    periodLength,
    lastPeriod,
  ];

  @override
  void submit(SetupFormState value) {
    onSubmit(value);
  }

  @override
  SetupFormState get value => SetupFormState(
    name: user.name.field,
    cycleLength: cycleLength.cycleLength.field,
    periodLength: periodLength.periodLength.field,
    lastPeriod: Range(upper: DateTime.now(), lower: DateTime.now()),
  );

  PeriodtSettings intoSettings() {
    return PeriodtSettings(user: user.intoUserSettings());
  }
}

SetupFormController useSetupForm({
  required SubmitFunction<SetupFormState> onSubmit,
}) {
  final controller = useMemoized(() => SetupFormController(onSubmit: onSubmit));

  useEffect(() {
    return controller.dispose;
  }, [controller]);

  return useListenable(controller);
}
