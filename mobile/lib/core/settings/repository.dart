import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart'; // your freezed models

class SettingsRepository {
  static const _key = 'periodt_settings';

  Future<PeriodtSettings?> loadSettings() async {
    final preferences = await SharedPreferences.getInstance();
    final jsonString = preferences.getString(_key);

    if (jsonString == null) {
      return null;
    }

    final jsonMap = jsonDecode(jsonString);
    return PeriodtSettings.fromJson(jsonMap);
  }

  Future<void> saveSettings(PeriodtSettings settings) async {
    final preferences = await SharedPreferences.getInstance();

    final json = settings.toJson();
    final encoded = jsonEncode(json);

    await preferences.setString(_key, encoded);
  }
}
