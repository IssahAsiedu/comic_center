import 'package:comics_center/presentation/widgets/button/selection_button.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:comics_center/providers/auth/auth_state.dart';
import 'package:comics_center/providers/home/home_providers.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, required this.showLoggedInUser});

  final bool showLoggedInUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var options = ['All', 'Characters', 'Comics', 'Series'];
    final selectedOption = ref.watch(homeViewProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            const _UserDetails(),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  return SelectionButton(
                    selected: selectedOption.current == i,
                    onTap: () {
                      final currentState = ref.read(homeViewProvider);
                      ref.read(homeViewProvider.notifier).state = HomePageState(
                          current: i, previous: currentState.current);
                    },
                    text: options[i],
                  );
                },
                separatorBuilder: (_, i) {
                  return const SizedBox(width: 20);
                },
                itemCount: options.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(showLoggedInUser ? 120 : 81);
}

class _UserDetails extends HookConsumerWidget {
  const _UserDetails();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState is! AuthSuccess) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoundedNetworkImage(size: 30, url: authState.user.avatarUrl),
              Text('Hey, ${authState.user.displayName}'),
            ],
          ),
          InkWell(
            onTap: () => ref.read(authProvider.notifier).logout(),
            child: Container(
              width: 30,
              height: 30,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(15)),
              child: const Icon(
                Icons.logout,
                color: Colors.white,
                size: 19,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RoundedNetworkImage extends StatelessWidget {
  const RoundedNetworkImage({
    super.key,
    required this.size,
    required this.url,
  });

  final double size;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.only(right: 10),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Image.network(
        url,
        fit: BoxFit.cover,
      ),
    );
  }
}
