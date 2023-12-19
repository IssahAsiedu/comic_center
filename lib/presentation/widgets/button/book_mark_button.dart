import 'package:comics_center/domain/book_markable.dart';
import 'package:comics_center/exceptions.dart';
import 'package:comics_center/providers/app_providers.dart';
import 'package:flutter/material.dart';
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
          print('done bookmarking');
        } catch (e) {
          setState(() => bookMarked = !bookMarked);
          if (e is! UserNotFoundException) return;
          print('User not found');
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
}
