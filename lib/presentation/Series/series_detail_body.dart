import 'package:comics_center/domain/Series/series_details.dart';
import 'package:comics_center/domain/comic/comic_details.dart';
import 'package:flutter/material.dart';

class SeriesDetailBody extends StatefulWidget {
  const SeriesDetailBody({super.key, required this.seriesDetails});

  final SeriesDetails seriesDetails;

  @override
  State<SeriesDetailBody> createState() => _SeriesDetailBodyState();
}

class _SeriesDetailBodyState extends State<SeriesDetailBody> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
