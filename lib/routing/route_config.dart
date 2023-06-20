import 'package:comics_center/character/screen/character_detail_screen.dart';
import 'package:comics_center/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../comic/screen/comic_detail.dart';

class AppRoute {
  static const root = "/";
  static const characters = "/characters";
  static const comics = "/comics";

  static characterRouteWithParam([String? id]) => "$characters/${id ?? ':id'}";

  static comicRouteWithParam([String? id]) => "$comics/${id ?? ':id'}";

  static Widget _homePageRouteBuilder(BuildContext context, GoRouterState _) {
    return const MainScreen();
  }

  static Widget _characterWithParam(BuildContext context, GoRouterState state) {
    return CharacterDetailPage(id: state.pathParameters["id"]!);
  }

  static Widget _comicWithParam(BuildContext context, GoRouterState state) {
    return ComicDetailPage(id: state.pathParameters["id"]!);
  }

  static final GoRouter _router = GoRouter(routes: <GoRoute>[
    GoRoute(path: root, builder: _homePageRouteBuilder),
    GoRoute(path: characterRouteWithParam(), builder: _characterWithParam),
    GoRoute(path: comicRouteWithParam(), builder: _comicWithParam)
  ]);

  static GoRouter get router => _router;
}
