import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../widgets/app_scaffold.dart';
import '../../features/home/home_screen.dart';
import '../../features/cocktails/cocktails_screen.dart';
import '../../features/cocktails/cocktail_detail_screen.dart';
import '../../features/map/map_screen.dart';
import '../../features/games/games_screen.dart';
import '../../features/games/game_play_screen.dart';
import '../../features/contact/contact_screen.dart';
import '../../features/settings/settings_screen.dart';
import 'route_names.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: RouteNames.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return AppScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: RouteNames.home,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.cocktails,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CocktailsScreen(),
            ),
            routes: [
              GoRoute(
                path: '${RouteNames.cocktailDetail}/:name',
                builder: (context, state) => CocktailDetailScreen(
                  cocktailName:
                      Uri.decodeComponent(state.pathParameters['name']!),
                ),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.map,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MapScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.games,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: GamesScreen(),
            ),
            routes: [
              GoRoute(
                path: '${RouteNames.gamePlay}/:id',
                builder: (context, state) => GamePlayScreen(
                  gameId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: RouteNames.settings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SettingsScreen(),
            ),
          ),
          GoRoute(
            path: RouteNames.contact,
            builder: (context, state) => const ContactScreen(),
          ),
        ],
      ),
    ],
  );
});
