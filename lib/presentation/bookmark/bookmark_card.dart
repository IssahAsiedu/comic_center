import 'package:comics_center/domain/bookmark.dart';
import 'package:comics_center/presentation/widgets/app_bar/home_app_bar.dart';
import 'package:flutter/material.dart';

class BookmarkCard extends StatelessWidget {
  const BookmarkCard({
    super.key,
    required this.bookmark,
  });

  final Bookmark bookmark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // image
        RoundedNetworkImage(
          size: 50,
          url: bookmark.thumbnail,
        ),

        // spacer
        const SizedBox(width: 10),

        // text
        Text(bookmark.name)
      ],
    );
  }
}
