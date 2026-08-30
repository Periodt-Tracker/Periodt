import 'package:meta/meta.dart';

/// Enum representing the submission status of a form.
enum FormSubmissionStatus {
  /// The form has not yet been submitted.
  initial,

  /// The form is in the process of being submitted.
  inProgress,

  /// The form has been submitted successfully.
  success,

  /// The form submission failed.
  failure,

  /// The form submission has been canceled.
  canceled,
}

/// Useful extensions on [FormSubmissionStatus]
extension FormSubmissionStatusX on FormSubmissionStatus {
  /// Indicates whether the form has not yet been submitted.
  bool get isInitial => this == FormSubmissionStatus.initial;

  /// Indicates whether the form is in the process of being submitted.
  bool get isInProgress => this == FormSubmissionStatus.inProgress;

  /// Indicates whether the form has been submitted successfully.
  bool get isSuccess => this == FormSubmissionStatus.success;

  /// Indicates whether the form submission failed.
  bool get isFailure => this == FormSubmissionStatus.failure;

  /// Indicates whether the form submission has been canceled.
  bool get isCanceled => this == FormSubmissionStatus.canceled;

  /// Indicates whether the form is either in progress or has been submitted
  /// successfully.
  ///
  /// This is useful for showing a loading indicator or disabling the submit
  /// button to prevent duplicate submissions.
  bool get isInProgressOrSuccess => isInProgress || isSuccess;
}

/// {@template form_input}
/// A [FormInput] represents the value of a single form input field.
/// It contains information about the [value] as well as validity.
///
/// [FormInput] should be extended to define custom [FormInput] instances.
///
/// ```dart
/// enum FirstNameError { empty }
/// class FirstName extends FormzInput<String, FirstNameError> {
///   const FirstName.pure({String value = ''}) : super.pure(value);
///   const FirstName.dirty({String value = ''}) : super.dirty(value);
///
///   @override
///   FirstNameError? validator(String value) {
///     return value.isEmpty ? FirstNameError.empty : null;
///   }
/// }
/// ```
/// {@endtemplate}
@immutable
abstract class FormInput<T, E> {
  const FormInput._({required this.value, this.isPure = true});

  /// Constructor which create a `pure` [FormInput] with a given value.
  const FormInput.pure(T value) : this._(value: value);

  /// Constructor which create a `dirty` [FormInput] with a given value.
  const FormInput.dirty(T value) : this._(value: value, isPure: false);

  /// The value of the given [FormInput].
  /// For example, if you have a `FormzInput` for `FirstName`,
  /// the value could be 'Joe'.
  final T value;

  /// If the [FormInput] is pure (has been touched/modified).
  /// Typically when the `FormzInput` is initially created,
  /// it is created using the `FormzInput.pure` constructor to
  /// signify that the user has not modified it.
  ///
  /// For subsequent changes (in response to user input), the
  /// `FormzInput.dirty` constructor should be used to signify that
  /// the `FormzInput` has been manipulated.
  final bool isPure;

  /// Whether the [FormInput] value is valid according to the
  /// overridden `validator`.
  ///
  /// Returns `true` if `validator` returns `null` for the
  /// current [FormInput] value and `false` otherwise.
  bool get isValid => validator(value) == null;

  /// Whether the [FormInput] value is not valid.
  /// A value is invalid when the overridden `validator`
  /// returns an error (non-null value).
  bool get isNotValid => !isValid;

  /// Returns a validation error if the [FormInput] is invalid.
  /// Returns `null` if the [FormInput] is valid.
  E? get error => validator(value);

  /// The error to display if the [FormInput] value
  /// is not valid and has been modified.
  E? get displayError => isPure ? null : error;

  /// A function that must return a validation error if the provided
  /// [value] is invalid and `null` otherwise.
  E? validator(T value);

  @override
  int get hashCode => Object.hashAll([value, isPure]);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is FormInput<T, E> &&
        other.value == value &&
        other.isPure == isPure;
  }

  @override
  String toString() {
    return isPure
        ? '''FormzInput<$T, $E>.pure(value: $value, isValid: $isValid, error: $error)'''
        : '''FormzInput<$T, $E>.dirty(value: $value, isValid: $isValid, error: $error)''';
  }
}

/// Mixin for [FormInput] that caches the [error] result of the [validator].
/// Use this mixin when implementations that make expensive computations are
/// used, such as those involving regular expressions.
mixin FormzInputErrorCacheMixin<T, E> on FormInput<T, E> {
  late final E? _error = validator(value);

  @override
  E? get error => _error;

  @override
  bool get isValid => _error == null;
}

/// Class which contains methods that help manipulate and manage
/// validity of [FormInput] instances.
class Formz {
  /// Returns a [bool] given a list of [FormInput] indicating whether
  /// the inputs are all valid.
  static bool validate(List<FormInput<dynamic, dynamic>> inputs) {
    return inputs.every((input) => input.isValid);
  }

  /// Returns a [bool] given a list of [FormInput] indicating whether
  /// all the inputs are pure.
  static bool isPure(List<FormInput<dynamic, dynamic>> inputs) {
    return inputs.every((input) => input.isPure);
  }
}

/// Mixin that automatically handles validation of all [FormInput]s present in
/// the [inputs].
///
/// When mixing this in, you are required to override the [inputs] getter and
/// provide all [FormInput]s you want to automatically validate.
///
/// ```dart
/// class LoginFormState with FormzMixin {
///  LoginFormState({
///    this.username = const Username.pure(),
///    this.password = const Password.pure(),
///  });
///
///  final Username username;
///  final Password password;
///
///  @override
///  List<FormzInput> get inputs => [username, password];
/// }
/// ```
mixin FormzMixin {
  /// Whether the [FormInput] values are all valid.
  bool get isValid => Formz.validate(inputs);

  /// Whether the [FormInput] values are not all valid.
  bool get isNotValid => !isValid;

  /// Whether all of the [FormInput] are pure.
  bool get isPure => Formz.isPure(inputs);

  /// Whether at least one of the [FormInput]s is dirty.
  bool get isDirty => !isPure;

  /// Returns all [FormInput] instances.
  ///
  /// Override this and give it all [FormInput]s in your class that should be
  /// validated automatically.
  List<FormInput<dynamic, dynamic>> get inputs;
}
