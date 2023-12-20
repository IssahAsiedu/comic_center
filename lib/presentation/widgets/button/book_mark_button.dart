import 'package:comics_center/domain/book_markable.dart';
import 'package:comics_center/exceptions.dart';
import 'package:comics_center/presentation/widgets/dialog/login_dialog.dart';
import 'package:comics_center/providers/app_providers.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BookMarkButton extends ConsumerStatefulWidget {
  const BookMarkButton({
    super.key,
    required this.bookMarkable,
  });

  final BookMarkable bookMarkable;

  @override
  ConsumerState<BookMarkButton> createState() => _BookMarkButtonState();
}

class _BookMarkButtonState extends ConsumerState<BookMarkButton> {
  bool bookMarked = false;

  @override
  void initState() {
    bookMarked = widget.bookMarkable.bookMarked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          setState(() => bookMarked = !bookMarked);
          await ref.read(bookmarkingProvider(widget.bookMarkable).future);
        } catch (e) {
          setState(() => bookMarked = !bookMarked);
          if (e is! UserNotFoundException) return;
          Navigator.of(context).push(LoginDialog(() async {
            context.pop();
            await ref.read(authProvider.notifier).googleLogin();
          }));
        }
      },
      child: CircleAvatar(
        backgroundColor: Colors.black45,
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
    );
  }

  @override
  void didUpdateWidget(covariant BookMarkButton oldWidget) {
    bookMarked = widget.bookMarkable.bookMarked;
    super.didUpdateWidget(oldWidget);
  }
}
