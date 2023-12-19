import 'package:comics_center/domain/comic/comic_details.dart';
import 'package:comics_center/presentation/widgets/filled_image_container.dart';
import 'package:comics_center/providers/app_providers.dart';
import 'package:comics_center/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
          onTap: _onSelectedImage,
          child: Container(
            height: size.height * 0.45,
            width: size.width,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(borderRadius: kCircularBorder12),
            child: Stack(
              children: [
                Positioned.fill(
                  child: FilledImageContainer(
                    imageUrl: selectedImage,
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 5,
                  child: DownloadButton(
                    selectedImage: selectedImage,
                  ),
                )
              ],
            ),
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
                    decoration: BoxDecoration(
                      borderRadius: kCircularBorder12,
                      border: _isSelected(images.elementAt(i))
                          ? Border.all(width: 2, color: Colors.blue)
                          : null,
                    ),
                    child: FilledImageContainer(
                      borderRadius: kCircularBorder12,
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

  bool _isSelected(String image) {
    return selectedImage == image;
  }

  void _onSelectedImage() {
    showDialog(
        context: context,
        builder: (_) {
          return InteractiveViewer(
              child: FilledImageContainer(imageUrl: selectedImage));
        });
  }
}

class DownloadButton extends ConsumerWidget {
  const DownloadButton({
    super.key,
    required this.selectedImage,
  });

  final String selectedImage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var downloader = ref.watch(downloaderProvider);

    double value = downloader[selectedImage] ?? 0;

    return CircleAvatar(
      backgroundColor: Colors.black,
      radius: 30,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                value: value.toDouble(),
              )),
          IconButton(
            iconSize: 30,
            color: Colors.white,
            icon: const Icon(
              Icons.download,
            ),
            onPressed: () {
              ref
                  .read(downloaderProvider.notifier)
                  .downloadOnAndroid(selectedImage);
            },
          ),
        ],
      ),
    );
  }
}
