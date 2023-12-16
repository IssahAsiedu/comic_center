import 'package:comics_center/domain/comic/comic.dart';
import 'package:flutter/material.dart';

class HomeComicCard extends StatelessWidget {
  const HomeComicCard({
    super.key,
    required this.comic,
    this.margin,
    this.onTap,
    this.width,
    this.height,
  });

  final double? width;
  final double? height;
  final Comic comic;
  final EdgeInsets? margin;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: margin,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  comic.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
              const ColoredBox(color: Colors.black12),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    comic.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  Text(
                    '#${comic.issueNumber}',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
