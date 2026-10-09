import 'dart:ui';

import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget child;

  const AppBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return child;
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: Color(0xFFF7F8FC)),

        // Голубое сияние справа сверху
        const Positioned(
          top: -160,
          right: -170,
          child: _Glow(color: Color(0xFF79B7FF), size: 520, opacity: 0.48),
        ),

        // Сиреневое сияние слева
        const Positioned(
          top: 250,
          left: -230,
          child: _Glow(color: Color(0xFFA99AFF), size: 470, opacity: 0.36),
        ),

        // Персиковое сияние справа
        const Positioned(
          top: 390,
          right: -240,
          child: _Glow(color: Color(0xFFFFB89D), size: 460, opacity: 0.35),
        ),

        // Дополнительное голубое сияние снизу
        const Positioned(
          bottom: -230,
          right: 80,
          child: _Glow(color: Color(0xFF9BCFFF), size: 410, opacity: 0.30),
        ),

        // Тонкие декоративные окружности
        const Positioned(
          top: -220,
          right: -155,
          child: _OutlineCircle(size: 460, color: Color(0xFF9ABBEF)),
        ),

        const Positioned(
          top: 310,
          left: -190,
          child: _OutlineCircle(size: 390, color: Color(0xFFC5A7F5)),
        ),

        const Positioned(
          top: 365,
          left: -130,
          child: _OutlineCircle(size: 310, color: Colors.white),
        ),

        const Positioned(
          top: 280,
          right: -230,
          child: _OutlineCircle(size: 450, color: Color(0xFFF2B6BA)),
        ),

        child,
      ],
    );
  }
}

class _Glow extends StatelessWidget {
  final Color color;
  final double size;
  final double opacity;

  const _Glow({required this.color, required this.size, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 85, sigmaY: 85),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: opacity),
        ),
      ),
    );
  }
}

class _OutlineCircle extends StatelessWidget {
  final double size;
  final Color color;

  const _OutlineCircle({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.48), width: 1.2),
      ),
    );
  }
}
