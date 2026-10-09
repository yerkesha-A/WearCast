import '../../domain/repositories/weather_repository.dart' as domain;
import '../../domain/entities/weather_entity.dart';

import '../services/weather_service.dart';
import '../services/weather_cache_service.dart';

class WeatherRepository implements domain.WeatherRepository {
  final WeatherService _weatherService;
  final WeatherCacheService _cacheService;

  WeatherRepository({
    WeatherService? weatherService,
    WeatherCacheService? cacheService,
  }) : _weatherService = weatherService ?? WeatherService(),
       _cacheService = cacheService ?? WeatherCacheService();

  @override
  Future<Map<String, dynamic>> getWeather() async {
    try {
      // Получаем актуальную погоду через интернет
      final json = await _weatherService.getWeather();

      // Преобразуем данные в WeatherEntity
      final weather = WeatherEntity.fromJson(json);

      final result = {
        ...json,
        'current': {
          ...json['current'] as Map<String, dynamic>,
          'temperature_2m': weather.temperature,
          'apparent_temperature': weather.feelsLike,
          'relative_humidity_2m': weather.humidity,
          'wind_speed_10m': weather.windSpeed,
          'weather_code': weather.weatherCode,
        },
      };

      // Сохраняем последнюю загруженную погоду
      try {
        await _cacheService.saveWeather(result);
      } catch (_) {
        // Ошибка кеша не должна мешать показу погоды
      }

      return result;
    } catch (_) {
      // Если интернет недоступен, пробуем загрузить кеш
      final cachedWeather = await _cacheService.getWeather();

      if (cachedWeather != null) {
        return cachedWeather;
      }

      throw Exception(
        'Не удалось загрузить погоду. Нет интернета и сохранённых данных.',
      );
    }
  }
}
