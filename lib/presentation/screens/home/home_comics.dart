import 'package:comics_center/domain/comic/comic.dart';
import 'package:comics_center/infrastructure/network/response.dart';
import 'package:comics_center/infrastructure/network/rest_client.dart';
import 'package:comics_center/presentation/comic/widgets/comic_card.dart';
import 'package:comics_center/presentation/widgets/app_bar/home_app_bar.dart';
import 'package:comics_center/presentation/widgets/paged_error_indicator.dart';
import 'package:comics_center/presentation/widgets/search_field.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeComicsScreen extends ConsumerStatefulWidget {
  const HomeComicsScreen({super.key});

  @override
  ConsumerState<HomeComicsScreen> createState() => _HomeComicsScreenState();
}

class _HomeComicsScreenState extends ConsumerState<HomeComicsScreen> {
  final _searchController = TextEditingController();

  final PagingController<int, Comic> _comicsPagingController =
      PagingController(firstPageKey: 0);

  int limit = 10;

  @override
  void initState() {
    _comicsPagingController.addPageRequestListener(fetchComics);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      body: Stack(
        children: [
          //comics
          Positioned.fill(
            child: RefreshIndicator(
              onRefresh: () async {
                _searchController.text = "";
                _comicsPagingController.refresh();
              },
              child: PagedListView<int, Comic>.separated(
                  clipBehavior: Clip.antiAlias,
                  pagingController: _comicsPagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, item, index) {
                    final margin = EdgeInsets.only(
                      top: index == 0 ? 70 : 0,
                      left: 24,
                      right: 24,
                      bottom: _isLastItem(index) ? 100 : 0,
                    );

                    return ComicCard(
                      comic: item,
                      margin: margin,
                      onTap: () {
                        var route =
                            AppRouteNotifier.comicRouteWithParam("${item.id}");
                        context.push(route);
                      },
                    );
                  }, firstPageErrorIndicatorBuilder: (_) {
                    return PagedErrorIndicator(
                      onTap: () {
                        _comicsPagingController.retryLastFailedRequest();
                      },
                    );
                  }, newPageErrorIndicatorBuilder: (_) {
                    return PagedErrorIndicator(
                      onTap: () {
                        _comicsPagingController.retryLastFailedRequest();
                      },
                    );
                  }),
                  separatorBuilder: (_, i) {
                    return const SizedBox(height: 10);
                  }),
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
                onSubmit: _onSubmitText,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _onSubmitText() {
    _comicsPagingController.refresh();
  }

  Future<void> fetchComics(int pageKey) async {
    var query = <String, dynamic>{"offset": pageKey * limit, "limit": limit};

    if (_searchController.text.isNotEmpty) {
      query["titleStartsWith"] = _searchController.text;
    }
    var response = await MarvelRestClient().getComics(query);

    if (response.status == Status.error) {
      _comicsPagingController.error = Error();
      return;
    }
    var pages = (response.data!.total / limit).ceil();
    if (pageKey == pages && mounted) {
      _comicsPagingController.appendLastPage(response.data!.data);
      return;
    }

    if (!mounted) return;
    _comicsPagingController.appendPage(response.data!.data, ++pageKey);
  }

  bool _isLastItem(int index) {
    return index == _comicsPagingController.itemList!.length - 1;
  }

  @override
  void dispose() {
    _searchController.dispose();
    _comicsPagingController.dispose();
    super.dispose();
  }
}
