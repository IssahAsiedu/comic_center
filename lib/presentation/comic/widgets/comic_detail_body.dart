import 'package:comics_center/domain/comic/comic_details.dart';
import 'package:comics_center/presentation/comic/widgets/prices_section.dart';
import 'package:comics_center/presentation/widgets/back_button.dart';
import 'package:comics_center/presentation/widgets/dialog/error_dialog.dart';
import 'package:comics_center/presentation/widgets/slide_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'comic_images.dart';
import 'description.dart';

class ComicDetailBody extends StatefulWidget {
  final ComicDetails comicDetails;

  const ComicDetailBody({
    Key? key,
    required this.comicDetails,
  }) : super(key: key);

  @override
  State<ComicDetailBody> createState() => _ComicDetailBodyState();
}

class _ComicDetailBodyState extends State<ComicDetailBody> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Positioned(
            top: 30,
            left: 10,
            child: AppBackButton(
              onTap: () {
                context.pop(widget.comicDetails);
              },
            ),
          ),
          Positioned.fill(
              top: 110,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      SlideWidget(
                        child: ComicImages(comicDetails: widget.comicDetails),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Text("Page Count: ${widget.comicDetails.pageCount}"),
                          const SizedBox(width: 20),

                          //link
                          if (widget.comicDetails.resourceURI != null)
                            InkWell(
                              onTap: () async {
                                final uri =
                                    Uri.parse(widget.comicDetails.resourceURI!);

                                if (!await launchUrl(uri)) {
                                  if (!mounted) return;
                                  await Navigator.of(context).push(
                                    ErrorDialog(message: "Could not open link"),
                                  );
                                }
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(Icons.link, color: Colors.blueAccent),
                                  SizedBox(width: 5),
                                  Text('Details'),
                                ],
                              ),
                            )
                        ],
                      ),
                      Container(
                          margin: const EdgeInsets.only(top: 12),
                          child: PricesSection(
                            prices: widget.comicDetails.prices,
                          )),
                      if (widget.comicDetails.description != null &&
                          widget.comicDetails.description!.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 25),
                          child: DescriptionSection(
                            title: "Description",
                            content: widget.comicDetails.description!,
                          ),
                        )
                    ],
                  ),
                ),
              )),
          Positioned(
            top: 40,
            left: 80,
            right: 0,
            child: SlideWidget(
                child: Text(
              widget.comicDetails.name,
              style: const TextStyle(fontFamily: 'Bangers', fontSize: 25),
            )),
          ),
        ],
      ),
    );
  }
}
