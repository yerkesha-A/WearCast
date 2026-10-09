import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

import 'data/repositories/weather_repository.dart';

import 'presentation/providers/weather_provider.dart';
import 'presentation/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  runApp(
    MultiProvider(
      providers: [
        Provider<WeatherRepository>(create: (_) => WeatherRepository()),
        ChangeNotifierProvider(
          create: (context) => WeatherProvider(
            weatherRepository: context.read<WeatherRepository>(),
          )..loadWeather(),
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..loadTheme()),
      ],
      child: const WearCastApp(),
    ),
  );
}

class WearCastApp extends StatelessWidget {
  const WearCastApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'WearCast',
      routerConfig: appRouter,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeProvider.themeMode,
    );
  }
}
