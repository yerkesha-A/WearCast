import 'dart:ui';

import 'package:flutter/material.dart';

import '../widgets/app_background.dart';

bool _outfitLight(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light;

Color _outfitText(BuildContext context) =>
    _outfitLight(context) ? const Color(0xFF192640) : Colors.white;

Color _outfitMuted(BuildContext context) =>
    _outfitLight(context) ? const Color(0xFF68758D) : const Color(0xFF9FA8AE);

class OutfitDetailsScreen extends StatelessWidget {
  const OutfitDetailsScreen({super.key, required this.outfitId});

  final String outfitId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _outfitLight(context)
          ? const Color(0xFFF7F8FC)
          : const Color(0xFF101214),
      body: Stack(
        children: [
          if (_outfitLight(context))
            const Positioned.fill(
              child: AppBackground(child: SizedBox.expand()),
            ),
          // BACKGROUND GLOWS
          if (!_outfitLight(context))
            const Positioned(
              top: -140,
              right: -110,
              child: _GlowBlob(size: 360, color: Color(0xFF6ED7FF)),
            ),

          if (!_outfitLight(context))
            const Positioned(
              top: 400,
              left: -190,
              child: _GlowBlob(size: 380, color: Color(0xFF8C78FF)),
            ),

          if (!_outfitLight(context))
            const Positioned(
              bottom: -160,
              right: -100,
              child: _GlowBlob(size: 350, color: Color(0xFFFFB66F)),
            ),

          // DECORATIVE CIRCLES
          Positioned(
            right: -100,
            top: 280,
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

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 45),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // HEADER
                      Row(
                        children: [
                          _CircleButton(
                            icon: Icons.arrow_back_rounded,
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),

                          Expanded(
                            child: Text(
                              'Образ дня',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _outfitText(context),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          _CircleButton(
                            icon: Icons.favorite_border_rounded,
                            onTap: () {},
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // MAIN OUTFIT CARD
                      _GlassCard(
                        radius: 35,
                        padding: EdgeInsets.zero,
                        child: SizedBox(
                          height: 350,
                          child: Stack(
                            children: [
                              Positioned(
                                top: -70,
                                right: -60,
                                child: Container(
                                  width: 240,
                                  height: 240,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFFFC978)
                                        .withValues(alpha: 0.07),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFFC978)
                                            .withValues(alpha: 0.13),
                                        blurRadius: 80,
                                        spreadRadius: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Positioned(
                                bottom: -70,
                                left: -50,
                                child: Container(
                                  width: 200,
                                  height: 200,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF8D7DFF)
                                        .withValues(alpha: 0.07),
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const _SmallLabel(
                                          text: 'TODAY\'S LOOK  ✦',
                                        ),

                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 7,
                                          ),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                            color: const Color(0xFFFFC978)
                                                .withValues(alpha: 0.08),
                                            border: Border.all(
                                              color: const Color(0xFFFFD591)
                                                  .withValues(alpha: 0.12),
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.wb_sunny_rounded,
                                                color: Color(0xFFFFD481),
                                                size: 15,
                                              ),
                                              SizedBox(width: 5),
                                              Text(
                                                '+18°',
                                                style: TextStyle(
                                                  color: Color(0xFFFFD99B),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),

                                    const Spacer(),

                                    // OUTFIT VISUAL
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        _ClothingVisual(
                                          icon: Icons.checkroom_rounded,
                                          label: 'Куртка',
                                          height: 145,
                                          accent: const Color(0xFF9DE5FF),
                                        ),

                                        const SizedBox(width: 10),

                                        _ClothingVisual(
                                          icon: Icons.checkroom_outlined,
                                          label: 'Джинсы',
                                          height: 125,
                                          accent: const Color(0xFFB7A9FF),
                                        ),

                                        const SizedBox(width: 10),

                                        _ClothingVisual(
                                          icon: Icons.ice_skating_outlined,
                                          label: 'Обувь',
                                          height: 105,
                                          accent: const Color(0xFFFFCE87),
                                        ),
                                      ],
                                    ),

                                    const Spacer(),

                                    Text(
                                      'Городской минимализм',
                                      style: TextStyle(
                                        color: _outfitText(context),
                                        fontSize: 23,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),

                                    const SizedBox(height: 6),

                                    Text(
                                      'Лёгкий • удобный • на каждый день',
                                      style: TextStyle(
                                        color: _outfitMuted(context),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // WEATHER MATCH
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFFC978).withValues(alpha: 0.09),
                              Colors.white.withValues(alpha: 0.04),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.09),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.wb_sunny_rounded,
                              color: Color(0xFFFFD17D),
                              size: 27,
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Подходит на 96%',
                                    style: TextStyle(
                                      color: _outfitText(context),
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Идеальный вариант для сегодняшней погоды',
                                    style: TextStyle(
                                      color: _outfitMuted(context),
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '96%',
                              style: TextStyle(
                                color: Color(0xFFFFD28A),
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ITEMS TITLE
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'В этом образе',
                            style: TextStyle(
                              color: _outfitText(context),
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '3 вещи',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.40),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      const _OutfitItem(
                        icon: Icons.checkroom_rounded,
                        title: 'Лёгкая куртка',
                        subtitle: 'Верхняя одежда',
                        colorName: 'Светлая',
                        accent: Color(0xFF9DE5FF),
                      ),

                      const SizedBox(height: 10),

                      const _OutfitItem(
                        icon: Icons.checkroom_outlined,
                        title: 'Прямые джинсы',
                        subtitle: 'Низ',
                        colorName: 'Голубые',
                        accent: Color(0xFFB6AAFF),
                      ),

                      const SizedBox(height: 10),

                      const _OutfitItem(
                        icon: Icons.ice_skating_outlined,
                        title: 'Кроссовки',
                        subtitle: 'Обувь',
                        colorName: 'Белые',
                        accent: Color(0xFFFFCF8A),
                      ),

                      const SizedBox(height: 30),

                      // WHY
                      Text(
                        'Почему этот образ?',
                        style: TextStyle(
                          color: _outfitText(context),
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 14),

                      _GlassCard(
                        radius: 28,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            _ReasonRow(
                              icon: Icons.thermostat_rounded,
                              title: 'Комфортная температура',
                              description: 'Одежда подходит для температуры от +14° до +21°.',
                              accent: Color(0xFFFFCE85),
                            ),

                            SizedBox(height: 18),

                            _ReasonRow(
                              icon: Icons.air_rounded,
                              title: 'Защита от ветра',
                              description:
                                  'Лёгкая куртка пригодится при ветре 3.2 м/с.',
                              accent: Color(0xFF9DE5FF),
                            ),

                            SizedBox(height: 18),

                            _ReasonRow(
                              icon: Icons.nights_stay_outlined,
                              title: 'На прохладный вечер',
                              description: 'К вечеру температура опустится примерно до +14°.',
                              accent: Color(0xFFB7AAFF),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // AI TIP
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xFF83DFFF).withValues(alpha: 0.12),
                              const Color(0xFF927DFF).withValues(alpha: 0.07),
                              Colors.white.withValues(alpha: 0.03),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.11),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              color: Color(0xFFA8E9FF),
                              size: 25,
                            ),
                            SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Совет WearCast ✦',
                                    style: TextStyle(
                                      color: _outfitText(context),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Если будешь возвращаться поздно, возьми с собой лёгкий шарф — вечером станет прохладнее.',
                                    style: TextStyle(
                                      color: _outfitMuted(context),
                                      fontSize: 12,
                                      height: 1.45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 57,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            gradient: const LinearGradient(
                              colors: [Color(0xFFB6EAFF), Color(0xFF83DFFF)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF83DFFF)
                                    .withValues(alpha: 0.18),
                                blurRadius: 25,
                              ),
                            ],
                          ),
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFF10171A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.auto_awesome_rounded, size: 19),
                                SizedBox(width: 9),
                                Text(
                                  'Подобрать другой образ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
// CLOTHING VISUAL
// ============================================================

class _ClothingVisual extends StatelessWidget {
  final IconData icon;
  final String label;
  final double height;
  final Color accent;

  const _ClothingVisual({
    required this.icon,
    required this.label,
    required this.height,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.10),
            accent.withValues(alpha: 0.045),
          ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 33, color: accent),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(color: _outfitMuted(context), fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// OUTFIT ITEM
// ============================================================

class _OutfitItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String colorName;
  final Color accent;

  const _OutfitItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.colorName,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        color: _outfitLight(context)
            ? Colors.white.withValues(alpha: 0.93)
            : Colors.white.withValues(alpha: 0.045),
        border: Border.all(color: Colors.white.withValues(alpha: 0.085)),
      ),
      child: Row(
        children: [
          Container(
            width: 53,
            height: 53,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              color: accent.withValues(alpha: 0.07),
            ),
            child: Icon(icon, color: accent, size: 26),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: _outfitText(context),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(color: _outfitMuted(context), fontSize: 10),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white.withValues(alpha: 0.05),
            ),
            child: Text(
              colorName,
              style: TextStyle(color: _outfitMuted(context), fontSize: 9),
            ),
          ),

          const SizedBox(width: 7),

          const Icon(
            Icons.chevron_right_rounded,
            color: Color(0xFF737B80),
            size: 19,
          ),
        ],
      ),
    );
  }
}

// ============================================================
// REASON
// ============================================================

class _ReasonRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color accent;

  const _ReasonRow({
    required this.icon,
    required this.title,
    required this.description,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: accent.withValues(alpha: 0.07),
          ),
          child: Icon(icon, color: accent, size: 20),
        ),

        const SizedBox(width: 13),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: _outfitText(context),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: _outfitMuted(context),
                  fontSize: 10,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ============================================================
// GLASS
// ============================================================

class _GlassCard extends StatelessWidget {
  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;

  const _GlassCard({
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
              colors: _outfitLight(context)
                  ? [
                      Colors.white.withValues(alpha: 0.96),
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
// GLOW
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
// BUTTON
// ============================================================

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withValues(alpha: 0.055),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Icon(icon, color: _outfitText(context), size: 21),
        ),
      ),
    );
  }
}

// ============================================================
// LABEL
// ============================================================

class _SmallLabel extends StatelessWidget {
  final String text;

  const _SmallLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xFF8EDFFF).withValues(alpha: 0.08),
        border: Border.all(
          color: const Color(0xFF8EDFFF).withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Color(0xFFADE9FF),
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
