import 'package:comics_center/presentation/screen_sections/home_all_characters.dart';
import 'package:comics_center/presentation/screen_sections/home_all_comics.dart';
import 'package:flutter/material.dart';

class HomeAllScreen extends StatelessWidget {
  const HomeAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [
        SizedBox(height: 120),
        HomeAllCharactersSection(),
        SizedBox(height: 20),
        HomeAllComicsSection()
      ],
    );
  }
}