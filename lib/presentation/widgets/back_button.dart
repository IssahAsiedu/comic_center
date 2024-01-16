import 'package:comics_center/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBackButton extends StatelessWidget {
  const AppBackButton({super.key, this.onTap});

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: kOutlinedButtonCircleBackgroundStyle,
      onPressed: () {
        if (onTap != null) {
          onTap!.call();
          return;
        }
        context.pop();
      },
      child: const Icon(
        Icons.arrow_back,
        color: Colors.white,
      ),
    );
  }
}
