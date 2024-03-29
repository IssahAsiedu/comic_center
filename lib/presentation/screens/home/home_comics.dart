import 'dart:async';

import 'package:comics_center/domain/comic/comic.dart';
import 'package:comics_center/infrastructure/network/response.dart';
import 'package:comics_center/infrastructure/network/rest_client.dart';
import 'package:comics_center/presentation/comic/widgets/comic_card.dart';
import 'package:comics_center/presentation/widgets/app_bar/home_app_bar.dart';
import 'package:comics_center/presentation/widgets/paged_empty_indicator.dart';
import 'package:comics_center/presentation/widgets/paged_error_indicator.dart';
import 'package:comics_center/presentation/widgets/search_field.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:comics_center/providers/auth/auth_state.dart';
import 'package:comics_center/providers/home/home_providers.dart';
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

  final ScrollController _scrollController = ScrollController();

  Timer? _timer;

  Timer? _scrollTimer;

  int limit = 10;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _comicsPagingController.addPageRequestListener(fetchComics);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: HomeAppBar(showLoggedInUser: authState is AuthSuccess),
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
                  scrollController: _scrollController,
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
                            AppRouteNotifier.generateComicRoute("${item.id}");
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
                  }, noItemsFoundIndicatorBuilder: (_) {
                    return PagedEmptyIndicator(
                      onRetry: () {
                        _comicsPagingController.refresh();
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
                hintText: 'Search for a comic',
                onTextChange: (_) {
                  _timer?.cancel();
                  _timer = Timer(const Duration(seconds: 1), () {
                    _comicsPagingController.refresh();
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> fetchComics(int pageKey) async {
    try {
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
      if (pageKey == pages) {
        _comicsPagingController.appendLastPage(response.data!.data);
        return;
      }

      _comicsPagingController.appendPage(response.data!.data, ++pageKey);
    } catch (e) {
      if (!mounted) return;
      _comicsPagingController.error = Error();
    }
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

  void _onScroll() {
    _scrollTimer?.cancel();

    ref.read(homeScrollingProvider.notifier).state = true;

    _scrollTimer = Timer(const Duration(milliseconds: 500), () {
      ref.read(homeScrollingProvider.notifier).state = false;
    });
  }
}
