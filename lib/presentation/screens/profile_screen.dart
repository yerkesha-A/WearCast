import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/theme_provider.dart';
import '../widgets/app_background.dart';

import '../../data/services/settings_service.dart';

bool _profileLight(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light;

Color _profileText(BuildContext context) =>
    _profileLight(context) ? const Color(0xFF192640) : Colors.white;

Color _profileMuted(BuildContext context) =>
    _profileLight(context) ? const Color(0xFF68758D) : const Color(0xFFAEB6BE);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final SettingsService _settingsService = SettingsService();
  String _temperatureUnit = 'C';

  @override
  void initState() {
    super.initState();
    _loadTemperatureUnit();
  }

  Future<void> _loadTemperatureUnit() async {
    final unit = await _settingsService.getTemperatureUnit();
    if (!mounted) return;
    setState(() => _temperatureUnit = unit);
  }

  Future<void> _changeTemperatureUnit() async {
    final next = _temperatureUnit == 'C' ? 'F' : 'C';
    await _settingsService.setTemperatureUnit(next);
    if (!mounted) return;
    setState(() => _temperatureUnit = next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _profileLight(context)
          ? const Color(0xFFF7F8FC)
          : const Color(0xFF101214),
      body: Stack(
        children: [
          if (_profileLight(context))
            const Positioned.fill(
              child: AppBackground(child: SizedBox.expand()),
            ),
          // BACKGROUND GLOW
          if (!_profileLight(context))
            const Positioned(
              top: -150,
              right: -100,
              child: _GlowBlob(size: 360, color: Color(0xFF6ED7FF)),
            ),

          if (!_profileLight(context))
            const Positioned(
              top: 430,
              left: -190,
              child: _GlowBlob(size: 390, color: Color(0xFF8B79FF)),
            ),

          if (!_profileLight(context))
            const Positioned(
              bottom: -150,
              right: -100,
              child: _GlowBlob(size: 360, color: Color(0xFFFFB66F)),
            ),

          // decorative rings
          Positioned(
            right: -95,
            top: 230,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.045),
                ),
              ),
            ),
          ),

          Positioned(
            right: -20,
            top: 305,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 135),
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
                                'Профиль',
                                style: TextStyle(
                                  color: _profileText(context),
                                  fontSize: 31,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -1,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Твой WearCast',
                                style: TextStyle(
                                  color: _profileMuted(context),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          _RoundButton(icon: Icons.settings_outlined),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // PROFILE HERO
                      _GlassContainer(
                        radius: 34,
                        padding: EdgeInsets.zero,
                        child: SizedBox(
                          height: 285,
                          child: Stack(
                            children: [
                              Positioned(
                                top: -70,
                                right: -50,
                                child: Container(
                                  width: 220,
                                  height: 220,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF8DDEFF)
                                        .withValues(alpha: 0.06),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF8DDEFF)
                                            .withValues(alpha: 0.12),
                                        blurRadius: 70,
                                        spreadRadius: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: -80,
                                left: -70,
                                child: Container(
                                  width: 210,
                                  height: 210,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF917EFF)
                                        .withValues(alpha: 0.05),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF917EFF)
                                            .withValues(alpha: 0.10),
                                        blurRadius: 65,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  children: [
                                    // AVATAR
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          width: 106,
                                          height: 106,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            gradient: const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFF83E2FF),
                                                Color(0xFF967DFF),
                                                Color(0xFFFFC979),
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF7EDFFF)
                                                    .withValues(alpha: 0.25),
                                                blurRadius: 30,
                                              ),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          width: 96,
                                          height: 96,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _profileLight(context)
                                                ? const Color(0xFFEAF1FC)
                                                : const Color(0xFF171B1E),
                                            border: Border.all(
                                              color: _profileLight(context)
                                                  ? Colors.white
                                                  : const Color(0xFF252B30),
                                              width: 3,
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.person_rounded,
                                            size: 49,
                                            color: Color(0xFFDCE4E8),
                                          ),
                                        ),

                                        Positioned(
                                          right: 2,
                                          bottom: 7,
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFF15191C),
                                              border: Border.all(
                                                color: const Color(0xFF77DFFF),
                                                width: 2,
                                              ),
                                            ),
                                            child: const Icon(
                                              Icons.edit_rounded,
                                              size: 12,
                                              color: Color(0xFF9EE6FF),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 16),

                                    Text(
                                      'Пользователь WearCast',
                                      style: TextStyle(
                                        color: _profileText(context),
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 14,
                                          color: _profileMuted(context),
                                        ),
                                        SizedBox(width: 4),
                                        Text(
                                          'Алматы, Казахстан',
                                          style: TextStyle(
                                            color: _profileMuted(context),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),

                                    const Spacer(),

                                    // PROFILE STATS
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _ProfileStat(
                                            value: '23',
                                            label: 'вещи',
                                          ),
                                        ),
                                        _VerticalDivider(),
                                        Expanded(
                                          child: _ProfileStat(
                                            value: '6',
                                            label: 'образов',
                                          ),
                                        ),
                                        _VerticalDivider(),
                                        Expanded(
                                          child: _ProfileStat(
                                            value: '12',
                                            label: 'дней',
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

                      const SizedBox(height: 28),

                      // PERSONALIZATION
                      Text(
                        'Персонализация',
                        style: TextStyle(
                          color: _profileText(context),
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: _PreferenceCard(
                              icon: Icons.style_outlined,
                              title: 'Стиль',
                              value: 'Casual',
                              accent: const Color(0xFF9FE5FF),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: GestureDetector(
                              onTap: _changeTemperatureUnit,
                              child: _PreferenceCard(
                                icon: Icons.thermostat_rounded,
                                title: 'Температура',
                                value: '°$_temperatureUnit',
                                accent: const Color(0xFFFFCB7C),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                final theme = context.read<ThemeProvider>();
                                theme.setDarkMode(!theme.isDarkMode);
                              },
                              child: _PreferenceCard(
                                icon: Icons.palette_outlined,
                                title: 'Тема',
                                value: context.watch<ThemeProvider>().isDarkMode
                                    ? 'Тёмная'
                                    : 'Светлая',
                                accent: const Color(0xFFB6A7FF),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _PreferenceCard(
                              icon: Icons.language_rounded,
                              title: 'Язык',
                              value: 'Русский',
                              accent: const Color(0xFFA4E5C9),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      // AI CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(21),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF83DFFF).withValues(alpha: 0.12),
                              const Color(0xFF927DFF).withValues(alpha: 0.075),
                              Colors.white.withValues(alpha: 0.03),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.11),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8EDFFF)
                                  .withValues(alpha: 0.07),
                              blurRadius: 30,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 53,
                              height: 53,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(17),
                                color: const Color(0xFF9AE5FF)
                                    .withValues(alpha: 0.09),
                                border: Border.all(
                                  color: const Color(0xFF9AE5FF)
                                      .withValues(alpha: 0.10),
                                ),
                              ),
                              child: const Icon(
                                Icons.auto_awesome_rounded,
                                color: Color(0xFFA8E9FF),
                                size: 25,
                              ),
                            ),

                            const SizedBox(width: 15),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'WearCast AI',
                                        style: TextStyle(
                                          color: _profileText(context),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        '✦',
                                        style: TextStyle(
                                          color: Color(0xFFA6E7FF),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Мы подобрали тебе 7 образов за эту неделю',
                                    style: TextStyle(
                                      color: _profileMuted(context),
                                      fontSize: 12,
                                      height: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFF9EDFFF),
                              size: 19,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // SETTINGS
                      Text(
                        'Настройки',
                        style: TextStyle(
                          color: _profileText(context),
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 14),

                      _SettingsGroup(
                        children: [
                          _SettingTile(
                            icon: Icons.notifications_none_rounded,
                            title: 'Уведомления',
                            subtitle: 'Погода и рекомендации',
                            trailing: _FakeSwitch(enabled: true),
                          ),

                          _SettingTile(
                            icon: Icons.location_on_outlined,
                            title: 'Местоположение',
                            subtitle: 'Алматы',
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF777F84),
                            ),
                          ),

                          _SettingTile(
                            icon: Icons.cloud_outlined,
                            title: 'Единицы погоды',
                            subtitle: '°$_temperatureUnit  •  м/с',
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF777F84),
                            ),
                          ),

                          _SettingTile(
                            icon: Icons.favorite_border_rounded,
                            title: 'Сохранённые образы',
                            subtitle: '4 образа',
                            trailing: const Icon(
                              Icons.chevron_right_rounded,
                              color: Color(0xFF777F84),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // ACCOUNT
                      _GlassContainer(
                        radius: 25,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 17,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.login_rounded,
                              color: Color(0xFF9FE4FF),
                              size: 21,
                            ),
                            SizedBox(width: 13),
                            Expanded(
                              child: Text(
                                'Войти в WearCast',
                                style: TextStyle(
                                  color: _profileText(context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              'Синхронизация',
                              style: TextStyle(
                                color: _profileMuted(context),
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(width: 6),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFF9FE4FF),
                              size: 17,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// GLASS CONTAINER
// ============================================================

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
    return ClipRRect(
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
              colors: _profileLight(context)
                  ? [
                      Colors.white.withValues(alpha: 0.95),
                      const Color(0xFFE9F0FF).withValues(alpha: 0.87),
                      Colors.white.withValues(alpha: 0.90),
                    ]
                  : [
                      Colors.white.withValues(alpha: 0.12),
                      Colors.white.withValues(alpha: 0.05),
                      Colors.white.withValues(alpha: 0.025),
                    ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: child,
        ),
      ),
    );
  }
}

// ============================================================
// BACKGROUND GLOW
// ============================================================

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

// ============================================================
// ROUND BUTTON
// ============================================================

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
        color: _profileLight(context)
            ? Colors.white.withValues(alpha: 0.93)
            : Colors.white.withValues(alpha: 0.055),
        border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
      ),
      child: Icon(icon, color: _profileText(context), size: 22),
    );
  }
}

// ============================================================
// STATS
// ============================================================

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;

  const _ProfileStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: _profileText(context),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(color: _profileMuted(context), fontSize: 10),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 35,
      color: Colors.white.withValues(alpha: 0.08),
    );
  }
}

// ============================================================
// PERSONALIZATION
// ============================================================

class _PreferenceCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color accent;

  const _PreferenceCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _profileLight(context)
              ? [
                  Colors.white.withValues(alpha: 0.96),
                  accent.withValues(alpha: 0.16),
                  Colors.white.withValues(alpha: 0.89),
                ]
              : [
                  Colors.white.withValues(alpha: 0.09),
                  accent.withValues(alpha: 0.035),
                  Colors.white.withValues(alpha: 0.025),
                ],
        ),
        border: Border.all(
          color: Colors.white.withValues(
            alpha: _profileLight(context) ? 0.95 : 0.09,
          ),
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -25,
            right: -25,
            child: Container(
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.05),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.10),
                    blurRadius: 25,
                  ),
                ],
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: accent, size: 22),

              const Spacer(),

              Text(
                title,
                style: TextStyle(color: _profileMuted(context), fontSize: 10),
              ),

              const SizedBox(height: 3),

              Text(
                value,
                style: TextStyle(
                  color: _profileText(context),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// SETTINGS GROUP
// ============================================================

class _SettingsGroup extends StatelessWidget {
  final List<Widget> children;

  const _SettingsGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: _profileLight(context)
                ? Colors.white.withValues(alpha: 0.93)
                : Colors.white.withValues(alpha: 0.045),
            border: Border.all(
              color: Colors.white.withValues(
                alpha: _profileLight(context) ? 0.95 : 0.09,
              ),
            ),
          ),
          child: Column(children: children),
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.white.withValues(alpha: 0.055)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: const Color(0xFF8EDFFF).withValues(alpha: 0.065),
            ),
            child: Icon(icon, color: const Color(0xFFA5E6FF), size: 19),
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _profileText(context),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  style: TextStyle(color: _profileMuted(context), fontSize: 10),
                ),
              ],
            ),
          ),

          trailing,
        ],
      ),
    );
  }
}

// ============================================================
// FAKE SWITCH
// ============================================================

class _FakeSwitch extends StatelessWidget {
  final bool enabled;

  const _FakeSwitch({required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 43,
      height: 24,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: enabled
            ? const Color(0xFF8EDFFF).withValues(alpha: 0.22)
            : Colors.white.withValues(alpha: 0.07),
        border: Border.all(
          color: enabled
              ? const Color(0xFF9EE6FF).withValues(alpha: 0.20)
              : Colors.white.withValues(alpha: 0.08),
        ),
      ),
      child: Align(
        alignment: enabled ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 17,
          height: 17,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: enabled ? const Color(0xFFAEEAFF) : const Color(0xFF777F84),
            boxShadow: enabled
                ? [
                    BoxShadow(
                      color: const Color(0xFF8EDFFF).withValues(alpha: 0.35),
                      blurRadius: 8,
                    ),
                  ]
                : null,
          ),
        ),
      ),
    );
  }
}
