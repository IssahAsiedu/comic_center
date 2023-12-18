import 'package:comics_center/presentation/character/screen/character_detail_screen.dart';
import 'package:comics_center/presentation/comic/screen/comic_detail.dart';
import 'package:comics_center/presentation/screens/home/home.dart';
import 'package:comics_center/presentation/screens/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRoute {
  static const root = "/";
  static const characters = "/characters";
  static const comics = "/comics";
  static const home = "/home";

  AppRoute._();

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

  static final GoRouter _router = GoRouter(routes: <GoRoute>[
    GoRoute(path: root, builder: _homePageRouteBuilder),
    GoRoute(path: home, builder: (_, state) => const HomeScreen()),
    GoRoute(path: characterRouteWithParam(), builder: _characterWithParam),
    GoRoute(path: comicRouteWithParam(), builder: _comicWithParam)
  ]);

  static GoRouter get router => _router;
}
