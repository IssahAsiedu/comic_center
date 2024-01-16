import 'package:comics_center/domain/comic/comic.dart';
import 'package:flutter/material.dart';

class ComicCard extends StatelessWidget {
  final double cardHeight;
  final Comic comic;
  final void Function()? onTap;
  final EdgeInsets? margin;

  const ComicCard({
    Key? key,
    this.cardHeight = 90,
    required this.comic,
    this.onTap,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: cardHeight,
        clipBehavior: Clip.antiAlias,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            Image.network(
              comic.thumbnail,
              width: MediaQuery.of(context).size.width * 0.3,
              fit: BoxFit.cover,
            ),
            Expanded(
              child: Container(
                color: Colors.black87,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        child: Text(
                          comic.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontFamily: 'Bangers'),
                        )),
                    Text(comic.format),
                    Text(comic.id.toString())
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
