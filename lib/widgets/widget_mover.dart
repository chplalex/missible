import 'package:flutter/material.dart';
import 'package:missible/common/app_typedefs.dart';

class WidgetMover extends StatefulWidget {
  final Widget child;
  final PositionedData startPosition;
  final PositionedData endPosition;
  final Duration duration;

  const WidgetMover({
    super.key,
    required this.child,
    required this.startPosition,
    required this.endPosition,
    this.duration = const Duration(seconds: 1),
  });

  @override
  State<WidgetMover> createState() => _WidgetMoverState();
}

class _WidgetMoverState extends State<WidgetMover> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<PositionedData> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<PositionedData>(
      begin: widget.startPosition,
      end: widget.endPosition,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Positioned(
          top: _animation.value.top,
          left: _animation.value.left,
          bottom: _animation.value.bottom,
          right: _animation.value.right,
          child: widget.child,
        );
      },
    );
  }
}