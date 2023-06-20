import 'package:flutter/material.dart';

class DescriptionWidget extends StatelessWidget {
  final String description;

  const DescriptionWidget({Key? key, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (description.isEmpty) return Container();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      decoration: const BoxDecoration(
          border: Border.symmetric(vertical: BorderSide(color: Colors.white))),
      child: Text(
        description,
        style: const TextStyle(height: 2),
      ),
    );
  }
}
