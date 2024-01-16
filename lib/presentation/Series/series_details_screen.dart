import 'package:comics_center/domain/Series/series_details.dart';
import 'package:comics_center/infrastructure/network/rest_client.dart';
import 'package:comics_center/presentation/Series/series_detail_body.dart';
import 'package:comics_center/presentation/widgets/details_loader.dart';
import 'package:comics_center/presentation/widgets/paged_error_indicator.dart';
import 'package:comics_center/providers/app_providers.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:comics_center/providers/auth/auth_state.dart';
import 'package:comics_center/shared/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SeriesDetailPage extends ConsumerStatefulWidget {
  final String id;

  const SeriesDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState<SeriesDetailPage> createState() => _ComicDetailPageState();
}

class _ComicDetailPageState extends ConsumerState<SeriesDetailPage> {
  SeriesDetails? seriesDetails;
  bool error = false;

  @override
  void initState() {
    getSeries();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox.shrink();

    ref.listen(authProvider, (previous, next) {
      if (next is! AuthSuccess) return;
      getSeries();
    });

    if (error) {
      child = PagedErrorIndicator(onTap: getSeries);
    } else if (seriesDetails == null) {
      child = const DetailsLoader();
    } else {
      child = SeriesDetailBody(seriesDetails: seriesDetails!);
    }

    return WillPopScope(
      onWillPop: () async {
        context.pop(seriesDetails);
        return true;
      },
      child: Material(
        color: Colors.black,
        child: child,
      ),
    );
  }

  Future<void> getSeries() async {
    try {
      setState(() {
        seriesDetails = null;
        error = false;
      });

      var response = await MarvelRestClient().getSeriesDetails(widget.id);
      final table =
          ref.read(supabaseClientProvider).from(AppStrings.bookmarksTable);
      final authState = ref.read(authProvider);

      if (authState is AuthSuccess) {
        List<dynamic>? result = await table
            .select()
            .eq("userid", authState.user.id)
            .eq('id', widget.id);

        if (result != null && result.isNotEmpty) {
          response.data!.bookMarked = true;
        }
      }

      setState(() => seriesDetails = response.data);
    } catch (e) {
      setState(() => error = true);
    }
  }
}
