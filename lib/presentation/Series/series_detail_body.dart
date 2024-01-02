import 'package:comics_center/domain/Series/series_details.dart';
import 'package:comics_center/presentation/character/widgets/character_detail_body.dart';
import 'package:comics_center/presentation/comic/widgets/description.dart';
import 'package:comics_center/presentation/widgets/back_button.dart';
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
  final _controller = ScrollController();
  bool appBarClosed = false;

  @override
  void initState() {
    _controller.addListener(() {
      var appBarClosed = _controller.hasClients && _controller.offset > 47;
      setState(() => this.appBarClosed = appBarClosed);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        //appbar
        SliverAppBar(
          leading: Transform.scale(
            scale: .8,
            child: AppBackButton(
              onTap: () => context.pop(widget.seriesDetails),
            ),
          ),
          flexibleSpace: ImageAppBar(
            thumbnail: widget.seriesDetails.thumbnail!,
            title: widget.seriesDetails.name,
            item: widget.seriesDetails,
            titleVisible: !appBarClosed,
          ),
          expandedHeight: 150,
          pinned: true,
        ),

        //description section
        if (widget.seriesDetails.description != null &&
            widget.seriesDetails.description!.isNotEmpty)
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 25, bottom: 25),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: DescriptionSection(
                title: "Description",
                content: widget.seriesDetails.description!,
              ),
            ),
          ),

        //spacer
        const SliverToBoxAdapter(child: SizedBox(height: 30)),

        //comics
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: DetailList(
              items: widget.seriesDetails.comics,
              title: "Comics",
              onTap: (e) {
                var route = AppRouteNotifier.generateComicRoute("${e.id}");
                context.push(route);
              },
            ),
          ),
        ),

        //spacer
        const SliverToBoxAdapter(child: SizedBox(height: 30))
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
