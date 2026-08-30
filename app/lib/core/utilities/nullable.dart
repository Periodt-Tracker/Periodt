class Nullable<T> {
  final T? _value;

  const Nullable(this._value);

  factory Nullable.empty() => Nullable(null);

  factory Nullable.of(T? value) => Nullable(value);

  T? get value => _value;

  bool get isNull => _value == null;

  bool get isNotNull => _value != null;
}
