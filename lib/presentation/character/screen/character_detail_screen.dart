import 'package:comics_center/domain/character/character_detail.dart';
import 'package:comics_center/infrastructure/network/response.dart';
import 'package:comics_center/infrastructure/network/rest_client.dart';
import 'package:comics_center/presentation/character/widgets/character_detail_body.dart';
import 'package:comics_center/shared/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CharacterDetailPage extends StatelessWidget {
  static const String route = "character";
  static const String idParam = "id";

  final String id;

  const CharacterDetailPage({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ApiResponse<CharacterDetails>>(
        future: MarvelRestClient().getCharacterDetails(id),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Lottie.asset(AppAssets.drStrangeLottieFile),
            );
          }

          if (!snapshot.hasData) {
            return const Center(
              child: Text('No data was received'),
            );
          }

          if (snapshot.hasError || snapshot.data!.status == Status.error) {
            return const Center(child: Text("An error occurred"));
          }

          return CharacterDetailBody(characterDetails: snapshot.data!.data!);
        },
      ),
    );
  }
}
