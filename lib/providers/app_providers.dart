import 'package:comics_center/infrastructure/download/downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final downloaderProvider =
    NotifierProvider<Downloader, Map<String, double>>(Downloader.new);


final subabaseClientProvider = Provider((ref) => Supaba)