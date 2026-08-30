typedef ValidatorFn<T, E> = E? Function(T?);

class Validator {
  static ValidatorFn<T, E> required<T, E>(E error) {
    return (T? value) {
      if (value == null) {
        return error;
      }

      if (value is String && value.trim().isEmpty) {
        return error;
      }

      if (value is List && value.isEmpty) {
        return error;
      }

      return null;
    };
  }

  static ValidatorFn<int, E> max<E>(int limit, E error) {
    return (int? value) {
      if (value == null) {
        return null;
      }

      if (value > limit) {
        return error;
      }

      return null;
    };
  }

  static ValidatorFn<int, E> min<E>(int limit, E error) {
    return (int? value) {
      if (value == null) {
        return null;
      }

      if (value < limit) {
        return error;
      }

      return null;
    };
  }

  static ValidatorFn<num, E> between<E>(num min, num max, E error) {
    return (num? value) {
      if (value == null) {
        return null;
      }

      if (value < min || value > max) {
        return error;
      }

      return null;
    };
  }

  static ValidatorFn<String, E> minLength<E>(int limit, E error) {
    return (String? value) {
      if (value == null) {
        return null;
      }

      if (value.length < limit) {
        return error;
      }

      return null;
    };
  }

  static ValidatorFn<String, E> maxLength<E>(int limit, E error) {
    return (String? value) {
      if (value == null) {
        return null;
      }

      if (value.length > limit) {
        return error;
      }

      return null;
    };
  }

  static ValidatorFn<String, E> matches<E>(RegExp pattern, E error) {
    return (String? value) {
      if (value == null) {
        return null;
      }

      if (!pattern.hasMatch(value)) {
        return error;
      }

      return null;
    };
  }

  static ValidatorFn<DateTime, E> notInFuture<E>(E error) {
    return (DateTime? value) {
      if (value == null) {
        return null;
      }

      if (value.isAfter(DateTime.now())) {
        return error;
      }

      return null;
    };
  }

  static ValidatorFn<DateTime, E> notInPast<E>(E error) {
    return (DateTime? value) {
      if (value == null) {
        return null;
      }

      if (value.isBefore(DateTime.now())) {
        return error;
      }

      return null;
    };
  }

  static ValidatorFn<DateTime, E> after<E>(DateTime limit, E error) {
    return (DateTime? value) {
      if (value == null) {
        return null;
      }

      if (value.isBefore(limit)) {
        return error;
      }

      return null;
    };
  }

  static ValidatorFn<DateTime, E> before<E>(DateTime limit, E error) {
    return (DateTime? value) {
      if (value == null) {
        return null;
      }

      if (value.isAfter(limit)) {
        return error;
      }

      return null;
    };
  }

  static ValidatorFn<List<T>, E> minItems<T, E>(int limit, E error) {
    return (List<T>? value) {
      if (value == null) {
        return null;
      }

      if (value.length < limit) {
        return error;
      }

      return null;
    };
  }

  static ValidatorFn<List<T>, E> maxItems<T, E>(int limit, E error) {
    return (List<T>? value) {
      if (value == null) {
        return null;
      }

      if (value.length > limit) {
        return error;
      }

      return null;
    };
  }

  static ValidatorFn<T, E> custom<T, E>(bool Function(T?) fn, E error) {
    return (T? value) {
      if (fn(value)) {
        return error;
      }

      return null;
    };
  }
}
