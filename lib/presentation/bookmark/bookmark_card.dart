import 'package:comics_center/domain/bookmark.dart';
import 'package:comics_center/presentation/widgets/app_bar/home_app_bar.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BookmarkCard extends StatelessWidget {
  const BookmarkCard({
    super.key,
    required this.bookmark,
  });

  final Bookmark bookmark;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (bookmark.type.toLowerCase() != "comic") return;
        var routeWithParam =
            AppRouteNotifier.generateComicRoute("${bookmark.id}");
        context.push(routeWithParam);
      },
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
