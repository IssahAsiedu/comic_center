import 'package:comics_center/comic/widgets/comic_detail_body.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../network/response.dart';
import '../../network/rest_client.dart';
import '../../shared/app_assets.dart';
import '../models/comic_details.dart';

class ComicDetailPage extends StatelessWidget {
  final String id;

  const ComicDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white12,
      body: FutureBuilder<ApiResponse<ComicDetails>>(
        future: RestClient().getComicDetails(id),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(
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

          return ComicDetailBody(comicDetails: snapshot.data!.data!);
        },
      ),
    );
  }
}
