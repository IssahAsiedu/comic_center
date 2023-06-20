import 'package:flutter/material.dart';

class FilledImageContainer extends StatelessWidget {
  final String imageUrl;
  final BorderRadius? borderRadius;

  const FilledImageContainer({Key? key, required this.imageUrl, this.borderRadius}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
          image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.fill)),
    );
  }
}
