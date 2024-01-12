import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:comics_center/domain/bookmark.dart';
import 'package:comics_center/presentation/Series/series_details_screen.dart';
import 'package:comics_center/presentation/character/screen/character_detail_screen.dart';
import 'package:comics_center/presentation/comic/screen/comic_detail.dart';
import 'package:comics_center/presentation/screens/app_init_screen.dart';
import 'package:comics_center/presentation/screens/home/home.dart';
import 'package:comics_center/presentation/screens/onboarding.dart';
import 'package:comics_center/providers/app_providers.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppRouteNotifier extends AsyncNotifier<void> implements Listenable {
  static const root = "/";
  static const onboarding = "/onboarding";
  static const characters = "/characters";
  static const comics = "/comics";
  static const home = "/home";
  static const series = "/series";

  VoidCallback? _routerListener;

  static generateCharacterRoute([String? id]) => "$characters/${id ?? ':id'}";

  static generateComicRoute([String? id]) => "$comics/${id ?? ':id'}";

  static generateSeriesRoute([String? id]) => "$series/${id ?? ':id'}";

  static Widget _rootPageBuilder(BuildContext context, GoRouterState _) {
    return const AppInitializationScreen();
  }

  static Widget _onboardingPageBuilder(BuildContext context, GoRouterState _) {
    return const OnboardingScreen();
  }

  static Widget _characterPageBuilder(
      BuildContext context, GoRouterState state) {
    return CharacterDetailPage(id: state.pathParameters["id"]!);
  }

  static Widget _comicPageBuilder(BuildContext context, GoRouterState state) {
    return ComicDetailPage(id: state.pathParameters["id"]!);
  }

  static Widget _seriesPageBuilder(BuildContext context, GoRouterState state) {
    return SeriesDetailPage(id: state.pathParameters["id"]!);
  }

  final _router = <GoRoute>[
    GoRoute(path: root, builder: _rootPageBuilder),
    GoRoute(path: onboarding, builder: _onboardingPageBuilder),
    GoRoute(path: home, builder: (_, state) => const HomeScreen()),
    GoRoute(path: generateCharacterRoute(), builder: _characterPageBuilder),
    GoRoute(path: generateComicRoute(), builder: _comicPageBuilder),
    GoRoute(path: generateSeriesRoute(), builder: _seriesPageBuilder),
  ];

  List<GoRoute> get router => _router;

  @override
  void addListener(VoidCallback listener) {
    _routerListener = listener;
  }

  @override
  FutureOr<void> build() {
    ref.listenSelf((previous, next) {
      if (state.isLoading) return;
      _routerListener?.call();
    });
  }

  @override
  void removeListener(VoidCallback listener) {
    _routerListener = null;
  }

  String? redirect(BuildContext context, GoRouterState state) {
    if (this.state.isLoading || this.state.hasError) return null;

    if (state.uri.path == onboarding) {
      final user = ref.read(supabaseClientProvider).auth.currentUser;
      if (user == null) return null;
      Future(() => ref.read(authProvider.notifier).setUser(user));
      return home;
    }

    return null;
  }
}

final routerNotifierProvider =
    AsyncNotifierProvider<AppRouteNotifier, void>(AppRouteNotifier.new);

final routerProvider = Provider((ref) {
  final routerNotifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
      initialLocation: AppRouteNotifier.root,
      routes: routerNotifier.router,
      refreshListenable: routerNotifier,
      debugLogDiagnostics: true,
      redirect: routerNotifier.redirect,
      observers: [BotToastNavigatorObserver()]);
});

extension AppContext on BuildContext {
  Future showBookmarkDetails(Bookmark bookmark) async {
    if (bookmark.type.toLowerCase() == "series") {
      final route = AppRouteNotifier.generateSeriesRoute(bookmark.id);
      return push(route);
    }

    final route = AppRouteNotifier.generateComicRoute(bookmark.id);
    return await push(route);
  }
}
