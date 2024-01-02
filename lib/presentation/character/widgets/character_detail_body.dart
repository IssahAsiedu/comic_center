import 'package:comics_center/domain/book_markable.dart';
import 'package:comics_center/domain/character/character_detail.dart';
import 'package:comics_center/presentation/widgets/back_button.dart';
import 'package:comics_center/presentation/widgets/button/book_mark_button.dart';
import 'package:comics_center/presentation/widgets/detail_list.dart';
import 'package:comics_center/presentation/widgets/slide_widget.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CharacterDetailBody extends StatefulWidget {
  final CharacterDetails characterDetails;

  const CharacterDetailBody({
    Key? key,
    required this.characterDetails,
  }) : super(key: key);

  @override
  State<CharacterDetailBody> createState() => _CharacterDetailBodyState();
}

class _CharacterDetailBodyState extends State<CharacterDetailBody> {
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
        SliverAppBar(
          leading: Transform.scale(
            scale: .8,
            child: const AppBackButton(),
          ),
          flexibleSpace: ImageAppBar(
            thumbnail: widget.characterDetails.thumbnail!,
            title: widget.characterDetails.name,
            titleVisible: !appBarClosed,
          ),
          pinned: true,
          stretch: true,
          expandedHeight: 155,
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(widget.characterDetails.description)),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: DetailList(
              items: widget.characterDetails.comics,
              title: "Comics",
              onTap: (e) {
                var route = AppRouteNotifier.generateComicRoute("${e.id}");
                context.push(route);
              },
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: DetailList(
              items: widget.characterDetails.series,
              title: "Series",
              onTap: (e) {
                var route = AppRouteNotifier.generateSeriesRoute("${e.id}");
                context.push(route);
              },
            ),
          ),
        ),
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

class ImageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ImageAppBar({
    super.key,
    required this.thumbnail,
    required this.title,
    this.item,
    this.onBack,
    this.titleVisible = true,
  });

  final String thumbnail;
  final String title;
  final bool titleVisible;
  final Bookmarkable? item;
  final void Function()? onBack;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.network(
            thumbnail,
            fit: BoxFit.cover,
          ),
        ),
        const Positioned.fill(
            child: ColoredBox(
          color: Colors.black12,
        )),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Visibility(
                visible: titleVisible,
                child: SlideWidget(
                    child: Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Bangers',
                      fontSize: 25,
                    ),
                  ),
                )),
              )
            ],
          ),
        ),
        Positioned(
          left: 10,
          right: 10,
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // AppBackButton(
                //   onTap: onBack,
                // ),
                if (item != null) BookMarkButton(bookmarkable: item!),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(150);
}
