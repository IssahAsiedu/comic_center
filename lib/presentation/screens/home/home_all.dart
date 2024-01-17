import 'dart:async';

import 'package:comics_center/presentation/screen_sections/home_all_characters.dart';
import 'package:comics_center/presentation/screen_sections/home_all_comics.dart';
import 'package:comics_center/presentation/screen_sections/home_all_series.dart';
import 'package:comics_center/presentation/widgets/app_bar/home_app_bar.dart';
import 'package:comics_center/providers/app_providers.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:comics_center/providers/auth/auth_state.dart';
import 'package:comics_center/providers/home/home_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeAllScreen extends ConsumerStatefulWidget {
  const HomeAllScreen({super.key});

  @override
  ConsumerState<HomeAllScreen> createState() => _HomeAllScreenState();
}

class _HomeAllScreenState extends ConsumerState<HomeAllScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: HomeAppBar(showLoggedInUser: authState is AuthSuccess),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(homeRefreshStreamProvider).sink.add("home");
        },
        child: ListView(
          controller: _scrollController,
          children: const [
            SizedBox(height: 10),
            HomeAllCharactersSection(),
            SizedBox(height: 20),
            HomeAllComicsSection(),
            SizedBox(height: 20),
            HomeAllSeriesSection()
          ],
        ),
      ),
    );
  }

  void _onScroll() {
    _timer?.cancel();

    ref.read(homeScrollingProvider.notifier).state = true;

    _timer = Timer(const Duration(milliseconds: 500), () {
      ref.read(homeScrollingProvider.notifier).state = false;
    });
  }
}
