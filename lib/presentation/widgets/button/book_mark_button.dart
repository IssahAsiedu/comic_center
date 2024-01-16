import 'package:bot_toast/bot_toast.dart';
import 'package:comics_center/application/bookmarks_service.dart';
import 'package:comics_center/domain/book_markable.dart';
import 'package:comics_center/exceptions.dart';
import 'package:comics_center/presentation/widgets/dialog/login_dialog.dart';
import 'package:comics_center/providers/app_providers.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:comics_center/providers/auth/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BookmarkButton extends ConsumerStatefulWidget {
  const BookmarkButton({
    super.key,
    required this.bookmarkable,
  });

  final Bookmarkable bookmarkable;

  @override
  ConsumerState<BookmarkButton> createState() => _BookMarkButtonState();
}

class _BookMarkButtonState extends ConsumerState<BookmarkButton> {
  bool bookMarked = false;

  @override
  void initState() {
    bookMarked = widget.bookmarkable.bookMarked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authProvider, (previous, next) {
      if (next is AuthSuccess) {
        BotToast.showText(
          text: "Login Successful",
          align: Alignment.topCenter,
        );
      }

      if (next is AuthError) {
        BotToast.showText(
          text: "Login error",
          align: Alignment.topCenter,
        );
      }
    });

    return GestureDetector(
      onTap: _onBookmark,
      child: CircleAvatar(
        radius: 21.5,
        backgroundColor: Colors.blueAccent,
        child: CircleAvatar(
          backgroundColor: Colors.black87,
          child: !bookMarked
              ? const Icon(
                  Icons.bookmark_border_rounded,
                  color: Colors.orangeAccent,
                  size: 30,
                )
              : const Icon(
                  Icons.bookmark,
                  color: Colors.orangeAccent,
                  size: 30,
                ),
        ),
      ),
    );
  }

  Future<void> _onBookmark() async {
    try {
      setState(() => bookMarked = !bookMarked);
      final bookmarkService = ref.read(bookmarkServiceProvider);
      await bookmarkService.updateBookmarkedStatus(widget.bookmarkable);
    } catch (e) {
      setState(() => bookMarked = !bookMarked);
      if (e is! UserNotFoundException) return;
      Navigator.of(context).push(LoginDialog(() async {
        context.pop();
        await ref.read(authProvider.notifier).googleLogin();
      }));
    }
  }

  @override
  void didUpdateWidget(covariant BookmarkButton oldWidget) {
    bookMarked = widget.bookmarkable.bookMarked;
    super.didUpdateWidget(oldWidget);
  }
}
