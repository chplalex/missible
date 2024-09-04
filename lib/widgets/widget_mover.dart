import 'package:flutter/material.dart';

class WidgetMover extends StatefulWidget {
  final Widget child;
  final Offset offsetBegin;
  final Offset offsetEnd;

  const WidgetMover({
    super.key,
    required this.child,
    required this.offsetBegin,
    required this.offsetEnd,
  });

  @override
  State<WidgetMover> createState() => _WidgetMoverState();
}

class _WidgetMoverState extends State<WidgetMover> with TickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final animation = Tween<Offset>(
      begin: widget.offsetBegin,
      end: widget.offsetEnd,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller
      ..reset()
      ..forward();

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Positioned(
          left: animation.value.dx,
          top: animation.value.dy,
          child: widget.child,
        );
      },
    );
  }
}
