import 'package:comics_center/application/bookmarks_service.dart';
import 'package:comics_center/domain/bookmark.dart';
import 'package:comics_center/presentation/widgets/back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BookmarksDelegate extends SearchDelegate<Bookmark> {
  final WidgetRef ref;

  BookmarksDelegate(this.ref);

  @override
  List<Widget>? buildActions(BuildContext context) => null;

  @override
  Widget? buildLeading(BuildContext context) =>
      Transform.scale(scale: 0.7, child: const AppBackButton());

  @override
  Widget buildResults(BuildContext context) {
    return SizedBox.shrink();
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
          separatorBuilder: (_, i) {
            return const Divider(color: Colors.white12);
          },
          itemBuilder: (_, i) {
            var bookmark = snapshot.data![i];
            return Container(
              padding: const EdgeInsets.all(10),
              child: Text(
                bookmark.name,
                style: const TextStyle(fontSize: 15),
              ),
            );
          },
        );
      },
    );
  }
}
