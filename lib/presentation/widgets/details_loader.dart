import 'package:comics_center/shared/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class DetailsLoader extends StatelessWidget {
  const DetailsLoader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Transform.scale(
      scale: 0.7,
      child: Lottie.asset(AppAssets.drStrangeLottieFile),
    ));
  }
}
