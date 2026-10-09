class WeatherEntity {
  final double temperature;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int weatherCode;

  const WeatherEntity({
    required this.temperature,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
  });

  factory WeatherEntity.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;

    return WeatherEntity(
      temperature: (current['temperature_2m'] as num).toDouble(),
      feelsLike: (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
    );
  }
}
