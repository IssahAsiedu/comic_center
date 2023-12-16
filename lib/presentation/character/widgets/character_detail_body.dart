import 'package:comics_center/domain/character/character_detail.dart';
import 'package:comics_center/presentation/shared/back_button.dart';
import 'package:comics_center/presentation/shared/detail_list.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:comics_center/presentation/shared/slide_widget.dart';

class CharacterDetailBody extends StatelessWidget {
  final CharacterDetails characterDetails;

  const CharacterDetailBody({
    Key? key,
    required this.characterDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _CharacterDetailAppBar(
        thumbnail: characterDetails.thumbnail!,
        characterName: characterDetails.name,
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
              GoRouter.of(context).pushReplacement(
                AppRoute.comicRouteWithParam("${e.id}"),
              );
            },
          ),
          DetailList(
            items: characterDetails.series,
            title: "Series",
          ),
        ],
      ),
    );
  }
}

class _CharacterDetailAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _CharacterDetailAppBar({
    required this.thumbnail,
    required this.characterName,
  });

  final String thumbnail;
  final String characterName;

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
                  characterName,
                  style: const TextStyle(
                    fontFamily: 'Bangers',
                    fontSize: 25,
                  ),
                ),
              ))
            ],
          ),
        ),
        const Positioned(
          top: 30,
          left: 10,
          child: AppBackButton(),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150);
}
