import 'dart:async';

import 'package:comics_center/network/response.dart';
import 'package:comics_center/routing/route_config.dart';
import 'package:comics_center/shared/app_assets.dart';
import 'package:comics_center/shared/app_strings.dart';
import 'package:comics_center/shared/widgets/search_app_bar.dart';
import 'package:comics_center/shared/widgets/slide_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';

import 'character/models/character.dart';
import 'character/widgets/character_card.dart';
import 'comic/models/comic.dart';
import 'comic/widgets/comic_card.dart';
import 'network/rest_client.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final PagingController<int, Character> _characterPagingController =
      PagingController(firstPageKey: 0);
  final PagingController<int, Comic> _comicsPagingController =
      PagingController(firstPageKey: 0);
  final TextEditingController _textEditingController = TextEditingController();
  final RestClient _client = RestClient();
  Timer? timer;
  final int limit = 10;

  @override
  void initState() {
    _characterPagingController.addPageRequestListener((pageKey) {
      fetchCharacters(pageKey);
    });
    _comicsPagingController.addPageRequestListener((pageKey) {
      fetchComics(pageKey);
    });
    super.initState();
  }

  Future<void> fetchData() async {
    _characterPagingController.itemList?.clear();
    _characterPagingController.refresh();
    _comicsPagingController.itemList?.clear();
    _comicsPagingController.refresh();
  }

  Future<void> fetchCharacters(int pageKey) async {
    var query = <String, dynamic>{"offset": pageKey * limit, "limit": limit};
    if (_textEditingController.text.isNotEmpty) {
      query["nameStartsWith"] = _textEditingController.text;
    }
    var response = await _client.getCharacter(query);

    if (response.status == Status.error) {
      _characterPagingController.error = Error();
      return;
    }

    var pages = (response.data!.total / limit).ceil();

    if (pageKey == pages) {
      _characterPagingController.appendLastPage(response.data!.data);
      return;
    }

    _characterPagingController.appendPage(response.data!.data, ++pageKey);
  }

  Future<void> fetchComics(int pageKey) async {
    var query = <String, dynamic>{"offset": pageKey * limit, "limit": limit};

    if (_textEditingController.text.isNotEmpty) {
      query["titleStartsWith"] = _textEditingController.text;
    }
    var response = await _client.getComics(query);

    if (response.status == Status.error) {
      _comicsPagingController.error = Error();
      return;
    }
    var pages = (response.data!.total / limit).ceil();
    if (pageKey == pages) {
      _comicsPagingController.appendLastPage(response.data!.data);
      return;
    }
    _comicsPagingController.appendPage(response.data!.data, ++pageKey);
  }

  void searchTextChanged(String text) {
    timer?.cancel();
    if(text.isEmpty) {
      timer = Timer(const Duration(seconds: 2), () => fetchData());
    }
  }

  @override
  Widget build(BuildContext context) {
    var listHeight = MediaQuery.of(context).size.height * 0.6 - 190;

    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: SearchAppBar(
        textController: _textEditingController,
        onTextChange: searchTextChanged,
        onSubmit:  _onSubmitSearch,
      ),
      body: CustomScrollView(
        slivers: [
            SliverToBoxAdapter(
              child: SlideWidget(
                child: Container(
                  margin: const EdgeInsets.only(top: 20, bottom: 20, left: 10),
                  child:  Text(
                    AppStrings.charactersTitle,
                    style: const TextStyle(fontFamily: 'Bangers', fontSize: 24),
                  ),
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: listHeight,
              child: PagedListView<int, Character>.separated(
                pagingController: _characterPagingController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (context, index) => const SizedBox(
                  width: 20,
                ),
                builderDelegate: PagedChildBuilderDelegate(
                    animateTransitions: true,
                    firstPageProgressIndicatorBuilder: (_) =>  Lottie.asset(AppAssets.drStrangeLottieFile),
                    itemBuilder: (context, item, index) {
                      var itemWidth = MediaQuery.of(context).size.width * 0.8;
                      return GestureDetector(
                        onTap: () {
                          GoRouter.of(context).push(
                              AppRoute.characterRouteWithParam("${item.id}"));
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                              left: index == 0 ? 12 : 0,
                              right: _isLastItem(index) ? 12 : 0),
                          child: CharacterCard(
                            itemWidth: itemWidth,
                            itemHeight: listHeight,
                            thumbnailUrl: item.thumbnail!,
                            characterName: item.name,
                          ),
                        ),
                      );
                    }),
              ),
            ),
          ),
            SliverToBoxAdapter(
              child: Container(
                  margin: const EdgeInsets.only(top: 15, left: 15, bottom: 15),
                  child:  Text(
                    AppStrings.comicsTitle,
                    style: const TextStyle(fontFamily: 'Bangers', fontSize: 24),
                  )),
            ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - listHeight,
              child: PagedListView<int, Comic>.separated(
                  clipBehavior: Clip.antiAlias,
                  pagingController: _comicsPagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                      firstPageProgressIndicatorBuilder: (_) =>  Lottie.asset(AppAssets.drStrangeLottieFile),
                      itemBuilder: (context, item, index) {
                    return GestureDetector(
                        onTap: () {
                          GoRouter.of(context)
                              .push(AppRoute.comicRouteWithParam("${item.id}"));
                        },
                        child: ComicCard(comic: item));
                  }),
                  separatorBuilder: (_, i) {
                    return const SizedBox(
                      height: 10,
                    );
                  }),
            ),
          ),

        ],
      ),
    );
  }

  void _onSubmitSearch() {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if(!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
    if(_textEditingController.text.isEmpty) {
      return;
    }
    fetchData();
  }



  bool _isLastItem(int index) {
    return index == _characterPagingController.itemList!.length - 1;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _characterPagingController.dispose();
    _comicsPagingController.dispose();
    super.dispose();
  }
}
