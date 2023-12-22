import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorDialog extends PopupRoute<void> {
  ErrorDialog({this.message});

  final String? message;

  @override
  Color? get barrierColor => Colors.black12;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Error';

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return UnconstrainedBox(
      child: Material(
        color: Colors.redAccent,
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 30,
                width: 30,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.error,
                  color: Colors.white,
                ),
              ),
              Container(
                width: 120,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(message ?? 'Error'),
              ),
              InkWell(
                onTap: context.pop,
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Duration get transitionDuration => Duration.zero;
}
