import 'package:go_router/go_router.dart';

import '../../presentation/screens/main_screen.dart';
import '../../presentation/screens/outfit_details_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MainScreen()),
    GoRoute(path: '/forecast', builder: (context, state) => const MainScreen()),
    GoRoute(path: '/wardrobe', builder: (context, state) => const MainScreen()),
    GoRoute(path: '/profile', builder: (context, state) => const MainScreen()),
    GoRoute(
      path: '/outfit/:id',
      builder: (context, state) =>
          OutfitDetailsScreen(outfitId: state.pathParameters['id']!),
    ),
  ],
);
