import 'package:flutter/material.dart';

class CharacterCard extends StatelessWidget {
  final double itemWidth;
  final double itemHeight;
  final String thumbnailUrl;
  final String characterName;
  final void Function()? onTap;
  final EdgeInsets? margin;

  const CharacterCard({
    Key? key,
    required this.itemWidth,
    required this.thumbnailUrl,
    required this.characterName,
    required this.itemHeight,
    this.onTap,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('name: $characterName,, url: $thumbnailUrl');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        width: itemWidth,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          border: Border.all(color: Colors.white12),
        ),
        child: Stack(
          children: [
            Positioned.fill(
                child: Image.network(
              thumbnailUrl,
              fit: BoxFit.cover,
            )),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(5),
                height: itemHeight * 0.3,
                decoration: const BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Center(
                    child: Text(
                  characterName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: "Bangers", fontSize: 16),
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class CharacterDetailBottomFade extends StatelessWidget {
  const CharacterDetailBottomFade({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.3,
      width: size.width,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.transparent, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              tileMode: TileMode.clamp)),
    );
  }
}
