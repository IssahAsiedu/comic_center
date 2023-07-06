import 'package:comics_center/character/widgets/character_detail_body.dart';
import 'package:comics_center/network/response.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../network/rest_client.dart';
import '../../shared/app_assets.dart';
import '../models/character_detail.dart';

class CharacterDetailPage extends StatefulWidget {
  static const String route = "character";
  static const String idParam = "id";
  final String id;

  const CharacterDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: FutureBuilder<ApiResponse<CharacterDetails>> (
        future: RestClient().getCharacterDetails(widget.id),
        builder: (_, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: Lottie.asset(AppAssets.drStrangeLottieFile),);
            }

            if(!snapshot.hasData) {
              return const Center(child: Text('No data was received'),);
            }

            if(snapshot.hasError || snapshot.data!.status == Status.error) {
              return const Center(child: Text("An error occurred"));
            }

            return CharacterDetailBody(characterDetails: snapshot.data!.data!);
        },
      ),
    );
  }
}