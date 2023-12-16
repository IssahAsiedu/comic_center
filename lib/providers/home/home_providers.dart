import 'package:flutter_riverpod/flutter_riverpod.dart';

final homeViewProvider = StateProvider<int>((ref) {
  return 0;
});

final homeScrollingProvider = StateProvider<bool>((ref) {
  return false;
});
