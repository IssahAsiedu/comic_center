import 'package:flutter/material.dart';

class SlideWidget extends StatefulWidget {
  final Widget child;
  final Offset offset;

  const SlideWidget(
      {Key? key, required this.child, this.offset = const Offset(10.5, 0.0)})
      : super(key: key);

  @override
  State<SlideWidget> createState() => _SlideWidgetState();
}

class _SlideWidgetState extends State<SlideWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
  AnimationController(vsync: this, duration: const Duration(seconds: 1));
  late final Animation<Offset> _offsetAnimation =
  Tween<Offset>(begin: widget.offset, end: Offset.zero)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.child,
    );
  }

  @override
  void initState() {
    super.initState();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}