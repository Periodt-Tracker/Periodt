import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:periodt/core/database/models/daily-log.dart';
import 'package:periodt/core/form/models/form.dart';
import 'package:periodt/core/form/models/wizard.dart';
import 'package:periodt/core/utilities/date.dart';
import 'package:periodt/features/symptom-tracker/data/pages/bleeding.dart';
import 'package:periodt/features/symptom-tracker/data/pages/discharge.dart';
import 'package:periodt/features/symptom-tracker/data/pages/mood.dart';

class DailyLogForm extends PeriodtWizardController<DailyLogBuilder> {
  final SubmitFunction<DailyLogBuilder> onSubmit;

  final bleeding = BleedingPage();
  final discharge = DischargePage();
  final mood = MoodPage();

  DailyLogForm({required this.onSubmit});

  @override
  void submit(value) => onSubmit(value);

  @override
  DailyLogBuilder get value {
    final date = DateUtils.nowIsoDate();

    return DailyLogBuilder(date: date, mood: mood.intoLog());
  }

  @override
  List<PeriodtFormPage> get steps => [bleeding, discharge, mood];
}

DailyLogForm useDailyLogForm({
  required SubmitFunction<DailyLogBuilder> onSubmit,
}) {
  final controller = useMemoized(() => DailyLogForm(onSubmit: onSubmit));

  useEffect(() {
    return controller.dispose;
  }, [controller]);

  return useListenable(controller);
}
