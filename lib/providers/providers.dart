import 'package:comics_center/download/downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final downloaderProvider = ChangeNotifierProvider((ref) => Downloader());
