import 'dart:ui';

import 'package:flutter/material.dart';

import '../widgets/app_background.dart';

bool _wardrobeIsLight(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light;

Color _wardrobeTextColor(BuildContext context) =>
    _wardrobeIsLight(context) ? const Color(0xFF192640) : Colors.white;

Color _wardrobeMutedColor(BuildContext context) => _wardrobeIsLight(context)
    ? const Color(0xFF68758D)
    : const Color(0xFFAEB6BE);

class WardrobeScreen extends StatelessWidget {
  const WardrobeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Все', Icons.grid_view_rounded),
      ('Верх', Icons.dry_cleaning_rounded),
      ('Низ', Icons.checkroom_outlined),
      ('Обувь', Icons.ice_skating_outlined),
    ];

    final clothes = [
      ('Куртки', '4 вещи', Icons.checkroom_rounded, const Color(0xFF8EDFFF)),
      ('Верх', '8 вещей', Icons.dry_cleaning_rounded, const Color(0xFFB5A7FF)),
      ('Брюки', '6 вещей', Icons.checkroom_outlined, const Color(0xFFFFC982)),
      ('Обувь', '5 пар', Icons.ice_skating_outlined, const Color(0xFFA5E7CE)),
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF7F8FC)
          : const Color(0xFF101214),

      body: Stack(
        children: [
          if (Theme.of(context).brightness == Brightness.light)
            const Positioned.fill(
              child: AppBackground(child: SizedBox.expand()),
            ),
          // ===============================
          // BACKGROUND GLOW
          // ===============================

          const Positioned(
            top: -150,
            right: -100,
            child: _GlowBlob(size: 350, color: Color(0xFF68D5FF)),
          ),

          const Positioned(
            top: 430,
            left: -180,
            child: _GlowBlob(size: 390, color: Color(0xFF8A78FF)),
          ),

          const Positioned(
            bottom: -150,
            right: -100,
            child: _GlowBlob(size: 350, color: Color(0xFFFFB66F)),
          ),

          // decorative circles
          Positioned(
            right: -100,
            top: 250,
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
            right: -25,
            top: 325,
            child: Container(
              width: 115,
              height: 115,
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
                      // ===============================
                      // HEADER
                      // ===============================

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Мой гардероб',
                                style: TextStyle(
                                  fontSize: 31,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -1,
                                  color: _wardrobeTextColor(context),
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                '23 вещи  •  6 образов',
                                style: TextStyle(
                                  color: _wardrobeMutedColor(context),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          _RoundButton(icon: Icons.add_rounded),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // ===============================
                      // TODAY LOOK
                      // ===============================
                      _GlassContainer(
                        radius: 34,
                        padding: EdgeInsets.zero,
                        child: SizedBox(
                          height: 255,
                          child: Stack(
                            children: [
                              // warm glow
                              Positioned(
                                right: -55,
                                bottom: -65,
                                child: Container(
                                  width: 220,
                                  height: 220,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFFFC77D)
                                        .withValues(alpha: 0.07),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFFFFB86C)
                                            .withValues(alpha: 0.13),
                                        blurRadius: 75,
                                        spreadRadius: 15,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // purple glow
                              Positioned(
                                left: -60,
                                top: -80,
                                child: Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF917DFF)
                                        .withValues(alpha: 0.08),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF917DFF)
                                            .withValues(alpha: 0.12),
                                        blurRadius: 60,
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.all(23),
                                child: Row(
                                  children: [
                                    // visual outfit block
                                    Container(
                                      width: 125,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(28),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white.withValues(
                                              alpha: 0.11,
                                            ),
                                            const Color(0xFF83DFFF)
                                                .withValues(alpha: 0.055),
                                          ],
                                        ),
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.10,
                                          ),
                                        ),
                                      ),
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Container(
                                            width: 80,
                                            height: 80,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFF8EDFFF)
                                                  .withValues(alpha: 0.08),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: const Color(0xFF8EDFFF)
                                                      .withValues(alpha: 0.18),
                                                  blurRadius: 35,
                                                ),
                                              ],
                                            ),
                                          ),

                                          const Icon(
                                            Icons.checkroom_rounded,
                                            size: 62,
                                            color: Color(0xFFB9ECFF),
                                          ),

                                          const Positioned(
                                            bottom: 14,
                                            child: Row(
                                              children: [
                                                _ColorDot(
                                                  color: Color(0xFFE8E1D5),
                                                ),
                                                SizedBox(width: 5),
                                                _ColorDot(
                                                  color: Color(0xFF8FA4B8),
                                                ),
                                                SizedBox(width: 5),
                                                _ColorDot(
                                                  color: Color(0xFF272C31),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(width: 20),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const _TinyLabel(
                                            text: 'TODAY\'S LOOK  ✦',
                                          ),

                                          const SizedBox(height: 13),

                                          Text(
                                            'Городской\nминимализм',
                                            style: TextStyle(
                                              color: _wardrobeTextColor(
                                                context,
                                              ),
                                              fontSize: 24,
                                              height: 1.08,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),

                                          const SizedBox(height: 9),

                                          Text(
                                            'Куртка • джинсы\n• кроссовки',
                                            style: TextStyle(
                                              color: _wardrobeMutedColor(
                                                context,
                                              ),
                                              height: 1.45,
                                              fontSize: 12,
                                            ),
                                          ),

                                          const SizedBox(height: 15),

                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 7,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFFFC76E)
                                                  .withValues(alpha: 0.08),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              border: Border.all(
                                                color: const Color(0xFFFFD184)
                                                    .withValues(alpha: 0.12),
                                              ),
                                            ),
                                            child: Text(
                                              '☀  Идеально для +18°',
                                              style: TextStyle(
                                                color: Color(0xFFFFD895),
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
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

                      const SizedBox(height: 15),

                      // ===============================
                      // AI BUTTON
                      // ===============================
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(23),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF8CDFFF).withValues(alpha: 0.10),
                              const Color(0xFF9A83FF).withValues(alpha: 0.07),
                              Colors.white.withValues(alpha: 0.035),
                            ],
                          ),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.11),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.auto_awesome_rounded,
                              color: Color(0xFFA6E7FF),
                              size: 21,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Собрать другой образ',
                                style: TextStyle(
                                  color: _wardrobeTextColor(context),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Color(0xFFA6E7FF),
                              size: 19,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 30),

                      // ===============================
                      // CATEGORIES
                      // ===============================
                      Text(
                        'Категории',
                        style: TextStyle(
                          color: _wardrobeTextColor(context),
                          fontSize: 21,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 14),

                      SizedBox(
                        height: 43,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          separatorBuilder: (_, _) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            final selected = index == 0;

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                color: selected
                                    ? Colors.white.withValues(alpha: 0.13)
                                    : Colors.white.withValues(alpha: 0.045),
                                border: Border.all(
                                  color: selected
                                      ? const Color(0xFF9DE5FF)
                                            .withValues(alpha: 0.18)
                                      : Colors.white.withValues(alpha: 0.08),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    category.$2,
                                    size: 16,
                                    color: selected
                                        ? const Color(0xFFA6E7FF)
                                        : const Color(0xFF8F989E),
                                  ),
                                  const SizedBox(width: 7),
                                  Text(
                                    category.$1,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: selected
                                          ? Colors.white
                                          : const Color(0xFFA0A8AE),
                                      fontWeight: selected
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 25),

                      // ===============================
                      // COLLECTION TITLE
                      // ===============================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Моя коллекция',
                            style: TextStyle(
                              color: _wardrobeTextColor(context),
                              fontSize: 21,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '23 вещи',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.42),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // ===============================
                      // CLOTHES GRID
                      // ===============================
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: clothes.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 11,
                              mainAxisSpacing: 11,
                              childAspectRatio: 0.92,
                            ),
                        itemBuilder: (context, index) {
                          final item = clothes[index];

                          return _WardrobeCard(
                            title: item.$1,
                            count: item.$2,
                            icon: item.$3,
                            accent: item.$4,
                            index: index,
                          );
                        },
                      ),

                      const SizedBox(height: 30),

                      // ===============================
                      // WARDROBE STATS
                      // ===============================
                      _GlassContainer(
                        radius: 28,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.insights_rounded,
                                  color: Color(0xFFB5A7FF),
                                  size: 22,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Твой гардероб',
                                  style: TextStyle(
                                    color: _wardrobeTextColor(context),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            Row(
                              children: [
                                Expanded(
                                  child: _Stat(value: '23', label: 'вещи'),
                                ),
                                _VerticalDivider(),
                                Expanded(
                                  child: _Stat(value: '6', label: 'образов'),
                                ),
                                _VerticalDivider(),
                                Expanded(
                                  child: _Stat(value: '4', label: 'любимых'),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            Container(
                              padding: const EdgeInsets.all(13),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.04),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.lightbulb_outline_rounded,
                                    color: Color(0xFFFFD183),
                                    size: 19,
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Text(
                                      'Добавь лёгкий дождевик — он пригодится на прохладной неделе.',
                                      style: TextStyle(
                                        color: _wardrobeMutedColor(context),
                                        fontSize: 11,
                                        height: 1.4,
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
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// WARDROBE CARD
// ============================================================

class _WardrobeCard extends StatelessWidget {
  final String title;
  final String count;
  final IconData icon;
  final Color accent;
  final int index;

  const _WardrobeCard({
    required this.title,
    required this.count,
    required this.icon,
    required this.accent,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(27),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _wardrobeIsLight(context)
              ? [
                  Colors.white.withValues(alpha: 0.95),
                  accent.withValues(alpha: 0.16),
                  Colors.white.withValues(alpha: 0.88),
                ]
              : [
                  Colors.white.withValues(alpha: 0.095),
                  accent.withValues(alpha: 0.045),
                  Colors.white.withValues(alpha: 0.025),
                ],
        ),
        border: Border.all(color: Colors.white.withValues(alpha: 0.10)),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -25,
            right: -25,
            child: Container(
              width: 85,
              height: 85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accent.withValues(alpha: 0.06),
                boxShadow: [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.13),
                    blurRadius: 30,
                  ),
                ],
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: accent.withValues(alpha: 0.08),
                    ),
                    child: Icon(icon, color: accent, size: 25),
                  ),

                  Icon(
                    index == 0
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: index == 0
                        ? const Color(0xFFFF9FAD)
                        : Colors.white.withValues(alpha: 0.25),
                    size: 18,
                  ),
                ],
              ),

              const Spacer(),

              Text(
                title,
                style: TextStyle(
                  color: _wardrobeTextColor(context),
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                count,
                style: TextStyle(
                  color: _wardrobeMutedColor(context),
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 11),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 3,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                      child: FractionallySizedBox(
                        widthFactor: 0.45 + (index * 0.12),
                        alignment: Alignment.centerLeft,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: accent.withValues(alpha: 0.55),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_outward_rounded,
                    color: Colors.white.withValues(alpha: 0.3),
                    size: 15,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ============================================================
// GLASS
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
              colors: _wardrobeIsLight(context)
                  ? [
                      Colors.white.withValues(alpha: 0.95),
                      const Color(0xFFE9F0FF).withValues(alpha: 0.88),
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
        color: Colors.white.withValues(alpha: 0.06),
        border: Border.all(color: Colors.white.withValues(alpha: 0.13)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8EDFFF).withValues(alpha: 0.08),
            blurRadius: 20,
          ),
        ],
      ),
      child: Icon(icon, color: const Color(0xFFE4E8EB)),
    );
  }
}

// ============================================================
// SMALL COMPONENTS
// ============================================================

class _TinyLabel extends StatelessWidget {
  final String text;

  const _TinyLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
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
          color: Color(0xFFAEEAFF),
          fontSize: 9,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;

  const _ColorDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;

  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: _wardrobeTextColor(context),
            fontSize: 23,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(color: _wardrobeMutedColor(context), fontSize: 10),
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
