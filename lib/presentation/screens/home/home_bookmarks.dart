import 'package:bot_toast/bot_toast.dart';
import 'package:comics_center/application/bookmarks_service.dart';
import 'package:comics_center/domain/book_markable.dart';
import 'package:comics_center/domain/bookmark.dart';
import 'package:comics_center/presentation/bookmark/bookmark_card.dart';
import 'package:comics_center/presentation/search_delegates/bookmarks_delegate.dart';
import 'package:comics_center/presentation/widgets/back_button.dart';
import 'package:comics_center/presentation/widgets/dialog/error_dialog.dart';
import 'package:comics_center/presentation/widgets/dialog/login_dialog.dart';
import 'package:comics_center/presentation/widgets/paged_empty_indicator.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:comics_center/providers/auth/auth_state.dart';
import 'package:comics_center/providers/home/home_providers.dart';
import 'package:comics_center/routing/route_config.dart';
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
    Future(() {
      final authState = ref.read(authProvider);
      if (authState is AuthSuccess) return;
      Navigator.of(context).push(LoginDialog(() async {
        context.pop();
        await ref.read(authProvider.notifier).googleLogin();
      }));
    });

    ref.listen(authProvider, (previous, next) {
      _listenToAuthProvider(next);
    });

    return Scaffold(
      appBar: AppBar(
        leading: Transform.scale(
          scale: 0.7,
          child: AppBackButton(
            onTap: _onBackButton,
          ),
        ),
        backgroundColor: Colors.black12,
        centerTitle: true,
        title: const Text(
          'Bookmarks',
          style: TextStyle(fontFamily: 'Bangers'),
        ),
        elevation: 0,
        actions: [
          InkWell(
            onTap: () async {
              PagingController<int, Bookmark> pagingController =
                  PagingController(firstPageKey: 0);
              await showSearch(
                context: context,
                delegate: BookmarksDelegate(
                    ref: ref, pagingController: pagingController),
              );
              pagingController.dispose();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 20),
              child: const Icon(Icons.search),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      _bookmarksPagingController.refresh();
                    },
                    child: PagedListView<int, Bookmark>.separated(
                      separatorBuilder: (_, i) {
                        return const Divider(color: Colors.white70);
                      },
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      pagingController: _bookmarksPagingController,
                      builderDelegate: PagedChildBuilderDelegate(
                        noItemsFoundIndicatorBuilder: (_) {
                          return PagedEmptyIndicator(
                            onRetry: () => _bookmarksPagingController.refresh(),
                          );
                        },
                        itemBuilder: (_, bookmark, index) {
                          return Container(
                            margin: EdgeInsets.only(
                                top: index == 0 ? 20 : 0,
                                bottom: _isLastItem(index) ? 50 : 0),
                            child: Dismissible(
                              key: ValueKey(bookmark.pk),
                              onDismissed: (_) async =>
                                  _onBookmarkDismissed(bookmark),
                              background: ColoredBox(
                                color: Colors.redAccent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(Icons.delete, color: Colors.white)
                                  ],
                                ),
                              ),
                              child: BookmarkCard(
                                bookmark: bookmark,
                                onTap: () => _onBookmarkTapped(bookmark),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 78)
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onBackButton() {
    var currentState = ref.read(homeViewProvider);
    ref.read(homeViewProvider.notifier).state = HomePageState(
      current: currentState.previous,
      previous: currentState.previous,
    );
  }

  void _listenToAuthProvider(AuthState next) {
    switch (next.runtimeType) {
      case AuthSuccess:
        BotToast.showText(
          text: "Login Successful",
          align: Alignment.topCenter,
        );
        _bookmarksPagingController.refresh();
        break;
      case AuthError:
        BotToast.showText(
          text: "Login error",
          align: Alignment.topCenter,
        );
        break;
    }
  }

  Future<void> _onBookmarkDismissed(Bookmark bookmark) async {
    try {
      await ref.read(bookmarkServiceProvider).deleteBookmark(bookmark.pk);
      _removeItemWithId(bookmark.pk);
    } catch (e) {
      if (!mounted) return;
      var message = "item was not removed";
      Navigator.of(context).push(ErrorDialog(message: message));
    }
  }

  Future<void> _onBookmarkTapped(Bookmark bookmark) async {
    Bookmarkable? value;

    value = await context.showBookmarkDetails(bookmark);

    if (value == null) return;
    if (value.bookMarked) return;

    _removeItemWithId(bookmark.pk);
  }

  void _removeItemWithId(String id) {
    var items = _bookmarksPagingController.itemList?.where((e) {
      return e.pk != id;
    }).toList();

    if (items == null) return;
    _bookmarksPagingController.itemList = items;
  }

  Future<void> _onPageRequest(int key) async {
    try {
      final bookmarkService = ref.read(bookmarkServiceProvider);
      final bookmarks = await bookmarkService.getBookMarks(key);

      if (bookmarks.isEmpty) {
        _bookmarksPagingController.appendLastPage([]);
        return;
      }

      _bookmarksPagingController.appendPage(bookmarks, key + 1);
    } catch (e) {
      if (!mounted) return;
      _bookmarksPagingController.error = Error();
    }
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
