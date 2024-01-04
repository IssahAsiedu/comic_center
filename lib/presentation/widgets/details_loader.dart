import 'package:flutter/material.dart';

class DetailsLoader extends StatelessWidget {
  const DetailsLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.scale(
        scale: 0.7,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
