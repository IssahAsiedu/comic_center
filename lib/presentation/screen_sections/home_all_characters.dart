import 'dart:async';

import 'package:comics_center/domain/character/character.dart';
import 'package:comics_center/infrastructure/network/response.dart';
import 'package:comics_center/infrastructure/network/rest_client.dart';
import 'package:comics_center/presentation/character/widgets/character_card.dart';
import 'package:comics_center/presentation/widgets/paged_error_indicator.dart';
import 'package:comics_center/providers/app_providers.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:comics_center/shared/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeAllCharactersSection extends ConsumerStatefulWidget {
  const HomeAllCharactersSection({super.key});

  @override
  ConsumerState<HomeAllCharactersSection> createState() =>
      _HomeAllCharactersSectionState();
}

class _HomeAllCharactersSectionState
    extends ConsumerState<HomeAllCharactersSection> {
  final PagingController<int, Character> _characterPagingController =
      PagingController(firstPageKey: 0);
  StreamSubscription? _subscription;
  int limit = 10;

  @override
  void initState() {
    _subscription = ref.read(homeRefreshStreamProvider).stream.listen((event) {
      if (event == "home") _characterPagingController.refresh();
    });
    _characterPagingController.addPageRequestListener(fetchCharacters);
    ref.read(homeRefreshStreamProvider).stream.listen((event) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var listHeight = MediaQuery.of(context).size.height * 0.3;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              const Icon(
                Icons.local_fire_department_rounded,
                color: Colors.orangeAccent,
              ),
              const SizedBox(width: 20),
              Text(
                AppStrings.charactersTitle,
                style: const TextStyle(fontFamily: 'Bangers', fontSize: 24),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: listHeight,
          child: PagedListView<int, Character>.separated(
            pagingController: _characterPagingController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            builderDelegate: PagedChildBuilderDelegate(
                animateTransitions: true,
                itemBuilder: (
                  context,
                  item,
                  index,
                ) {
                  var itemWidth = MediaQuery.of(context).size.width * 0.4;

                  var margin = EdgeInsets.only(
                    left: index == 0 ? 24 : 0,
                    right: _isLastItem(index) ? 24 : 0,
                  );

                  return CharacterCard(
                    itemWidth: itemWidth,
                    itemHeight: listHeight,
                    thumbnailUrl: item.thumbnail!,
                    characterName: item.name,
                    margin: margin,
                    onTap: () {
                      context.push(
                        AppRouteNotifier.generateCharacterRoute("${item.id}"),
                      );
                    },
                  );
                },
                firstPageErrorIndicatorBuilder: (_) {
                  return PagedErrorIndicator(
                    onTap: () =>
                        _characterPagingController.retryLastFailedRequest(),
                  );
                },
                newPageErrorIndicatorBuilder: (_) {
                  return PagedErrorIndicator(
                    onTap: () =>
                        _characterPagingController.retryLastFailedRequest(),
                  );
                }),
          ),
        ),
      ],
    );
  }

  Future<void> fetchCharacters(int pageKey) async {
    var query = <String, dynamic>{"offset": pageKey * limit, "limit": limit};

    var response = await MarvelRestClient().getCharacter(query);

    if (response.status == Status.error && mounted) {
      _characterPagingController.error = Error();
      return;
    }

    var pages = (response.data!.total / limit).ceil();

    if (pageKey == pages && mounted) {
      _characterPagingController.appendLastPage(response.data!.data);
      return;
    }

    if (!mounted) return;
    _characterPagingController.appendPage(response.data!.data, ++pageKey);
  }

  bool _isLastItem(int index) {
    return index == _characterPagingController.itemList!.length - 1;
  }

  @override
  void dispose() {
    _characterPagingController.dispose();
    _subscription?.cancel();
    super.dispose();
  }
}
