import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          shape: const CircleBorder(), backgroundColor: Colors.white54),
      onPressed: () => GoRouter.of(context).pop(),
      child: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
    );
  }
}