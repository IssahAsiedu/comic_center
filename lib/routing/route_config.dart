import 'dart:async';

import 'package:comics_center/presentation/character/screen/character_detail_screen.dart';
import 'package:comics_center/presentation/comic/screen/comic_detail.dart';
import 'package:comics_center/presentation/screens/home/home.dart';
import 'package:comics_center/presentation/screens/onboarding.dart';
import 'package:comics_center/providers/app_providers.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppRouteNotifier extends AutoDisposeAsyncNotifier<void>
    implements Listenable {
  static const root = "/";
  static const characters = "/characters";
  static const comics = "/comics";
  static const home = "/home";

  VoidCallback? _routerListener;

  static characterRouteWithParam([String? id]) => "$characters/${id ?? ':id'}";

  static comicRouteWithParam([String? id]) => "$comics/${id ?? ':id'}";

  static Widget _homePageRouteBuilder(BuildContext context, GoRouterState _) {
    return const OnboardingScreen();
  }

  static Widget _characterWithParam(BuildContext context, GoRouterState state) {
    return CharacterDetailPage(id: state.pathParameters["id"]!);
  }

  static Widget _comicWithParam(BuildContext context, GoRouterState state) {
    return ComicDetailPage(id: state.pathParameters["id"]!);
  }

  final _router = <GoRoute>[
    GoRoute(path: root, builder: _homePageRouteBuilder),
    GoRoute(path: home, builder: (_, state) => const HomeScreen()),
    GoRoute(path: characterRouteWithParam(), builder: _characterWithParam),
    GoRoute(path: comicRouteWithParam(), builder: _comicWithParam)
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

    final user = ref.read(supabaseClientProvider).auth.currentUser;

    if (state.uri.path == root && user != null) {
      Future(() => ref.read(authProvider.notifier).setUser(user));
      return home;
    }

    return null;
  }
}

final routerNotifierProvider =
    AutoDisposeAsyncNotifierProvider<AppRouteNotifier, void>(
        AppRouteNotifier.new);

final routerProvider = Provider.autoDispose<GoRouter>((ref) {
  final routerNotifier = ref.watch(routerNotifierProvider.notifier);

  return GoRouter(
    initialLocation: AppRouteNotifier.root,
    routes: routerNotifier.router,
    refreshListenable: routerNotifier,
    debugLogDiagnostics: true,
    redirect: routerNotifier.redirect,
  );
});
