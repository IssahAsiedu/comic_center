import 'package:comics_center/domain/story/story.dart';
import 'package:comics_center/infrastructure/network/response.dart';
import 'package:comics_center/infrastructure/network/rest_client.dart';
import 'package:comics_center/presentation/story/home_story_card.dart';
import 'package:comics_center/shared/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HomeAllStoriesSection extends StatefulWidget {
  const HomeAllStoriesSection({super.key});

  @override
  State<HomeAllStoriesSection> createState() => _HomeAllStoriesSectionState();
}

class _HomeAllStoriesSectionState extends State<HomeAllStoriesSection> {
  final PagingController<int, Story> _storyPagingController =
      PagingController(firstPageKey: 0);

  int limit = 10;

  @override
  void initState() {
    _storyPagingController.addPageRequestListener(fetchStories);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              const Icon(
                Icons.change_history_sharp,
                color: Colors.orangeAccent,
              ),
              const SizedBox(width: 20),
              Text(
                AppStrings.storiesTitle,
                style: const TextStyle(fontFamily: 'Bangers', fontSize: 24),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 170,
          child: PagedListView<int, Story>.separated(
            pagingController: _storyPagingController,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            separatorBuilder: (context, index) => const SizedBox(width: 20),
            builderDelegate: PagedChildBuilderDelegate(
                animateTransitions: true,
                itemBuilder: (
                  context,
                  item,
                  index,
                ) {
                  var itemWidth = MediaQuery.of(context).size.width * 0.4;

                  var margin = EdgeInsets.only(
                    left: index == 0 ? 24 : 0,
                    right: _isLastItem(index) ? 24 : 0,
                  );

                  return HomeStoryCard(
                    margin: margin,
                    story: item,
                    width: itemWidth,
                    onTap: () {
                      // GoRouter.of(context).push(
                      //   AppRoute.characterRouteWithParam("${item.id}"),
                      // );
                    },
                  );
                }),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }

  Future<void> fetchStories(int pageKey) async {
    var query = <String, dynamic>{"offset": pageKey * limit, "limit": limit};

    var response = await MarvelRestClient().getStories(query);

    if (response.status == Status.error) {
      _storyPagingController.error = Error();
      return;
    }

    var pages = (response.data!.total / limit).ceil();

    if (pageKey == pages && mounted) {
      _storyPagingController.appendLastPage(response.data!.data);
      return;
    }

    if (!mounted) return;
    _storyPagingController.appendPage(response.data!.data, ++pageKey);
  }

  bool _isLastItem(int index) {
    return index == _storyPagingController.itemList!.length - 1;
  }

  @override
  void dispose() {
    _storyPagingController.dispose();
    super.dispose();
  }
}
