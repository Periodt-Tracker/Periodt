class Optional<T> {
  final T? value;

  const Optional(this.value);

  factory Optional.empty() => const Optional(null);

  factory Optional.of(T? value) => Optional(value);
}
