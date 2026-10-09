import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'home_screen.dart';
import 'forecast_screen.dart';
import 'wardrobe_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static const screens = [
    HomeScreen(),
    ForecastScreen(),
    WardrobeScreen(),
    ProfileScreen(),
  ];

  static const paths = ['/', '/forecast', '/wardrobe', '/profile'];

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = paths.indexOf(location);
    final currentIndex = index < 0 ? 0 : index;

    final isLight = Theme.of(context).brightness == Brightness.light;

    final activeColor = isLight
        ? const Color(0xFF1768D7)
        : const Color(0xFF8EDFFF);

    final inactiveColor = isLight
        ? const Color(0xFF7586A5)
        : const Color(0xFF8A9BAF);

    return Scaffold(
      extendBody: true,
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(22, 0, 22, 20),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: Container(
              decoration: BoxDecoration(
                color: isLight
                    ? Colors.white.withValues(alpha: 0.80)
                    : const Color(0xFF0B1D35).withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isLight
                      ? Colors.white.withValues(alpha: 0.90)
                      : const Color(0xFF6FD6FF).withValues(alpha: 0.25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: isLight
                        ? const Color(0xFF7B96C3).withValues(alpha: 0.12)
                        : const Color(0xFF38BDF8).withValues(alpha: 0.22),
                    blurRadius: 25,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: NavigationBarTheme(
                data: NavigationBarThemeData(
                  labelTextStyle: WidgetStateProperty.resolveWith((states) {
                    final selected = states.contains(WidgetState.selected);
                    return TextStyle(
                      color: selected ? activeColor : inactiveColor,
                      fontSize: 12,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    );
                  }),
                  iconTheme: WidgetStateProperty.resolveWith((states) {
                    final selected = states.contains(WidgetState.selected);
                    return IconThemeData(
                      color: selected ? activeColor : inactiveColor,
                      size: 24,
                    );
                  }),
                ),
                child: NavigationBar(
                  backgroundColor: Colors.transparent,
                  surfaceTintColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  indicatorColor: isLight
                      ? const Color(0xFFDAE9FF)
                      : const Color(0xFF55C7F3).withValues(alpha: 0.20),
                  selectedIndex: currentIndex,
                  onDestinationSelected: (index) {
                    context.go(paths[index]);
                  },
                  destinations: const [
                    NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home_rounded),
                      label: 'Главная',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.cloud_outlined),
                      selectedIcon: Icon(Icons.cloud_rounded),
                      label: 'Прогноз',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.checkroom_outlined),
                      selectedIcon: Icon(Icons.checkroom_rounded),
                      label: 'Гардероб',
                    ),
                    NavigationDestination(
                      icon: Icon(Icons.person_outline),
                      selectedIcon: Icon(Icons.person),
                      label: 'Профиль',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
