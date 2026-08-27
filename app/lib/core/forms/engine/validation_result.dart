sealed class ValidationResult<T, E> {
  const ValidationResult();
}

class Valid<T, E> extends ValidationResult<T, E> {
  final T value;

  const Valid(this.value);
}

class Invalid<T, E> extends ValidationResult<T, E> {
  final E error;

  const Invalid(this.error);
}
