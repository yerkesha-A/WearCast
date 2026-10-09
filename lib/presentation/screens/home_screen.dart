import 'package:go_router/go_router.dart';

import '../widgets/app_background.dart';

import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../providers/weather_provider.dart';

Color _wearText(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
    ? const Color(0xFF17213B)
    : Colors.white;

Color _wearMuted(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
    ? const Color(0xFF68738B)
    : const Color(0xFFAEB6BE);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _number(dynamic value) {
    if (value is num) {
      if (value % 1 == 0) {
        return value.toInt().toString();
      }
      return value.toStringAsFixed(1);
    }

    return '--';
  }

  String _roundedTemperature(dynamic value) {
    if (value is num) {
      return value.round().toString();
    }

    return '--';
  }

  String _weatherDescription(int code) {
    if (code == 0) return 'Ясно';
    if (code == 1) return 'Преимущественно ясно';
    if (code == 2) return 'Переменная облачность';
    if (code == 3) return 'Облачно';
    if (code == 45 || code == 48) return 'Туман';

    if (code == 51 || code == 53 || code == 55) {
      return 'Морось';
    }

    if (code == 56 || code == 57) {
      return 'Ледяная морось';
    }

    if (code == 61 || code == 63 || code == 65) {
      return 'Дождь';
    }

    if (code == 66 || code == 67) {
      return 'Ледяной дождь';
    }

    if (code == 71 || code == 73 || code == 75 || code == 77) {
      return 'Снег';
    }

    if (code == 80 || code == 81 || code == 82) {
      return 'Ливень';
    }

    if (code == 85 || code == 86) {
      return 'Снегопад';
    }

    if (code == 95 || code == 96 || code == 99) {
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

  String _aiAdvice(double temperature, int code) {
    if (code >= 95) {
      return 'Возможна гроза. Лучше взять непромокаемую верхнюю одежду и зонт.';
    }

    if ((code >= 51 && code <= 67) || (code >= 80 && code <= 82)) {
      return 'На улице дождливо. Возьми зонт и выбери непромокаемую обувь.';
    }

    if (temperature <= 0) {
      return 'Сегодня холодно. Тёплая куртка, шарф и закрытая обувь будут кстати.';
    }

    if (temperature < 10) {
      return 'Сегодня прохладно. Лучше надеть тёплую куртку и закрытую обувь.';
    }

    if (temperature < 17) {
      return 'На улице свежо. Лёгкая куртка или плотный свитер подойдут лучше всего.';
    }

    if (temperature < 24) {
      return 'Сегодня комфортная погода. Лёгкая куртка пригодится ближе к вечеру.';
    }

    return 'Сегодня тепло. Выбирай лёгкую одежду и не забудь про воду.';
  }

  String _outfitTitle(double temperature) {
    if (temperature < 5) return 'Тёплый и\nуютный';
    if (temperature < 15) return 'Уютный и\nкомфортный';
    if (temperature < 24) return 'Лёгкий и\nкомфортный';

    return 'Лёгкий и\nсвободный';
  }

  String _outfitItems(double temperature) {
    if (temperature < 5) {
      return 'Тёплая куртка • брюки • ботинки';
    }

    if (temperature < 15) {
      return 'Куртка • джинсы • кроссовки';
    }

    if (temperature < 24) {
      return 'Лёгкая куртка • джинсы • кроссовки';
    }

    return 'Футболка • лёгкие брюки • кроссовки';
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = context.watch<WeatherProvider>();

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF9F9FC)
          : const Color(0xFF101214),
      body: Stack(
        children: [
          if (Theme.of(context).brightness == Brightness.light)
            const Positioned.fill(
              child: AppBackground(child: SizedBox.expand()),
            ),
          if (Theme.of(context).brightness == Brightness.dark) ...[
            const Positioned(
              top: -140,
              right: -100,
              child: _GlowBlob(size: 350, color: Color(0xFF6ED7FF)),
            ),
            const Positioned(
              top: 430,
              left: -180,
              child: _GlowBlob(size: 380, color: Color(0xFF8076FF)),
            ),
            const Positioned(
              bottom: -140,
              right: -100,
              child: _GlowBlob(size: 350, color: Color(0xFFFFB46A)),
            ),
          ],

          Positioned(
            right: -90,
            top: 260,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.045),
                ),
              ),
            ),
          ),

          SafeArea(child: _buildContent(weatherProvider)),
        ],
      ),
    );
  }

  Widget _buildContent(WeatherProvider weatherProvider) {
    final weather = weatherProvider.weather;
    final isLoading = weatherProvider.isLoading;
    final error = weatherProvider.error;
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF8EDFFF)),
      );
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
              const SizedBox(height: 18),
              Text(
                error ?? 'Ошибка загрузки',
                style: TextStyle(
                  color: _wearText(context),
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

    final current = weather['current'] as Map<String, dynamic>;

    final daily = weather['daily'] as Map<String, dynamic>;

    final double temperature = (current['temperature_2m'] as num).toDouble();

    final double feelsLike = (current['apparent_temperature'] as num)
        .toDouble();

    final int humidity = (current['relative_humidity_2m'] as num).round();

    final double wind = (current['wind_speed_10m'] as num).toDouble();

    final int weatherCode = (current['weather_code'] as num).round();

    final List maxTemperatures = daily['temperature_2m_max'] as List;

    final List minTemperatures = daily['temperature_2m_min'] as List;

    final double maxTemperature = (maxTemperatures.first as num).toDouble();

    final double minTemperature = (minTemperatures.first as num).toDouble();

    final description = _weatherDescription(weatherCode);

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
                          'WearCast',
                          style: TextStyle(
                            fontSize: 31,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -1,
                            color: _wearText(context),
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Color(0xFFAEB6BE),
                            ),
                            SizedBox(width: 4),
                            Text(
                              'Алматы',
                              style: TextStyle(
                                color: _wearMuted(context),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const _RoundButton(icon: Icons.person_outline_rounded),
                  ],
                ),

                const SizedBox(height: 28),

                // ГЛАВНАЯ КАРТОЧКА ПОГОДЫ
                _GlassContainer(
                  radius: 34,
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    height: 285,
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          right: -65,
                          top: -80,
                          child: Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFFD98B)
                                  .withValues(alpha: 0.09),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFC66C)
                                      .withValues(alpha: 0.14),
                                  blurRadius: 80,
                                  spreadRadius: 20,
                                ),
                              ],
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const _Pill(text: 'Сегодня'),
                                  Container(
                                    width: 58,
                                    height: 58,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: const Color(0xFFFFD26A)
                                          .withValues(alpha: 0.10),
                                    ),
                                    child: Icon(
                                      _weatherIcon(weatherCode),
                                      color:
                                          Theme.of(context).brightness ==
                                              Brightness.light
                                          ? const Color(0xFF1768E8)
                                          : const Color(0xFFFFD36B),
                                      size: 37,
                                    ),
                                  ),
                                ],
                              ),

                              const Spacer(),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '${_roundedTemperature(temperature)}°',
                                    style: TextStyle(
                                      fontSize: 72,
                                      height: 0.9,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: -4,
                                      color: _wearText(context),
                                    ),
                                  ),

                                  const SizedBox(width: 16),

                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(bottom: 3),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            description,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: _wearText(context),
                                            ),
                                          ),
                                          const SizedBox(height: 5),
                                          Text(
                                            'Ощущается как ${_roundedTemperature(feelsLike)}°',
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: _wearMuted(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 19),

                              Row(
                                children: [
                                  Text(
                                    '${_roundedTemperature(minTemperature)}°',
                                    style: TextStyle(
                                      color: _wearMuted(context),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF75D9FF),
                                              Color(0xFFFFD46D),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    '${_roundedTemperature(maxTemperature)}°',
                                    style: TextStyle(
                                      color: _wearMuted(context),
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

                const SizedBox(height: 16),

                // ДЕТАЛИ
                Row(
                  children: [
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.water_drop_outlined,
                        value: '$humidity%',
                        label: 'Влажность',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _InfoCard(
                        icon: Icons.air_rounded,
                        value: '${_number(wind)} км/ч',
                        label: 'Ветер',
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: _InfoCard(
                        icon: Icons.cloud_outlined,
                        value: 'Live',
                        label: 'API',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Сегодня',
                      style: TextStyle(
                        color: _wearText(context),
                        fontSize: 21,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Обновить',
                      style: TextStyle(
                        color: Theme.of(context).brightness == Brightness.light
                            ? const Color(0xFF1768E8)
                            : const Color(0xFF9EDFFF).withValues(alpha: 0.85),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                _GlassContainer(
                  radius: 28,
                  padding: const EdgeInsets.fromLTRB(18, 20, 18, 17),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 75,
                        child: CustomPaint(
                          painter: _TemperatureGraphPainter(),
                          child: const SizedBox.expand(),
                        ),
                      ),
                      const SizedBox(height: 7),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _HourTemperature(
                            time: 'Сейчас',
                            temperature: '${_roundedTemperature(temperature)}°',
                          ),
                          _HourTemperature(
                            time: 'Мин.',
                            temperature:
                                '${_roundedTemperature(minTemperature)}°',
                          ),
                          _HourTemperature(
                            time: 'Макс.',
                            temperature:
                                '${_roundedTemperature(maxTemperature)}°',
                          ),
                          _HourTemperature(
                            time: 'Влажн.',
                            temperature: '$humidity%',
                          ),
                          _HourTemperature(
                            time: 'Ветер',
                            temperature: _number(wind),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // WEARCAST AI
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(29),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF83DFFF).withValues(alpha: 0.13),
                        const Color(0xFF8C7DFF).withValues(alpha: 0.08),
                        Colors.white.withValues(alpha: 0.035),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 49,
                        height: 49,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: const Color(0xFF9ADFFF)
                              .withValues(alpha: 0.11),
                        ),
                        child: const Icon(
                          Icons.auto_awesome_rounded,
                          color: Color(0xFF9CE3FF),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'WearCast ✦',
                              style: TextStyle(
                                color: _wearText(context),
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              _aiAdvice(temperature, weatherCode),
                              style: TextStyle(
                                color: _wearMuted(context),
                                height: 1.45,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                Text(
                  'Образ на сегодня',
                  style: TextStyle(
                    color: _wearText(context),
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 14),

                // ОБРАЗ
                _GlassContainer(
                  radius: 30,
                  padding: EdgeInsets.zero,
                  child: SizedBox(
                    // Было 190. Увеличили, чтобы убрать overflow.
                    height: 210,
                    child: Stack(
                      children: [
                        Positioned(
                          right: -40,
                          bottom: -60,
                          child: Container(
                            width: 180,
                            height: 180,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFFC981)
                                  .withValues(alpha: 0.06),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(21),
                          child: Row(
                            children: [
                              Container(
                                width: 104,
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(24),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.white.withValues(alpha: 0.10),
                                      const Color(0xFF8CDEFF)
                                          .withValues(alpha: 0.07),
                                    ],
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.09),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.checkroom_rounded,
                                  size: 50,
                                  color: Color(0xFFACE7FF),
                                ),
                              ),

                              const SizedBox(width: 18),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _TinyLabel(
                                      text:
                                          'ПОДХОДИТ ДЛЯ ${_roundedTemperature(temperature)}°',
                                    ),

                                    const SizedBox(height: 9),

                                    Text(
                                      _outfitTitle(temperature),
                                      style: TextStyle(
                                        color: _wearText(context),
                                        fontSize: 20,
                                        height: 1.1,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(height: 7),

                                    Text(
                                      _outfitItems(temperature),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: _wearMuted(context),
                                        fontSize: 11,
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    InkWell(
                                      onTap: () {
                                        context.push('/outfit/1');
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 13,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withValues(
                                            alpha: 0.08,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: const Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Посмотреть',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            SizedBox(width: 4),
                                            Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 14,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ========================================================
// GLASS
// ========================================================

class _GlassContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;

  const _GlassContainer({
    required this.child,
    required this.radius,
    required this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = Theme.of(context).brightness == Brightness.light;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: isLight
            ? [
                BoxShadow(
                  color: const Color(0xFF7189AE).withValues(alpha: 0.12),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ]
            : [],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            width: double.infinity,
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(radius),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isLight
                    ? [
                        Colors.white.withValues(alpha: 0.88),
                        const Color(0xFFF0F5FF).withValues(alpha: 0.84),
                        Colors.white.withValues(alpha: 0.78),
                      ]
                    : [
                        Colors.white.withValues(alpha: 0.13),
                        Colors.white.withValues(alpha: 0.055),
                        Colors.white.withValues(alpha: 0.025),
                      ],
              ),
              border: Border.all(
                color: isLight
                    ? Colors.white.withValues(alpha: 0.95)
                    : Colors.white.withValues(alpha: 0.13),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
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
      imageFilter: ImageFilter.blur(sigmaX: 95, sigmaY: 95),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.16),
        ),
      ),
    );
  }
}

// ========================================================
// ROUND BUTTON
// ========================================================

class _RoundButton extends StatelessWidget {
  final IconData icon;

  const _RoundButton({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.055),
        border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
      ),
      child: Icon(icon, color: const Color(0xFFE1E5E8), size: 23),
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
        borderRadius: BorderRadius.circular(30),
        color: Colors.white.withValues(alpha: 0.08),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Color(0xFFD8DDE0), fontSize: 13),
      ),
    );
  }
}

// ========================================================
// INFO CARD
// ========================================================

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _InfoCard({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final light = Theme.of(context).brightness == Brightness.light;

    final accent = label == 'Влажность'
        ? const Color(0xFFE65C42)
        : label == 'Ветер'
        ? const Color(0xFF9363D9)
        : const Color(0xFF1768D7);

    final tint = label == 'Влажность'
        ? const Color(0xFFFFF1EF)
        : label == 'Ветер'
        ? const Color(0xFFF5F0FF)
        : const Color(0xFFEDF6FF);

    return Container(
      height: 112,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: light
            ? tint.withValues(alpha: 0.91)
            : Colors.white.withValues(alpha: 0.055),
        border: Border.all(
          color: Colors.white.withValues(alpha: light ? 0.95 : 0.10),
        ),
        boxShadow: light
            ? [
                BoxShadow(
                  color: const Color(0xFF8193B0).withValues(alpha: 0.12),
                  blurRadius: 22,
                  offset: const Offset(0, 9),
                ),
              ]
            : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 22, color: light ? accent : const Color(0xFFA9E4FA)),
          const SizedBox(height: 9),
          Text(
            value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: light ? const Color(0xFF17213B) : Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: light ? const Color(0xFF68738B) : const Color(0xFF929A9F),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}

// ========================================================
// HOUR INFO
// ========================================================

class _HourTemperature extends StatelessWidget {
  final String time;
  final String temperature;

  const _HourTemperature({required this.time, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          temperature,
          style: TextStyle(
            color: _wearText(context),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 5),
        Text(time, style: TextStyle(color: _wearMuted(context), fontSize: 10)),
      ],
    );
  }
}

// ========================================================
// LABEL
// ========================================================

class _TinyLabel extends StatelessWidget {
  final String text;

  const _TinyLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF83DFFF).withValues(alpha: 0.09),
        border: Border.all(
          color: const Color(0xFF83DFFF).withValues(alpha: 0.13),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 9,
          letterSpacing: 0.5,
          color: Color(0xFFACE7FF),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ========================================================
// GRAPH
// ========================================================

class _TemperatureGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = const Color(0xFF8EDFFF)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final glowPaint = Paint()
      ..color = const Color(0xFF8EDFFF).withValues(alpha: 0.17)
      ..strokeWidth = 9
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final path = Path();

    path.moveTo(4, size.height * 0.63);

    path.cubicTo(
      size.width * 0.13,
      size.height * 0.52,
      size.width * 0.17,
      size.height * 0.31,
      size.width * 0.25,
      size.height * 0.34,
    );

    path.cubicTo(
      size.width * 0.36,
      size.height * 0.38,
      size.width * 0.39,
      size.height * 0.22,
      size.width * 0.50,
      size.height * 0.29,
    );

    path.cubicTo(
      size.width * 0.61,
      size.height * 0.37,
      size.width * 0.67,
      size.height * 0.53,
      size.width * 0.75,
      size.height * 0.49,
    );

    path.cubicTo(
      size.width * 0.86,
      size.height * 0.44,
      size.width * 0.90,
      size.height * 0.67,
      size.width - 4,
      size.height * 0.71,
    );

    canvas.drawPath(path, glowPaint);

    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
