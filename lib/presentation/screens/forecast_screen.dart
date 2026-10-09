import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';
import '../widgets/app_background.dart';

bool _forecastIsLight(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light;

Color _forecastTextColor(BuildContext context) =>
    _forecastIsLight(context) ? const Color(0xFF17213B) : Colors.white;

Color _forecastMutedColor(BuildContext context) => _forecastIsLight(context)
    ? const Color(0xFF68738B)
    : const Color(0xFFB9C0C7);

Color _forecastCardColor(BuildContext context) => _forecastIsLight(context)
    ? Colors.white.withValues(alpha: 0.85)
    : Colors.white.withValues(alpha: 0.07);

Color _forecastBorderColor(BuildContext context) =>
    Colors.white.withValues(alpha: _forecastIsLight(context) ? 0.95 : 0.11);

class ForecastScreen extends StatefulWidget {
  const ForecastScreen({super.key});

  @override
  State<ForecastScreen> createState() => _ForecastScreenState();
}

class _ForecastScreenState extends State<ForecastScreen> {
  String _temp(dynamic value) {
    if (value is num) {
      return '${value.round()}°';
    }
    return '--°';
  }

  String _weatherDescription(int code) {
    if (code == 0) return 'Ясно';
    if (code == 1) return 'Преим. ясно';
    if (code == 2) return 'Переменная облачность';
    if (code == 3) return 'Облачно';

    if (code == 45 || code == 48) {
      return 'Туман';
    }

    if (code >= 51 && code <= 57) {
      return 'Морось';
    }

    if (code >= 61 && code <= 67) {
      return 'Дождь';
    }

    if (code >= 71 && code <= 77) {
      return 'Снег';
    }

    if (code >= 80 && code <= 82) {
      return 'Ливень';
    }

    if (code == 85 || code == 86) {
      return 'Снегопад';
    }

    if (code >= 95) {
      return 'Гроза';
    }

    return 'Погода';
  }

  IconData _weatherIcon(int code) {
    if (code == 0 || code == 1) {
      return Icons.wb_sunny_rounded;
    }

    if (code == 2) {
      return Icons.wb_cloudy_outlined;
    }

    if (code == 3) {
      return Icons.cloud_rounded;
    }

    if (code == 45 || code == 48) {
      return Icons.blur_on_rounded;
    }

    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      return Icons.water_drop_rounded;
    }

    if ((code >= 71 && code <= 77) || code == 85 || code == 86) {
      return Icons.ac_unit_rounded;
    }

    if (code >= 95) {
      return Icons.thunderstorm_rounded;
    }

    return Icons.cloud_outlined;
  }

  Color _weatherColor(int code) {
    if (code == 0 || code == 1) {
      return const Color(0xFFFFD16B);
    }

    return const Color(0xFF9EDFFF);
  }

  String _dayName(String dateString, int index) {
    if (index == 0) {
      return 'Сегодня';
    }

    final date = DateTime.tryParse(dateString);

    if (date == null) {
      return '—';
    }

    const names = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

    return names[date.weekday - 1];
  }

  String _monthName(int month) {
    const months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря',
    ];

    return months[month - 1];
  }

  String _dateText() {
    final now = DateTime.now();

    return '${now.day} ${_monthName(now.month)}';
  }

  List<_HourForecast> _getHourlyForecast(Map<String, dynamic> hourly) {
    final times = hourly['time'] as List? ?? [];
    final temperatures = hourly['temperature_2m'] as List? ?? [];
    final codes = hourly['weather_code'] as List? ?? [];

    final result = <_HourForecast>[];

    if (times.isEmpty || temperatures.isEmpty || codes.isEmpty) {
      return result;
    }

    final now = DateTime.now();

    int startIndex = 0;

    for (int i = 0; i < times.length; i++) {
      final date = DateTime.tryParse(times[i].toString());

      if (date != null && !date.isBefore(now)) {
        startIndex = i;
        break;
      }
    }

    // Берём ближайшие часы с шагом 2 часа.
    for (int i = 0; i < 5; i++) {
      final index = startIndex + (i * 2);

      if (index >= times.length ||
          index >= temperatures.length ||
          index >= codes.length) {
        break;
      }

      final date = DateTime.tryParse(times[index].toString());

      if (date == null) continue;

      final hour = date.hour.toString().padLeft(2, '0');

      result.add(
        _HourForecast(
          time: i == 0 ? 'Сейчас' : '$hour:00',
          temperature: (temperatures[index] as num).toDouble(),
          weatherCode: (codes[index] as num).round(),
        ),
      );
    }

    return result;
  }

  List<_DayForecast> _getDailyForecast(Map<String, dynamic> daily) {
    final times = daily['time'] as List? ?? [];
    final maxTemperatures = daily['temperature_2m_max'] as List? ?? [];
    final minTemperatures = daily['temperature_2m_min'] as List? ?? [];
    final codes = daily['weather_code'] as List? ?? [];

    final result = <_DayForecast>[];

    final length = [
      times.length,
      maxTemperatures.length,
      minTemperatures.length,
      codes.length,
    ].reduce((a, b) => a < b ? a : b);

    for (int i = 0; i < length; i++) {
      result.add(
        _DayForecast(
          date: times[i].toString(),
          maxTemperature: (maxTemperatures[i] as num).toDouble(),
          minTemperature: (minTemperatures[i] as num).toDouble(),
          weatherCode: (codes[i] as num).round(),
        ),
      );
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF7F8FC)
          : const Color(0xFF111315),
      body: Stack(
        children: [
          if (Theme.of(context).brightness == Brightness.light)
            const Positioned.fill(
              child: AppBackground(child: SizedBox.expand()),
            ),
          if (Theme.of(context).brightness == Brightness.dark)
            const Positioned(
              top: -120,
              right: -80,
              child: _GlowBlob(size: 330, color: Color(0xFF68CFFF)),
            ),
          if (Theme.of(context).brightness == Brightness.dark)
            const Positioned(
              top: 360,
              left: -160,
              child: _GlowBlob(size: 360, color: Color(0xFF8A79FF)),
            ),
          if (Theme.of(context).brightness == Brightness.dark)
            const Positioned(
              bottom: -130,
              right: -100,
              child: _GlowBlob(size: 330, color: Color(0xFFFFB77A)),
            ),

          Positioned(
            right: -80,
            top: 210,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
            ),
          ),

          Positioned(
            right: -25,
            top: 265,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
            ),
          ),

          DefaultTextStyle.merge(
            style: TextStyle(color: _forecastTextColor(context)),
            child: SafeArea(child: _buildContent(weatherProvider)),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(WeatherProvider weatherProvider) {
    final weather = weatherProvider.weather;
    final isLoading = weatherProvider.isLoading;
    final error = weatherProvider.error;
    if (isLoading) {
      return Center(child: CircularProgressIndicator(color: Color(0xFF8EDFFF)));
    }

    if (error != null || weather == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.cloud_off_rounded,
                color: Color(0xFF9EDFFF),
                size: 50,
              ),
              const SizedBox(height: 16),
              Text(
                error ?? 'Нет данных',
                style: TextStyle(
                  color: _forecastTextColor(context),
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: weatherProvider.refreshWeather,
                icon: const Icon(Icons.refresh_rounded),
                label: Text('Повторить'),
              ),
            ],
          ),
        ),
      );
    }

    final current = weather['current'] as Map<String, dynamic>?;

    final hourly = weather['hourly'] as Map<String, dynamic>?;

    final daily = weather['daily'] as Map<String, dynamic>?;

    if (current == null || hourly == null || daily == null) {
      return Center(
        child: Text(
          'Нет данных о погоде',
          style: TextStyle(color: _forecastTextColor(context)),
        ),
      );
    }

    final temperature = (current['temperature_2m'] as num).toDouble();

    final weatherCode = (current['weather_code'] as num).round();

    final hours = _getHourlyForecast(hourly);
    final days = _getDailyForecast(daily);

    final todayMax = days.isNotEmpty ? days.first.maxTemperature : temperature;

    final todayMin = days.isNotEmpty ? days.first.minTemperature : temperature;

    return RefreshIndicator(
      onRefresh: weatherProvider.refreshWeather,
      color: const Color(0xFF8EDFFF),
      backgroundColor: const Color(0xFF1A1D20),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 130),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Прогноз',
                          style: TextStyle(
                            fontSize: 31,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Алматы  •  ${_dateText()}',
                          style: TextStyle(
                            color: _forecastMutedColor(context),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const _CircleButton(icon: Icons.calendar_month_outlined),
                  ],
                ),

                const SizedBox(height: 28),

                // СЕГОДНЯ
                ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      height: 235,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(34),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: _forecastIsLight(context)
                              ? [
                                  Colors.white.withValues(alpha: 0.92),
                                  const Color(0xFFE5EFFF)
                                      .withValues(alpha: 0.88),
                                  Colors.white.withValues(alpha: 0.84),
                                ]
                              : [
                                  Colors.white.withValues(alpha: 0.16),
                                  const Color(0xFF8AD8F8)
                                      .withValues(alpha: 0.12),
                                  Colors.white.withValues(alpha: 0.05),
                                ],
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.16),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF7ED9FF)
                                .withValues(alpha: 0.15),
                            blurRadius: 35,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -45,
                            top: -65,
                            child: Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFFFD8A3)
                                    .withValues(alpha: 0.09),
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const _Pill(text: 'Сегодня'),
                                    Icon(
                                      _weatherIcon(weatherCode),
                                      color: _weatherColor(weatherCode),
                                      size: 44,
                                    ),
                                  ],
                                ),

                                const Spacer(),

                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      _temp(temperature),
                                      style: TextStyle(
                                        fontSize: 68,
                                        height: 0.9,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),

                                    const SizedBox(width: 14),

                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 5,
                                        ),
                                        child: Text(
                                          '${_weatherDescription(weatherCode)}\n${_temp(todayMax)} / ${_temp(todayMin)}',
                                          maxLines: 3,
                                          style: TextStyle(
                                            color: _forecastMutedColor(context),
                                            height: 1.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  'В течение дня',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 14),

                // ПОЧАСОВОЙ ПРОГНОЗ
                if (hours.isEmpty)
                  const _EmptyCard(text: 'Нет почасового прогноза')
                else
                  SizedBox(
                    height: 135,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: hours.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final item = hours[index];

                        return Container(
                          width: 105,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: _forecastCardColor(context),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: _forecastBorderColor(context),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                item.time,
                                style: TextStyle(
                                  color: _forecastMutedColor(context),
                                  fontSize: 12,
                                ),
                              ),
                              Icon(
                                _weatherIcon(item.weatherCode),
                                color: _weatherColor(item.weatherCode),
                              ),
                              Text(
                                _temp(item.temperature),
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                const SizedBox(height: 30),

                Text(
                  'Следующие дни',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 14),

                if (days.length <= 1)
                  const _EmptyCard(text: 'Нет прогноза на следующие дни')
                else
                  ...days.skip(1).map((day) {
                    final index = days.indexOf(day);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 17,
                      ),
                      decoration: BoxDecoration(
                        color: _forecastCardColor(context),
                        borderRadius: BorderRadius.circular(23),
                        border: Border.all(
                          color: _forecastBorderColor(context),
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 55,
                            child: Text(
                              _dayName(day.date, index),
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),

                          Icon(
                            _weatherIcon(day.weatherCode),
                            color: _weatherColor(day.weatherCode),
                          ),

                          const SizedBox(width: 13),

                          Expanded(
                            child: Text(
                              _weatherDescription(day.weatherCode),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: _forecastMutedColor(context),
                              ),
                            ),
                          ),

                          Text(
                            _temp(day.maxTemperature),
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Text(
                            _temp(day.minTemperature),
                            style: TextStyle(
                              color: _forecastMutedColor(context),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ========================================================
// МОДЕЛЬ ЧАСА
// ========================================================

class _HourForecast {
  final String time;
  final double temperature;
  final int weatherCode;

  const _HourForecast({
    required this.time,
    required this.temperature,
    required this.weatherCode,
  });
}

// ========================================================
// МОДЕЛЬ ДНЯ
// ========================================================

class _DayForecast {
  final String date;
  final double maxTemperature;
  final double minTemperature;
  final int weatherCode;

  const _DayForecast({
    required this.date,
    required this.maxTemperature,
    required this.minTemperature,
    required this.weatherCode,
  });
}

// ========================================================
// GLOW
// ========================================================

class _GlowBlob extends StatelessWidget {
  final double size;
  final Color color;

  const _GlowBlob({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 85, sigmaY: 85),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.20),
        ),
      ),
    );
  }
}

// ========================================================
// PILL
// ========================================================

class _Pill extends StatelessWidget {
  final String text;

  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _forecastBorderColor(context),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Text(text),
    );
  }
}

// ========================================================
// CIRCLE BUTTON
// ========================================================

class _CircleButton extends StatelessWidget {
  final IconData icon;

  const _CircleButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _forecastCardColor(context),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Icon(icon),
    );
  }
}

// ========================================================
// EMPTY STATE
// ========================================================

class _EmptyCard extends StatelessWidget {
  final String text;

  const _EmptyCard({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: _forecastCardColor(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: _forecastMutedColor(context)),
      ),
    );
  }
}
