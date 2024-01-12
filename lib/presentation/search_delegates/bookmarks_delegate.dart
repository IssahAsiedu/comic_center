import 'package:comics_center/application/bookmarks_service.dart';
import 'package:comics_center/domain/bookmark.dart';
import 'package:comics_center/presentation/bookmark/bookmark_card.dart';
import 'package:comics_center/presentation/widgets/back_button.dart';
import 'package:comics_center/presentation/widgets/paged_empty_indicator.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BookmarksDelegate extends SearchDelegate<Bookmark> {
  final WidgetRef ref;
  late PagingController<int, Bookmark> _pagingController;

  BookmarksDelegate({
    required this.ref,
    required PagingController<int, Bookmark> pagingController,
  }) {
    _pagingController = pagingController;
    _pagingController.addPageRequestListener(_onPageRequest);
  }

  @override
  List<Widget>? buildActions(BuildContext context) => null;

  @override
  Widget? buildLeading(BuildContext context) =>
      Transform.scale(scale: 0.65, child: const AppBackButton());

  @override
  Widget buildResults(BuildContext context) {
    _pagingController.refresh();
    return PagedListView<int, Bookmark>.separated(
      separatorBuilder: (_, i) {
        return const Divider(color: Colors.white70);
      },
      padding: const EdgeInsets.symmetric(horizontal: 24),
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate(
        noItemsFoundIndicatorBuilder: (_) {
          return PagedEmptyIndicator(
            onRetry: () => _pagingController.refresh(),
          );
        },
        itemBuilder: (_, bookmark, index) {
          return buildCard(bookmark, context);
        },
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final future =
        ref.read(bookmarkServiceProvider).getBookMarksFromQuery(query);
    return FutureBuilder(
      future: future,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Align(
            alignment: Alignment.center,
            child: Transform.scale(
              scale: 0.6,
              child: const CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError) {
          return const Center(child: Text('An error occurred ⚠'));
        }

        return ListView.separated(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: snapshot.data!.length,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          separatorBuilder: (_, i) {
            return const Divider(color: Colors.white70);
          },
          itemBuilder: (_, i) {
            var bookmark = snapshot.data![i];
            return buildCard(bookmark, context);
          },
        );
      },
    );
  }

  Widget buildCard(Bookmark bookmark, BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(top: 10),
        child: BookmarkCard(
          bookmark: bookmark,
          onTap: () {
            context.showBookmarkDetails(bookmark);
          },
        ));
  }

  Future<void> _onPageRequest(int key) async {
    try {
      final bookmarkService = ref.read(bookmarkServiceProvider);
      final bookmarks = await bookmarkService.getBookMarks(key, query);

      if (bookmarks.isEmpty) {
        _pagingController.appendLastPage([]);
        return;
      }

      _pagingController.appendPage(bookmarks, key + 1);
    } catch (e) {
      _pagingController.error = Error();
    }
  }
}
