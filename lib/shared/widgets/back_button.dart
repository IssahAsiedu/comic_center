import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: kOutlinedButtonCircleBackgroundStyle,
      onPressed: () => GoRouter.of(context).pop(),
      child: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
    );
  }
}