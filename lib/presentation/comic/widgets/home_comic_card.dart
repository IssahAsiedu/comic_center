import 'package:comics_center/domain/comic/comic.dart';
import 'package:comics_center/presentation/widgets/button/book_mark_button.dart';
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
            border: Border.all(color: Colors.white12),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.network(
                  comic.thumbnail,
                  fit: BoxFit.cover,
                ),
              ),
              const Positioned.fill(
                child: ColoredBox(color: Colors.black12),
              ),
              SizedBox(
                width: width,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 35,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.black45,
                            borderRadius: BorderRadius.circular(3)),
                        child: Text(
                          comic.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2)),
                        child: Text(
                          '#${comic.id}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10)
                    ],
                  ),
                ),
              ),

              //book mark
              Positioned(
                top: 10,
                right: 10,
                child: Transform.scale(
                  scale: 0.8,
                  child: BookMarkButton(bookmarkable: comic),
                ),
              )
            ],
          )),
    );
  }
}
