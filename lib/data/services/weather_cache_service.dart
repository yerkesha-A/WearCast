import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

class WeatherCacheService {
  static const String _boxName = 'weather_cache';
  static const String _weatherKey = 'last_weather';

  Future<void> saveWeather(Map<String, dynamic> weather) async {
    final box = await Hive.openBox<String>(_boxName);
    await box.put(_weatherKey, jsonEncode(weather));
  }

  Future<Map<String, dynamic>?> getWeather() async {
    final box = await Hive.openBox<String>(_boxName);
    final cached = box.get(_weatherKey);

    if (cached == null) return null;

    return jsonDecode(cached) as Map<String, dynamic>;
  }
}
