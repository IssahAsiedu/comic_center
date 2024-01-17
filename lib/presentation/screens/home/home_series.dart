import 'dart:async';

import 'package:comics_center/domain/Series/series.dart';
import 'package:comics_center/domain/book_markable.dart';
import 'package:comics_center/infrastructure/network/response.dart';
import 'package:comics_center/infrastructure/network/rest_client.dart';
import 'package:comics_center/presentation/Series/home_series_card.dart';
import 'package:comics_center/presentation/widgets/app_bar/home_app_bar.dart';
import 'package:comics_center/presentation/widgets/paged_empty_indicator.dart';
import 'package:comics_center/presentation/widgets/paged_error_indicator.dart';
import 'package:comics_center/presentation/widgets/search_field.dart';
import 'package:comics_center/providers/app_providers.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:comics_center/providers/auth/auth_state.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:comics_center/shared/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeSeriesScreen extends ConsumerStatefulWidget {
  const HomeSeriesScreen({super.key});

  @override
  ConsumerState<HomeSeriesScreen> createState() => _HomeStoriesScreenState();
}

class _HomeStoriesScreenState extends ConsumerState<HomeSeriesScreen> {
  final PagingController<int, Series> _seriesPagingController =
      PagingController(firstPageKey: 0);

  final TextEditingController _searchController = TextEditingController();

  int limit = 10;

  Timer? _timer;

  @override
  void initState() {
    _seriesPagingController.addPageRequestListener(fetchSeries);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next is! AuthSuccess && next is! AuthInitial) return;
      _seriesPagingController.refresh();
    });

    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: HomeAppBar(showLoggedInUser: authState is AuthSuccess),
      body: Stack(
        children: [
          //series
          Positioned.fill(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 54),
              child: RefreshIndicator(
                onRefresh: () async {
                  _searchController.text = "";
                  _seriesPagingController.refresh();
                },
                child: PagedGridView<int, Series>(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    pagingController: _seriesPagingController,
                    builderDelegate: PagedChildBuilderDelegate(itemBuilder: (
                      BuildContext context,
                      Series item,
                      int index,
                    ) {
                      return HomeSeriesCard(
                        series: item,
                        onTap: () async {
                          var route = AppRouteNotifier.generateSeriesRoute(
                              "${item.id}");
                          final result = await context.push(route);
                          if (result is! Bookmarkable) return;
                          setState(() => item.bookMarked = result.bookMarked);
                        },
                      );
                    }, firstPageErrorIndicatorBuilder: (_) {
                      return PagedErrorIndicator(
                        onTap: () =>
                            _seriesPagingController.retryLastFailedRequest(),
                      );
                    }, newPageErrorIndicatorBuilder: (_) {
                      return PagedErrorIndicator(
                        onTap: () =>
                            _seriesPagingController.retryLastFailedRequest(),
                      );
                    }, noItemsFoundIndicatorBuilder: (_) {
                      return PagedEmptyIndicator(
                        onRetry: () => _seriesPagingController.refresh(),
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
                hintText: 'Search for a series',
                onTextChange: (_) {
                  _timer?.cancel();
                  _timer = Timer(const Duration(seconds: 1), () {
                    _seriesPagingController.refresh();
                  });
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> fetchSeries(int pageKey) async {
    try {
      var query = <String, dynamic>{"offset": pageKey * limit, "limit": limit};

      if (_searchController.text.isNotEmpty) {
        query["titleStartsWith"] = _searchController.text;
      }

      var response = await MarvelRestClient().getSeries(query);

      if (response.status == Status.error) {
        _seriesPagingController.error = Error();
        return;
      }

      final series = response.data!.data;
      final table =
          ref.read(supabaseClientProvider).from(AppStrings.bookmarksTable);
      final authState = ref.read(authProvider);

      if (authState is AuthSuccess) {
        for (var s in series) {
          List<dynamic>? result = await table
              .select()
              .eq("userid", authState.user.id)
              .eq('id', s.id);
          if (result != null && result.isNotEmpty) s.bookMarked = true;
        }
      }

      var pages = (response.data!.total / limit).ceil();

      if (pageKey == pages) {
        _seriesPagingController.appendLastPage(series);
        return;
      }
      _seriesPagingController.appendPage(series, ++pageKey);
    } catch (e) {
      if (!mounted) return;
      _seriesPagingController.error = Error();
    }
  }
}
