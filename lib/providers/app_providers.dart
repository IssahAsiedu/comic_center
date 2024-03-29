import 'dart:async';
import 'package:comics_center/domain/book_markable.dart';
import 'package:comics_center/exceptions.dart';
import 'package:comics_center/providers/auth/auth.dart';
import 'package:comics_center/providers/auth/auth_state.dart';
import 'package:comics_center/shared/app_strings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClientProvider = p.Provider((ref) => Supabase.instance.client);

final homeRefreshStreamProvider = p.Provider((ref) {
  final controller = StreamController<String>.broadcast();
  ref.onDispose(controller.close);
  return controller;
});
