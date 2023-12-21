import 'package:comics_center/domain/Series/series_details.dart';
import 'package:comics_center/presentation/character/widgets/character_detail_body.dart';
import 'package:comics_center/presentation/comic/widgets/description.dart';
import 'package:comics_center/presentation/widgets/detail_list.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SeriesDetailBody extends StatefulWidget {
  const SeriesDetailBody({super.key, required this.seriesDetails});

  final SeriesDetails seriesDetails;

  @override
  State<SeriesDetailBody> createState() => _SeriesDetailBodyState();
}

class _SeriesDetailBodyState extends State<SeriesDetailBody> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: ImageAppBar(
        thumbnail: widget.seriesDetails.thumbnail!,
        title: widget.seriesDetails.name,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        children: [
          if (widget.seriesDetails.description != null &&
              widget.seriesDetails.description!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 25, bottom: 25),
              child: DescriptionSection(
                title: "Description",
                content: widget.seriesDetails.description!,
              ),
            ),

          // comics list
          DetailList(
            items: widget.seriesDetails.comics,
            title: "Comics",
            onTap: (e) {
              var route = AppRouteNotifier.generateComicRoute("${e.id}");
              context.push(route);
            },
          )
        ],
      ),
    );
  }
}
