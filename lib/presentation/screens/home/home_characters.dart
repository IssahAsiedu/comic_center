import 'package:comics_center/domain/character/character.dart';
import 'package:comics_center/infrastructure/network/response.dart';
import 'package:comics_center/infrastructure/network/rest_client.dart';
import 'package:comics_center/presentation/character/widgets/character_card.dart';
import 'package:comics_center/presentation/widgets/app_bar/home_app_bar.dart';
import 'package:comics_center/presentation/widgets/paged_error_indicator.dart';
import 'package:comics_center/presentation/widgets/search_field.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeCharactersScreen extends ConsumerStatefulWidget {
  const HomeCharactersScreen({super.key});

  @override
  ConsumerState<HomeCharactersScreen> createState() =>
      _HomeCharactersScreenState();
}

class _HomeCharactersScreenState extends ConsumerState<HomeCharactersScreen> {
  final PagingController<int, Character> _characterPagingController =
      PagingController(firstPageKey: 0);
  final TextEditingController _searchController = TextEditingController();
  final int limit = 10;

  @override
  void initState() {
    _characterPagingController.addPageRequestListener(fetchCharacters);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Stack(
        children: [
          //Characters
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 54),
              child: RefreshIndicator(
                onRefresh: () async {
                  _searchController.text = "";
                  _characterPagingController.refresh();
                },
                child: PagedGridView<int, Character>(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    pagingController: _characterPagingController,
                    builderDelegate: PagedChildBuilderDelegate(itemBuilder: (
                      BuildContext context,
                      Character item,
                      int index,
                    ) {
                      return CharacterCard(
                        thumbnailUrl: item.thumbnail!,
                        characterName: item.name,
                        itemWidth: 200,
                        itemHeight: 200,
                        onTap: () {
                          context.push(
                            AppRouteNotifier.characterRouteWithParam(
                                "${item.id}"),
                          );
                        },
                      );
                    }, firstPageErrorIndicatorBuilder: (_) {
                      return PagedErrorIndicator(
                        onTap: () =>
                            _characterPagingController.retryLastFailedRequest(),
                      );
                    }, newPageErrorIndicatorBuilder: (_) {
                      return PagedErrorIndicator(
                        onTap: () =>
                            _characterPagingController.retryLastFailedRequest(),
                      );
                    })),
              ),
            ),
          ),

          //search input
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.only(
                left: 24,
                right: 24,
              ),
              child: SearchField(
                textController: _searchController,
                onSubmit: () => _characterPagingController.refresh(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> fetchCharacters(int pageKey) async {
    var query = <String, dynamic>{"offset": pageKey * limit, "limit": limit};
    if (_searchController.text.isNotEmpty) {
      query["nameStartsWith"] = _searchController.text;
    }
    var response = await MarvelRestClient().getCharacter(query);

    if (response.status == Status.error) {
      _characterPagingController.error = Error();
      return;
    }

    var pages = (response.data!.total / limit).ceil();

    if (pageKey == pages) {
      _characterPagingController.appendLastPage(response.data!.data);
      return;
    }

    _characterPagingController.appendPage(response.data!.data, ++pageKey);
  }

  @override
  void dispose() {
    _characterPagingController.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
