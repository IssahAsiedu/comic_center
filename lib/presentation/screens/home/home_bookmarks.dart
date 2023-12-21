import 'package:comics_center/domain/book_markable.dart';
import 'package:comics_center/domain/bookmark.dart';
import 'package:comics_center/presentation/bookmark/bookmark_card.dart';
import 'package:comics_center/presentation/widgets/back_button.dart';
import 'package:comics_center/providers/app_providers.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:comics_center/providers/auth/auth_state.dart';
import 'package:comics_center/providers/home/home_providers.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:comics_center/shared/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeBookmarksScreen extends ConsumerStatefulWidget {
  const HomeBookmarksScreen({super.key});

  @override
  ConsumerState<HomeBookmarksScreen> createState() =>
      _HomeBookmarksScreenState();
}

class _HomeBookmarksScreenState extends ConsumerState<HomeBookmarksScreen> {
  final _bookmarksPagingController =
      PagingController<int, Bookmark>(firstPageKey: 0);
  final limit = 5;

  @override
  void initState() {
    _bookmarksPagingController.addPageRequestListener(_onPageRequest);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Transform.scale(
          scale: 0.7,
          child: AppBackButton(
            onTap: () {
              var currentState = ref.read(homeViewProvider);

              ref.read(homeViewProvider.notifier).state = HomePageState(
                current: currentState.previous,
                previous: currentState.previous,
              );
            },
          ),
        ),
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: const Text(
          'Bookmarks',
          style: TextStyle(fontFamily: 'Bangers'),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: RefreshIndicator(
              onRefresh: () async {
                _bookmarksPagingController.refresh();
              },
              child: PagedListView<int, Bookmark>.separated(
                separatorBuilder: (_, i) {
                  return const Divider(color: Colors.white);
                },
                padding: const EdgeInsets.symmetric(horizontal: 24),
                pagingController: _bookmarksPagingController,
                builderDelegate: PagedChildBuilderDelegate(
                  itemBuilder: (_, bookmark, index) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: index == 0 ? 20 : 0,
                          bottom: _isLastItem(index) ? 50 : 0),
                      child: BookmarkCard(
                        bookmark: bookmark,
                        onTap: () async {
                          Bookmarkable? value;
                          if (bookmark.type.toLowerCase() == "series") {
                            var route = AppRouteNotifier.generateSeriesRoute(
                                bookmark.id);
                            value = await context.push(route);
                          }

                          if (bookmark.type.toLowerCase() == "comic" &&
                              mounted) {
                            var route = AppRouteNotifier.generateComicRoute(
                                bookmark.id);
                            value = await context.push(route);
                          }

                          if (value == null) return;
                          if (value.bookMarked) return;

                          var items = _bookmarksPagingController.itemList
                              ?.where((element) {
                            return element.pk != bookmark.pk;
                          }).toList();

                          if (items == null) return;
                          _bookmarksPagingController.itemList = items;
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onPageRequest(int key) async {
    final table =
        ref.read(supabaseClientProvider).from(AppStrings.bookmarksTable);

    final authState = ref.read(authProvider);

    if (authState is! AuthSuccess) {
      _bookmarksPagingController.appendLastPage([]);
      return;
    }

    final from = key * limit;
    final to = (from + limit) - 1;
    List<dynamic> result = await table.select().match(
      {"userid": authState.user.id},
    ).range(from, to);

    if (result.isEmpty && mounted) {
      _bookmarksPagingController.appendLastPage([]);
      return;
    }

    var bookmarks = result.map((e) => Bookmark.fromMap(e)).toList();

    if (!mounted) return;
    _bookmarksPagingController.appendPage(bookmarks, key + 1);
  }

  bool _isLastItem(int index) {
    return index == _bookmarksPagingController.itemList!.length - 1;
  }

  @override
  void dispose() {
    _bookmarksPagingController.dispose();
    super.dispose();
  }
}
