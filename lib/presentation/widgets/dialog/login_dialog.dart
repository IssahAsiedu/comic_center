import 'package:comics_center/presentation/widgets/button/google_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginDialog extends PopupRoute<void> {
  LoginDialog(this.onTap);

  final void Function()? onTap;

  @override
  Color? get barrierColor => Colors.black87;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return UnconstrainedBox(
      child: Material(
        borderRadius: BorderRadius.circular(4),
        elevation: 2,
        color: Colors.redAccent.withOpacity(0.6),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: context.pop,
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 5,
                color: Colors.black,
              ),
              const Icon(
                Icons.error,
                color: Colors.white,
                size: 35,
              ),
              const SizedBox(height: 20),
              const SizedBox(
                width: 150,
                child: Text(
                  'You are not login, login to continue',
                  style: TextStyle(),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              GoogleButton(onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Duration get transitionDuration => Duration.zero;
}
