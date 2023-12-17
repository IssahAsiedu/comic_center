import 'package:comics_center/providers/home/home_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AppBottomNavigationBar extends ConsumerStatefulWidget {
  const AppBottomNavigationBar({super.key});

  @override
  ConsumerState<AppBottomNavigationBar> createState() =>
      _AppBottomNavigationBarState();
}

class _AppBottomNavigationBarState
    extends ConsumerState<AppBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final halfScreen = MediaQuery.of(context).size.width * 0.5;

    ref.watch(homeViewProvider);
    final homeScrolling = ref.watch(homeScrollingProvider);

    return Visibility(
      visible: !homeScrolling,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: halfScreen / 2, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF636363),
          borderRadius: BorderRadius.circular(50),
        ),
        height: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BottomButton(
              selected: getSelectedIndex(0),
              onTap: () => ref.read(homeViewProvider.notifier).state = 0,
            ),
            const SizedBox(width: 20),
            _BottomButton(
              iconData: Icons.bookmark_border_rounded,
              selected: getSelectedIndex(4),
              onTap: () => ref.read(homeViewProvider.notifier).state = 4,
            )
          ],
        ),
      ),
    );
  }

  bool getSelectedIndex(int index) {
    final selectedHomeOption = ref.read(homeViewProvider);
    if (index == 0) {
      return selectedHomeOption < 4;
    }

    return selectedHomeOption == 4;
  }
}

class _BottomButton extends StatelessWidget {
  const _BottomButton({
    this.selected = false,
    this.iconData = Icons.home_mini,
    this.onTap,
  });

  final bool selected;
  final IconData iconData;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: selected ? Colors.blueAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          iconData,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }
}
