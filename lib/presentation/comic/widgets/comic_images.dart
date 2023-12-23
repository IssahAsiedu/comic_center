import 'dart:io';

import 'package:comics_center/domain/comic/comic_details.dart';
import 'package:comics_center/presentation/widgets/button/book_mark_button.dart';
import 'package:comics_center/presentation/widgets/filled_image_container.dart';
import 'package:comics_center/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class ComicImages extends StatefulWidget {
  final ComicDetails comicDetails;

  const ComicImages({
    Key? key,
    required this.comicDetails,
  }) : super(key: key);

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
            decoration: BoxDecoration(
              borderRadius: kCircularBorder4,
              border: Border.all(color: Colors.white12),
            ),
            child: Stack(
              children: [
                //filled image
                Positioned.fill(
                  child: FilledImageContainer(
                    imageUrl: selectedImage,
                  ),
                ),

                //bookmark button
                Positioned(
                  top: 10,
                  right: 20,
                  child: Row(
                    children: [
                      BookMarkButton(
                        bookmarkable: widget.comicDetails,
                      ),
                      const SizedBox(width: 10),
                      CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: PopupMenuButton(
                            color: Colors.orangeAccent,
                            itemBuilder: (_) {
                              return [
                                PopupMenuItem(
                                  onTap: _downloadImage,
                                  child: const Text(
                                    'Save Image',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ];
                            }),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        if (images.length > 1)
          SizedBox(
            height: 80,
            child: ListView.separated(
              itemCount: images.length,
              scrollDirection: Axis.horizontal,
              separatorBuilder: (_, i) => const SizedBox(width: 5),
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
                      borderRadius: kCircularBorder4,
                      border: _isSelected(images.elementAt(i))
                          ? Border.all(width: 4, color: Colors.white60)
                          : null,
                    ),
                    child: FilledImageContainer(
                      borderRadius: kCircularBorder4,
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

  void _downloadImage() async {
    Directory dir = await getExternalStorageDirectory() ??
        Directory('/storage/emulated/0/Download');

    var splits = selectedImage.split('/');
    splits = splits[splits.length - 1].split('.');
    final extension = splits[splits.length - 1];

    await FlutterDownloader.enqueue(
      url: selectedImage,
      savedDir: dir.path,
      showNotification: true,
      saveInPublicStorage: true,
      fileName: '${const Uuid().v4()}.$extension',
      openFileFromNotification: true,
    );
  }
}
