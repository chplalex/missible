import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:missible/common/app_constants.dart';
import 'package:missible/data/coord_model.dart';
import 'package:missible/widgets/square_grid.dart';
import 'package:missible/widgets/widget_mover.dart';

import 'animated_circle.dart';

class MapWidget extends StatefulWidget {
  final Queue<CoordModel> coords;

  const MapWidget({super.key, required this.coords});

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> with SingleTickerProviderStateMixin {
  static const _strokeSize = 1.0;

  var _cellSize = 0.0;
  var _gridSize = 0.0;

  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      _gridSize = min(constraints.maxWidth, constraints.maxHeight);
      _cellSize = (_gridSize - (AppConstants.gridDimension + 1) * _strokeSize) / AppConstants.gridDimension;

      return Stack(
        children: [
          SquareGrid(gridDimension: AppConstants.gridDimension, gridSize: _gridSize),
          _circle(),
        ],
      );
    });
  }

  Widget _circle() {
    switch (widget.coords.length) {
      case 0:
        return const SizedBox.shrink();
      case 1:
        final offset = _offset(widget.coords.first);
        return Positioned(
          left: offset.dx,
          top: offset.dy,
          child: _circleWidget(),
        );
      default:
        final offsetEnd = _offset(widget.coords.first);
        final offsetBegin = _offset(widget.coords.last);
        return WidgetMover(
          offsetBegin: offsetBegin,
          offsetEnd: offsetEnd,
          child: _circleWidget(),
        );
    }
  }

  Widget _circleWidget() => Padding(
        padding: EdgeInsets.all(_cellSize * 0.2),
        child: AnimatedCircle(diameter: _cellSize * 0.6),
      );

  Offset _offset(CoordModel coord) => Offset(
        coord.x * (_strokeSize + _cellSize),
        coord.y * (_strokeSize + _cellSize),
      );
}
