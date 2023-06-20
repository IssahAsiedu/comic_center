import 'package:flutter/material.dart';


class FilledImageContainer extends StatelessWidget {
  final String imageUrl;

  const FilledImageContainer({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.fill)),
    );
  }
}
