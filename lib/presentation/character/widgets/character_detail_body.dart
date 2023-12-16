import 'package:comics_center/domain/character/character_detail.dart';
import 'package:comics_center/presentation/character/widgets/character_description.dart';
import 'package:comics_center/presentation/shared/back_button.dart';
import 'package:comics_center/presentation/shared/detail_list.dart';
import 'package:comics_center/presentation/shared/filled_image_container.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:comics_center/presentation/shared/slide_widget.dart';

class CharacterDetailBody extends StatelessWidget {
  final CharacterDetails characterDetails;

  const CharacterDetailBody({Key? key, required this.characterDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          FilledImageContainer(imageUrl: characterDetails.thumbnail!),
          Container(
            color: Colors.black54,
          ),
          const Positioned(bottom: 0, child: _CharacterDetailBottomFade()),
          const Positioned(top: 30, left: 10, child: AppBackButton()),
          Positioned.fill(
            top: 110,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SlideWidget(
                        child: Text(
                      characterDetails.name,
                      style:
                          const TextStyle(fontFamily: 'Bangers', fontSize: 25),
                    )),
                    const SizedBox(
                      height: 29,
                    ),
                    SlideWidget(
                      offset: const Offset(-10.0, 0),
                      child: DescriptionWidget(
                          description: characterDetails.description),
                    ),
                    const SizedBox(
                      height: 39,
                    ),
                    SlideWidget(
                      child: DetailList(
                        items: characterDetails.comics,
                        title: "Comics",
                        onTap: (e) {
                          GoRouter.of(context).pushReplacement(
                              AppRoute.comicRouteWithParam("${e.id}"));
                        },
                      ),
                    ),
                    SlideWidget(
                      child: DetailList(
                        items: characterDetails.series,
                        title: "Series",
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _CharacterDetailBottomFade extends StatelessWidget {
  const _CharacterDetailBottomFade();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.5,
      width: size.width,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            tileMode: TileMode.clamp),
      ),
    );
  }
}
