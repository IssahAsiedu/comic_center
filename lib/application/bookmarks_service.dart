import 'package:comics_center/domain/book_markable.dart';
import 'package:comics_center/domain/bookmark.dart';
import 'package:comics_center/exceptions.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:comics_center/providers/auth/auth_state.dart' as state;
import 'package:comics_center/shared/app_strings.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as p;

import '../providers/app_providers.dart';

class BookmarksService {
  late SupabaseQueryBuilder table;
  final state.AuthState authState;

  BookmarksService({
    required SupabaseClient supabaseClient,
    required this.authState,
  }) {
    table = supabaseClient.from(AppStrings.bookmarksTable);
  }

  Future<void> updateBookmarkedStatus(Bookmarkable bookmarkable) async {
    if (authState is! state.AuthSuccess) {
      throw UserNotFoundException();
    }

    var userId = (authState as state.AuthSuccess).user.id;

    if (bookmarkable.bookMarked) {
      await table.delete().match({"userid": userId, "id": bookmarkable.id});
      bookmarkable.bookMarked = false;
      return;
    }

    var data = bookmarkable.bookmarkData;
    data['userid'] = userId;

    await table.insert(data);
    bookmarkable.bookMarked = true;
  }

  Future<List<Bookmark>> getBookMarks(int page) async {
    if (authState is! state.AuthSuccess) {
      return [];
    }

    final from = page * 5;
    final to = (from + 5) - 1;
    List<dynamic> result = await table.select().match(
      {"userid": (authState as state.AuthSuccess).user.id},
    ).range(from, to);

    if (result.isEmpty) return [];

    return result.map((e) => Bookmark.fromMap(e)).toList();
  }

  Future<List<Bookmark>> getBookMarksFromQuery(String query) async {
    List<dynamic> result = await table.select().match(
      {"userid": (authState as state.AuthSuccess).user.id, "name": query},
    ).limit(7);

    return result.map((e) => Bookmark.fromMap(e)).toList();
  }

  Future<void> deleteBookmark(String bookmarkId) async {
    await table.delete().match({"pk": bookmarkId});
  }
}

final bookmarkServiceProvider = p.Provider((ref) {
  final authState = ref.watch(authProvider);
  final supabaseClient = ref.read(supabaseClientProvider);
  return BookmarksService(supabaseClient: supabaseClient, authState: authState);
});
