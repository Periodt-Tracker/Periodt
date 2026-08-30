sealed class PeriodtPageState<T> {
  const PeriodtPageState();
}

class Incomplete<T> extends PeriodtPageState<T> {
  const Incomplete();
}

class Answered<T> extends PeriodtPageState<T> {
  const Answered(this.answer);

  final T answer;
}

sealed class SkippablePageState<T> extends PeriodtPageState<T> {
  const SkippablePageState();
}

class Skipped<T> extends SkippablePageState<T> {
  const Skipped();
}

class CompletedInvalid<T> extends SkippablePageState<T> {
  const CompletedInvalid();
}

class CompletedValid<T> extends SkippablePageState<T> {
  const CompletedValid(this.answer);

  final T answer;
}
