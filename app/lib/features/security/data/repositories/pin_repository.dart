import 'dart:convert';

import 'package:app/core/utilities/result.dart';
import 'package:app/features/security/domain/pin.dart';
import 'package:cryptography/cryptography.dart';
import 'package:cryptography/helpers.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum PinValidationError {
  invalidPin,
}

const _pinStorageKey = 'periodt-pin';

class PinRepository {
  PinRepository({
    required FlutterSecureStorage storage,
  }) : _storage = storage;

  final FlutterSecureStorage _storage;

  String? _cachedPinHash;
  List<int>? _cachedPinSalt;

  final _algorithm = Argon2id(
    parallelism: 1,
    memory: 19 * 1024, // 19 MiB
    iterations: 2,
    hashLength: 32,
  );

  Future<bool> isPinConfigured() async {
    final credentials = await _loadCredentials();

    return credentials != null;
  }

  Future<void> setPin(PinType pin) async {
    final salt = Cryptography.instance.random.nextBytes(32);

    final hash = await _hashPin(
      pin: pin,
      salt: salt,
    );

    final credentials = jsonEncode({
      'version': 1,
      'salt': base64UrlEncode(salt),
      'hash': base64UrlEncode(hash),
    });

    await _storage.write(
      key: _pinStorageKey,
      value: credentials,
    );

    _cachedPinHash = base64UrlEncode(hash);
    _cachedPinSalt = salt;
  }

  Future<Result<void, PinValidationError>> verifyPin(
    PinType pin,
  ) async {
    final credentials = await _loadCredentials();

    if (credentials == null) {
      return const Err(PinValidationError.invalidPin);
    }

    final hash = await _hashPin(
      pin: pin,
      salt: credentials.salt,
    );

    final expectedHash = base64Url.decode(credentials.hash);

    final isValid = constantTimeBytesEquality.equals(
      hash,
      expectedHash,
    );

    if (!isValid) {
      return const Err(PinValidationError.invalidPin);
    }

    return const Ok(null);
  }

  Future<void> clearPin() async {
    await _storage.delete(key: _pinStorageKey);

    _cachedPinHash = null;
    _cachedPinSalt = null;
  }

  Future<List<int>> _hashPin({
    required PinType pin,
    required List<int> salt,
  }) async {
    final secretKey = await _algorithm.deriveKeyFromPassword(
      password: pin.value,
      nonce: salt,
    );

    return secretKey.extractBytes();
  }

  Future<_PinCredentials?> _loadCredentials() async {
    if (_cachedPinHash != null && _cachedPinSalt != null) {
      return _PinCredentials(
        hash: _cachedPinHash!,
        salt: _cachedPinSalt!,
      );
    }

    final encoded = await _storage.read(
      key: _pinStorageKey,
    );

    if (encoded == null) {
      return null;
    }

    final decoded = jsonDecode(encoded);

    if (decoded is! Map<String, dynamic>) {
      return null;
    }

    final saltString = decoded['salt'];
    final hashString = decoded['hash'];

    if (saltString is! String || hashString is! String) {
      return null;
    }

    final salt = base64Url.decode(saltString);

    _cachedPinHash = hashString;
    _cachedPinSalt = salt;

    return _PinCredentials(
      hash: hashString,
      salt: salt,
    );
  }
}

class _PinCredentials {
  const _PinCredentials({
    required this.hash,
    required this.salt,
  });

  final String hash;
  final List<int> salt;
}
