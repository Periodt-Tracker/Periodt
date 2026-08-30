import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const key = 'pin';

class PinState {
  static FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<String?> getPin() async {}
}
