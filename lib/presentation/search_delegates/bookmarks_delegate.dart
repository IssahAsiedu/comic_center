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
    return SizedBox.shrink();
  }
}
