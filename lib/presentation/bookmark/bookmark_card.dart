import 'package:comics_center/domain/bookmark.dart';
import 'package:comics_center/presentation/widgets/app_bar/home_app_bar.dart';
import 'package:flutter/material.dart';

class BookmarkCard extends StatelessWidget {
  const BookmarkCard({super.key, required this.bookmark, this.onTap});

  final Bookmark bookmark;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          // image
          RoundedNetworkImage(
            size: 50,
            url: bookmark.thumbnail,
          ),

          // spacer
          const SizedBox(width: 10),

          // text
          SizedBox(width: 200, child: Text(bookmark.name))
        ],
      ),
    );
  }
}
