import 'package:flutter/material.dart';

class CharacterCard extends StatelessWidget {
  final double itemWidth;
  final double itemHeight;
  final String thumbnailUrl;
  final String characterName;

  const CharacterCard({
    Key? key,
    required this.itemWidth,
    required this.thumbnailUrl,
    required this.characterName,
    required this.itemHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: itemWidth,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(19)),
      child: Stack(
        children: [
          Positioned.fill(
              child: Image.network(
            thumbnailUrl,
            fit: BoxFit.cover,
          )),
          Positioned(
              top: itemHeight * 0.7,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
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
                  style: const TextStyle(fontFamily: "Bangers", fontSize: 24),
                )),
              ))
        ],
      ),
    );
  }
}
