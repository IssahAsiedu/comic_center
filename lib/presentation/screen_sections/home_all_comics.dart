import 'package:comics_center/domain/comic/comic.dart';
import 'package:comics_center/infrastructure/network/response.dart';
import 'package:comics_center/infrastructure/network/rest_client.dart';
import 'package:comics_center/presentation/comic/widgets/home_comic_card.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:comics_center/shared/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeAllComicsSection extends StatefulWidget {
  const HomeAllComicsSection({super.key});

  @override
  State<HomeAllComicsSection> createState() => _HomeAllComicsSectionState();
}

class _HomeAllComicsSectionState extends State<HomeAllComicsSection> {
  final PagingController<int, Comic> _comicsPagingController =
      PagingController(firstPageKey: 0);

  int limit = 10;

  @override
  void initState() {
    _comicsPagingController.addPageRequestListener(fetchComics);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var listHeight = MediaQuery.of(context).size.height * 0.3;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              const Icon(
                Icons.ac_unit_outlined,
                color: Colors.orangeAccent,
              ),
              const SizedBox(width: 20),
              Text(
                AppStrings.comicsTitle,
                style: const TextStyle(fontFamily: 'Bangers', fontSize: 24),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: listHeight,
          child: PagedListView<int, Comic>.separated(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.antiAlias,
              pagingController: _comicsPagingController,
              builderDelegate: PagedChildBuilderDelegate(itemBuilder: (
                context,
                item,
                index,
              ) {
                var itemWidth = MediaQuery.of(context).size.width * 0.4;

                var margin = EdgeInsets.only(
                  left: index == 0 ? 24 : 0,
                  right: _isLastItem(index) ? 24 : 0,
                );

                return HomeComicCard(
                  margin: margin,
                  comic: item,
                  width: itemWidth,
                  height: listHeight,
                  onTap: () {
                    var route =
                        AppRouteNotifier.comicRouteWithParam("${item.id}");
                    GoRouter.of(context).push(route);
                  },
                );
              }),
              separatorBuilder: (_, i) {
                return const SizedBox(width: 20);
              }),
        )
      ],
    );
  }

  Future<void> fetchComics(int pageKey) async {
    var query = <String, dynamic>{"offset": pageKey * limit, "limit": limit};

    var response = await MarvelRestClient().getComics(query);

    if (response.status == Status.error) {
      _comicsPagingController.error = Error();
      return;
    }

    var pages = (response.data!.total / limit).ceil();
    if (pageKey == pages && mounted) {
      _comicsPagingController.appendLastPage(response.data!.data);
      return;
    }

    if (!mounted) return;
    _comicsPagingController.appendPage(response.data!.data, ++pageKey);
  }

  bool _isLastItem(int index) {
    return index == _comicsPagingController.itemList!.length - 1;
  }

  @override
  void dispose() {
    _comicsPagingController.dispose();
    super.dispose();
  }
}
