import 'package:flutter/material.dart';

class DescriptionSection extends StatelessWidget {
  final String title;
  final String content;

  const DescriptionSection({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: const TextStyle(fontFamily: "Bangers", fontSize: 18),),
        const SizedBox(height: 15,),
        Text(content, style: const TextStyle(height: 1.5),)
      ],
    );
  }
}