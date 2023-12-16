import 'package:comics_center/presentation/screens/home/home_all.dart';
import 'package:comics_center/presentation/screens/home/home_characters.dart';
import 'package:comics_center/presentation/screens/home/home_comics.dart';
import 'package:comics_center/presentation/screens/home/home_stories.dart';
import 'package:comics_center/presentation/shared/button/selection_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTabNotifier = useState(0);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          const [
            HomeAllScreen(),
            HomeCharactersScreen(),
            HomeComicsScreen(),
            HomeStoriesScreen()
          ][selectedTabNotifier.value],
          SafeArea(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SelectionButton(
                    text: 'All',
                    selected: selectedTabNotifier.value == 0,
                    onTap: () => updateSelectedTab(selectedTabNotifier, 0),
                  ),
                  SelectionButton(
                    text: 'Characters',
                    selected: selectedTabNotifier.value == 1,
                    onTap: () => updateSelectedTab(selectedTabNotifier, 1),
                  ),
                  SelectionButton(
                    text: 'Comics',
                    selected: selectedTabNotifier.value == 2,
                    onTap: () => updateSelectedTab(selectedTabNotifier, 2),
                  ),
                  SelectionButton(
                    text: 'Stories',
                    selected: selectedTabNotifier.value == 3,
                    onTap: () => updateSelectedTab(selectedTabNotifier, 3),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void updateSelectedTab(ValueNotifier<int> notifier, int value) {
    if (notifier.value == value) return;
    notifier.value = value;
  }
}
