import 'package:comics_center/domain/book_markable.dart';
import 'package:comics_center/domain/character/character_detail.dart';
import 'package:comics_center/domain/item.dart';
import 'package:comics_center/presentation/widgets/back_button.dart';
import 'package:comics_center/presentation/widgets/button/book_mark_button.dart';
import 'package:comics_center/presentation/widgets/detail_list.dart';
import 'package:comics_center/presentation/widgets/slide_widget.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CharacterDetailBody extends StatelessWidget {
  final CharacterDetails characterDetails;

  const CharacterDetailBody({
    Key? key,
    required this.characterDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      appBar: ImageAppBar(
        thumbnail: characterDetails.thumbnail!,
        title: characterDetails.name,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          const SizedBox(height: 24),
          Text(characterDetails.description),
          DetailList(
            items: characterDetails.comics,
            title: "Comics",
            onTap: (e) {
              var route = AppRouteNotifier.generateComicRoute("${e.id}");
              context.push(route);
            },
          ),
          DetailList(
            items: characterDetails.series,
            title: "Series",
            onTap: (e) {
              var route = AppRouteNotifier.generateSeriesRoute("${e.id}");
              context.push(route);
            },
          ),
        ],
      ),
    );
  }
}

class ImageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ImageAppBar({
    super.key,
    required this.thumbnail,
    required this.title,
    this.item,
    this.onBack,
  });

  final String thumbnail;
  final String title;
  final Bookmarkable? item;
  final void Function()? onBack;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            thumbnail,
            fit: BoxFit.cover,
          ),
        ),
        const Positioned.fill(
            child: ColoredBox(
          color: Colors.black12,
        )),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SlideWidget(
                  child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Bangers',
                    fontSize: 25,
                  ),
                ),
              ))
            ],
          ),
        ),
        Positioned(
          left: 10,
          right: 10,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppBackButton(
                  onTap: onBack,
                ),
                if (item != null) BookMarkButton(bookmarkable: item!),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150);
}
