import 'dart:async';

import 'package:comics_center/response.dart';
import 'package:comics_center/rest_client.dart';
import 'package:comics_center/search_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'character.dart';
import 'character_card.dart';
import 'comic.dart';
import 'comic_card.dart';

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
    timer = Timer(const Duration(seconds: 5), () => fetchData());
  }

  @override
  Widget build(BuildContext context) {
    var listHeight = MediaQuery.of(context).size.height * 0.6 - 190;
    return Scaffold(
      backgroundColor: Colors.white12,
      appBar: SearchAppBar(
        textController: _textEditingController,
        onTextChange: searchTextChanged,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.only(top: 20, bottom: 20, left: 10),
              child: const Text(
                "Characters",
                style: TextStyle(fontFamily: 'Bangers', fontSize: 24),
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
                    itemBuilder: (context, item, index) {
                      var itemWidth = MediaQuery.of(context).size.width * 0.8;
                      return Container(
                        margin: EdgeInsets.only(
                            left: index == 0 ? 12 : 0,
                            right: _isLastItem(index) ? 12 : 0),
                        child: CharacterCard(
                          itemWidth: itemWidth,
                          itemHeight: listHeight,
                          thumbnailUrl: item.thumbnail!,
                          characterName: item.name,
                        ),
                      );
                    }),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
                margin: const EdgeInsets.only(top: 15, left: 15, bottom: 15),
                child: const Text(
                  'Comics',
                  style: TextStyle(fontFamily: 'Bangers', fontSize: 24),
                )),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - listHeight,
              child: PagedListView<int, Comic>.separated(
                  clipBehavior: Clip.antiAlias,
                  pagingController: _comicsPagingController,
                  builderDelegate: PagedChildBuilderDelegate(
                      itemBuilder: (context, item, index) {
                    return ComicCard(comic: item);
                  }),
                  separatorBuilder: (_, i) {
                    return const SizedBox(
                      height: 10,
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }

  bool _isLastItem(int index) {
    return index == _characterPagingController.itemList!.length - 1;
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
