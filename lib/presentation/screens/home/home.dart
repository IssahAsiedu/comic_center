import 'package:comics_center/presentation/screens/home/home_all.dart';
import 'package:comics_center/presentation/screens/home/home_bookmarks.dart';
import 'package:comics_center/presentation/screens/home/home_characters.dart';
import 'package:comics_center/presentation/screens/home/home_comics.dart';
import 'package:comics_center/presentation/screens/home/home_stories.dart';
import 'package:comics_center/presentation/widgets/bottom_%20bar/app_bottom_nav.dart';
import 'package:comics_center/providers/home/home_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedOption = ref.watch(homeViewProvider);

    return FocusScope(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            const [
              HomeAllScreen(),
              HomeCharactersScreen(),
              HomeComicsScreen(),
              HomeSeriesScreen(),
              HomeBookmarksScreen(),
            ][selectedOption],
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppBottomNavigationBar(),
            ),
          ],
        ),
      ),
    );
  }

  void updateSelectedTab(ValueNotifier<int> notifier, int value) {
    if (notifier.value == value) return;
    notifier.value = value;
  }
}
