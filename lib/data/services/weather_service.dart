import 'dart:convert';

import 'package:http/http.dart' as http;

class WeatherService {
  Future<Map<String, dynamic>> getWeather() async {
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast'
      '?latitude=43.238949'
      '&longitude=76.889709'
      '&current=temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m'
      '&hourly=temperature_2m,weather_code'
      '&daily=weather_code,temperature_2m_max,temperature_2m_min'
      '&timezone=Asia%2FAlmaty'
      '&forecast_days=7',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data is Map<String, dynamic>) {
        return data;
      }

      throw Exception('Пустые данные');
    }

    throw Exception('Не удалось загрузить погоду: ${response.statusCode}');
  }
}
