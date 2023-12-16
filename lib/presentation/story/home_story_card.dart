import 'package:comics_center/domain/story/story.dart';
import 'package:flutter/material.dart';

class HomeStoryCard extends StatelessWidget {
  const HomeStoryCard({
    super.key,
    this.onTap,
    this.width,
    this.height,
    required this.story,
    this.margin,
  });

  final void Function()? onTap;
  final double? width;
  final double? height;
  final Story story;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: width,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (story.thumbnail == null)
            const Align(
              child: Icon(
                Icons.not_interested,
                size: 40,
                color: Colors.orangeAccent,
              ),
            ),
          if (story.thumbnail != null)
            Container(
              height: 60,
              decoration: BoxDecoration(
                  image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(story.thumbnail!),
              )),
            ),
          const SizedBox(height: 20),
          Text(
            '${story.type}',
            style: const TextStyle(decoration: TextDecoration.underline),
          ),
          const SizedBox(height: 5),
          SizedBox(
            height: 60,
            child: Text(
              story.name,
              overflow: TextOverflow.fade,
            ),
          ),
        ],
      ),
    );
  }
}
