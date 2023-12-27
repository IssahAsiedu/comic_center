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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Image.network(
                thumbnailUrl,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              height: itemHeight * 0.3,
              decoration: const BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.only(),
              ),
              child: Center(
                  child: Text(
                characterName,
                textAlign: TextAlign.center,
                style: const TextStyle(fontFamily: "Bangers", fontSize: 16),
              )),
            )
          ],
        ),
      ),
    );
  }
}
