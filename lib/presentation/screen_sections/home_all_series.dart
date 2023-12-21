import 'dart:async';

import 'package:comics_center/domain/Series/series.dart';
import 'package:comics_center/domain/book_markable.dart';
import 'package:comics_center/infrastructure/network/response.dart';
import 'package:comics_center/infrastructure/network/rest_client.dart';
import 'package:comics_center/presentation/Series/home_series_card.dart';
import 'package:comics_center/presentation/widgets/paged_error_indicator.dart';
import 'package:comics_center/providers/app_providers.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:comics_center/shared/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeAllSeriesSection extends ConsumerStatefulWidget {
  const HomeAllSeriesSection({super.key});

  @override
  ConsumerState<HomeAllSeriesSection> createState() =>
      _HomeAllStoriesSectionState();
}

class _HomeAllStoriesSectionState extends ConsumerState<HomeAllSeriesSection> {
  final PagingController<int, Series> _storyPagingController =
      PagingController(firstPageKey: 0);
  StreamSubscription? _subscription;
  int limit = 10;

  @override
  void initState() {
    _subscription = ref.read(homeRefreshStreamProvider).stream.listen((event) {
      if (event == "home") _storyPagingController.refresh();
    });
    _storyPagingController.addPageRequestListener(fetchStories);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              const Icon(
                Icons.change_history_sharp,
                color: Colors.orangeAccent,
              ),
              const SizedBox(width: 20),
              Text(
                AppStrings.seriesTitle,
                style: const TextStyle(fontFamily: 'Bangers', fontSize: 24),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 183,
          child: PagedListView<int, Series>.separated(
            pagingController: _storyPagingController,
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

                  return HomeSeriesCard(
                    margin: margin,
                    series: item,
                    width: itemWidth,
                    onTap: () async {
                      var route =
                          AppRouteNotifier.generateSeriesRoute("${item.id}");
                      final result = await context.push(route);
                      if (result is! Bookmarkable) return;
                      setState(() => item.bookMarked = result.bookMarked);
                    },
                  );
                },
                firstPageErrorIndicatorBuilder: (_) {
                  return PagedErrorIndicator(
                    onTap: () {
                      _storyPagingController.retryLastFailedRequest();
                    },
                  );
                },
                newPageErrorIndicatorBuilder: (_) {
                  return PagedErrorIndicator(
                    onTap: () {
                      _storyPagingController.retryLastFailedRequest();
                    },
                  );
                }),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Future<void> fetchStories(int pageKey) async {
    var query = <String, dynamic>{"offset": pageKey * limit, "limit": limit};

    var response = await MarvelRestClient().getSeries(query);

    if (response.status == Status.error) {
      _storyPagingController.error = Error();
      return;
    }

    var pages = (response.data!.total / limit).ceil();

    if (pageKey == pages && mounted) {
      _storyPagingController.appendLastPage(response.data!.data);
      return;
    }

    if (!mounted) return;
    _storyPagingController.appendPage(response.data!.data, ++pageKey);
  }

  bool _isLastItem(int index) {
    return index == _storyPagingController.itemList!.length - 1;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _storyPagingController.dispose();
    super.dispose();
  }
}
