import 'package:comics_center/domain/comic/comic_details.dart';
import 'package:comics_center/infrastructure/network/response.dart';
import 'package:comics_center/infrastructure/network/rest_client.dart';
import 'package:comics_center/presentation/comic/widgets/comic_detail_body.dart';
import 'package:comics_center/presentation/widgets/details_loader.dart';
import 'package:comics_center/presentation/widgets/paged_error_indicator.dart';
import 'package:comics_center/providers/app_providers.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:comics_center/providers/auth/auth_state.dart';
import 'package:comics_center/shared/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ComicDetailPage extends ConsumerStatefulWidget {
  final String id;

  const ComicDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  ConsumerState<ComicDetailPage> createState() => _ComicDetailPageState();
}

class _ComicDetailPageState extends ConsumerState<ComicDetailPage> {
  ComicDetails? comicDetails;
  bool error = false;

  @override
  void initState() {
    getComic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox.shrink();

    ref.listen(authProvider, (previous, next) {
      if (next is! AuthSuccess) return;
      getComic();
    });

    if (error) {
      child = PagedErrorIndicator(onTap: getComic);
    } else if (comicDetails == null) {
      child = const DetailsLoader();
    } else {
      child = ComicDetailBody(comicDetails: comicDetails!);
    }

    return WillPopScope(
      onWillPop: () async {
        context.pop(comicDetails);
        return true;
      },
      child: Material(color: Colors.white12, child: child),
    );
  }

  Future<void> getComic() async {
    try {
      setState(() {
        comicDetails = null;
        error = false;
      });
      var response = await MarvelRestClient().getComicDetails(widget.id);

      final table =
          ref.read(supabaseClientProvider).from(AppStrings.bookmarksTable);
      final authState = ref.read(authProvider);

      if (response.status != Status.success) throw Error();

      if (authState is AuthSuccess) {
        List<dynamic>? result = await table
            .select()
            .eq("userid", authState.user.id)
            .eq('id', widget.id);

        if (result != null && result.isNotEmpty) {
          response.data!.bookMarked = true;
        }
      }

      setState(() => comicDetails = response.data!);
    } catch (e) {
      setState(() => error = true);
    }
  }
}
