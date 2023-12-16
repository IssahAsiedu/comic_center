import 'package:comics_center/presentation/shared/button/selection_button.dart';
import 'package:comics_center/providers/home/home_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var options = ['All', 'Characters', 'Comics', 'Stories'];
    final selectedOption = ref.watch(homeViewProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, i) {
                    return SelectionButton(
                      selected: selectedOption == i,
                      onTap: () =>
                          ref.read(homeViewProvider.notifier).state = i,
                      text: options[i],
                    );
                  },
                  separatorBuilder: (_, i) {
                    return const SizedBox(width: 20);
                  },
                  itemCount: options.length),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
