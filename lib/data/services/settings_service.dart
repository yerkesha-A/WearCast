import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _temperatureUnitKey = 'temperature_unit';

  Future<String> getTemperatureUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_temperatureUnitKey) ?? 'C';
  }

  Future<void> setTemperatureUnit(String unit) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_temperatureUnitKey, unit);
  }
}
