import 'package:comics_center/domain/character/character_detail.dart';
import 'package:comics_center/infrastructure/network/rest_client.dart';
import 'package:comics_center/presentation/character/widgets/character_detail_body.dart';
import 'package:comics_center/presentation/widgets/details_loader.dart';
import 'package:comics_center/presentation/widgets/paged_error_indicator.dart';
import 'package:flutter/material.dart';

class CharacterDetailPage extends StatefulWidget {
  static const String route = "character";
  static const String idParam = "id";

  final String id;

  const CharacterDetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  CharacterDetails? characterDetails;
  bool error = false;

  @override
  void initState() {
    getCharacter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox.shrink();

    if (error) {
      child = PagedErrorIndicator(onTap: getCharacter);
    } else if (characterDetails == null) {
      child = const DetailsLoader();
    } else {
      child = CharacterDetailBody(characterDetails: characterDetails!);
    }

    return Material(
      color: Colors.black,
      child: child,
    );
  }

  Future<void> getCharacter() async {
    try {
      setState(() {
        characterDetails = null;
        error = false;
      });
      var response = await MarvelRestClient().getCharacterDetails(widget.id);
      setState(() => characterDetails = response.data!);
    } catch (e) {
      setState(() => error = true);
    }
  }
}
