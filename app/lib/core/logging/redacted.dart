class Redacted<T> {
  const Redacted(this.value);

  final T value;

  @override
  String toString() => '[REDACTED]';
}
