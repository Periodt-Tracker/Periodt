sealed class OptionalPage<T> {
  const OptionalPage();
}

sealed class Disabled<T> extends OptionalPage<T> {
  const Disabled();
}

sealed class Skipped<T> extends OptionalPage<T> {
  const Skipped();
}

sealed class Completed<T> extends OptionalPage<T> {
  final T value;

  const Completed({required this.value});
}
