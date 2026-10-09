import 'package:flutter/material.dart';

import '../../domain/repositories/weather_repository.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherRepository _weatherRepository;

  WeatherProvider({required this._weatherRepository});

  Map<String, dynamic>? _weather;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadWeather() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await _weatherRepository.getWeather();
    } catch (e) {
      _error = 'Не удалось загрузить погоду';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshWeather() async {
    await loadWeather();
  }
}
