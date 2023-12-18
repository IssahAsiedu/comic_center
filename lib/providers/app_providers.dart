import 'package:comics_center/infrastructure/download/downloader.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

final downloaderProvider =
    p.NotifierProvider<Downloader, Map<String, double>>(Downloader.new);

final supabaseClientProvider = p.Provider((ref) => Supabase.instance.client);
