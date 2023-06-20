import 'package:flutter/material.dart';

import '../models/comic.dart';

class ComicCard extends StatelessWidget {
  final double cardHeight;
  final Comic comic;

  const ComicCard({Key? key, this.cardHeight = 90, required this.comic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: cardHeight,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
    );
  }
}
