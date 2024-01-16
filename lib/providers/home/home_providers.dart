import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePageState {
  const HomePageState({
    this.previous = 0,
    this.current = 0,
  });

  final int previous;
  final int current;
}

final homeViewProvider = StateProvider<HomePageState>((ref) {
  return const HomePageState();
});

final homeScrollingProvider = StateProvider<bool>((ref) {
  return false;
});
