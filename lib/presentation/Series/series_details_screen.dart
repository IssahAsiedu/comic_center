import 'package:comics_center/domain/Series/series_details.dart';
import 'package:comics_center/infrastructure/network/response.dart';
import 'package:comics_center/infrastructure/network/rest_client.dart';
import 'package:comics_center/presentation/Series/series_detail_body.dart';
import 'package:comics_center/providers/app_providers.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:comics_center/providers/auth/auth_state.dart';
import 'package:comics_center/shared/app_assets.dart';
import 'package:comics_center/shared/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';

class SeriesDetailPage extends ConsumerStatefulWidget {
  final String id;

  const SeriesDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState<SeriesDetailPage> createState() => _ComicDetailPageState();
}

class _ComicDetailPageState extends ConsumerState<SeriesDetailPage> {
  SeriesDetails? seriesDetails;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.pop(seriesDetails);
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white12,
        body: FutureBuilder<SeriesDetails>(
          future: getSeries(),
          builder: (_, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Transform.scale(
                  scale: 0.7,
                  child: Lottie.asset(AppAssets.drStrangeLottieFile),
                ),
              );
            }

            if (!snapshot.hasData) {
              return const Center(
                child: Text('No data was received'),
              );
            }

            if (snapshot.hasError) {
              return const Center(child: Text("An error occurred"));
            }

            return SeriesDetailBody(seriesDetails: snapshot.data!);
          },
        ),
      ),
    );
  }

  Future<SeriesDetails> getSeries() async {
    var response = await MarvelRestClient().getSeriesDetails(widget.id);

    final table =
        ref.read(supabaseClientProvider).from(AppStrings.bookmarksTable);
    final authState = ref.read(authProvider);

    if (response.status != Status.success) throw Error();

    if (authState is AuthSuccess) {
      List<dynamic>? result = await table
          .select()
          .eq("userid", authState.user.id)
          .eq('id', widget.id);

      if (result != null && result.isNotEmpty) response.data!.bookMarked = true;
    }

    seriesDetails = response.data;
    return response.data!;
  }
}
