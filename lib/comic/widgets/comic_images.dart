import 'package:comics_center/comic/models/comic_details.dart';
import 'package:comics_center/shared/widgets/filled_image_container.dart';
import 'package:flutter/material.dart';

import '../../shared/utils.dart';

class ComicImages extends StatefulWidget {
  final ComicDetails comicDetails;

  const ComicImages({Key? key, required this.comicDetails}) : super(key: key);

  @override
  State<ComicImages> createState() => _ComicImagesState();
}

class _ComicImagesState extends State<ComicImages> {
  Set<String> images = {};
  late String selectedImage;

  @override
  void initState() {
    images.addAll(widget.comicDetails.images);
    images.add(widget.comicDetails.thumbnail);
    selectedImage = widget.comicDetails.thumbnail;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onSelectedImage,
          child: Container(
            height: size.height * 0.45,
            width: size.width,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: kCircularBorder12),
            child: FilledImageContainer(imageUrl: selectedImage),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        if (images.length > 1)
          SizedBox(
            height: 80,
            child: ListView.separated(
              itemCount: images.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, i) => const SizedBox(
                width: 5,
              ),
              itemBuilder: (_, i) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedImage = images.elementAt(i);
                    });
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(borderRadius: kCircularBorder12),
                    child: FilledImageContainer(
                      imageUrl: images.elementAt(i),
                    ),
                  ),
                );
              },
            ),
          )
      ],
    );
  }

  void onSelectedImage() {
    showDialog(context: context, builder: (_) {
      return InteractiveViewer(
        constrained: false,
          child: FilledImageContainer(imageUrl: selectedImage));
    });
  }
}
