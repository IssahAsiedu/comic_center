import 'package:comics_center/comic/models/comic_details.dart';
import 'package:comics_center/comic/widgets/prices_section.dart';
import 'package:flutter/material.dart';

import '../../shared/widgets/back_button.dart';
import '../../shared/widgets/slide_widget.dart';
import 'comic_images.dart';
import 'description.dart';

class ComicDetailBody extends StatelessWidget {
  final ComicDetails comicDetails;

  const ComicDetailBody({Key? key, required this.comicDetails})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned(top: 30, left: 10, child: AppBackButton()),
        Positioned.fill(
            top: 110,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    SlideWidget(
                        child: ComicImages(
                      comicDetails: comicDetails,
                    )),
                    Container(
                      margin: const EdgeInsets.only(top: 15),
                      child: Text("PAGE COUNT: ${comicDetails.pageCount}"),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                        child: PricesSection(prices: comicDetails.prices,)),
                    if (comicDetails.description != null && comicDetails.description!.isNotEmpty)
                      Container(
                        margin: const EdgeInsets.only(top: 25),
                        child: DescriptionSection(
                          title: "Description",
                          content: comicDetails.description!,
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
                comicDetails.name,
                style: const TextStyle(fontFamily: 'Bangers', fontSize: 25),
              )),
        ),
      ],
    );
  }
}