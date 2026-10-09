import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wearcast/main.dart';
import 'package:wearcast/data/repositories/weather_repository.dart';
import 'package:wearcast/presentation/providers/theme_provider.dart';
import 'package:wearcast/presentation/providers/weather_provider.dart';

void main() {
  testWidgets('WearCast запускается', (WidgetTester tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ThemeProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => WeatherProvider(
              weatherRepository: WeatherRepository(),
            ),
          ),
        ],
        child: const WearCastApp(),
      ),
    );

    expect(find.byType(WearCastApp), findsOneWidget);
  });
}
