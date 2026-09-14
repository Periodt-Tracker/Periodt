import 'package:app/core/utilities/result.dart';
import 'package:app/features/security/domain/pin.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum PinReadError {
  storageError,
}

enum PinSetError {
  storageError,
}

enum PinValidationError {
  missingPin,
  storageError,
}

const _pinStorageKey = 'periodt-pin';

abstract interface class PinRepository {
  /// Loads the PIN state from secure storage.
  ///
  /// `Ok(true)`  -> PIN is configured.
  /// `Ok(false)` -> PIN is not configured.
  Future<Result<bool, PinReadError>> isPinSetup();

  Future<Result<void, PinSetError>> setPin(PinType pin);

  Future<Result<bool, PinValidationError>> verifyPin(PinType pin);
}

class SecureStoragePinRepository implements PinRepository {
  SecureStoragePinRepository({
    required FlutterSecureStorage secureStorage,
  }) : _secureStorage = secureStorage;

  final FlutterSecureStorage _secureStorage;

  String? _pinHash;
  bool _hasLoaded = false;

  @override
  Future<Result<bool, PinReadError>> isPinSetup() async {
    if (_hasLoaded) {
      return Ok(_pinHash != null);
    }

    try {
      _pinHash = await _secureStorage.read(
        key: _pinStorageKey,
      );

      _hasLoaded = true;

      return Ok(_pinHash != null);
    } on PlatformException {
      return const Err(PinReadError.storageError);
    }
  }

  @override
  Future<Result<void, PinSetError>> setPin(PinType pin) async {
    final hash = BCrypt.hashpw(
      pin.value,
      BCrypt.gensalt(),
    );

    try {
      await _secureStorage.write(
        key: _pinStorageKey,
        value: hash,
      );

      _pinHash = hash;
      _hasLoaded = true;

      return const Ok(null);
    } on PlatformException {
      return const Err(PinSetError.storageError);
    }
  }

  @override
  Future<Result<bool, PinValidationError>> verifyPin(
    PinType pin,
  ) async {
    if (!_hasLoaded) {
      final setupResult = await isPinSetup();

      if (setupResult case Err()) {
        return const Err(PinValidationError.storageError);
      }
    }

    final hash = _pinHash;

    if (hash == null) {
      return const Err(PinValidationError.missingPin);
    }

    return Ok(
      BCrypt.checkpw(pin.value, hash),
    );
  }
}
