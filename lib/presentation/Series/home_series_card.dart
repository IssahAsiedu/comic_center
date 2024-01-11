import 'package:comics_center/domain/Series/series.dart';
import 'package:comics_center/presentation/widgets/button/book_mark_button.dart';
import 'package:flutter/material.dart';

class HomeSeriesCard extends StatelessWidget {
  const HomeSeriesCard({
    super.key,
    this.onTap,
    this.width,
    this.height,
    required this.series,
    this.margin,
  });

  final void Function()? onTap;
  final double? width;
  final double? height;
  final Series series;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            if (series.thumbnail == null)
              const Align(
                child: Icon(
                  Icons.not_interested,
                  size: 40,
                  color: Colors.orangeAccent,
                ),
              ),
            if (series.thumbnail != null)
              Stack(
                children: [
                  Container(
                    height: 60,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(series.thumbnail!),
                    )),
                  ),

                  //bookmark button
                  Transform.scale(
                    scale: 0.7,
                    child: BookmarkButton(bookmarkable: series),
                  )
                ],
              ),
            const SizedBox(height: 20),
            Text(
              series.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}
