import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:missible/common/app_constants.dart';
import 'package:missible/common/app_typedefs.dart';
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
        alignment: Alignment.topLeft,
        children: [
          SquareGrid(gridDimension: AppConstants.gridDimension, gridSize: _gridSize),
          _circle(),
        ],
      );
    });
  }

  Widget _circle() {
    final positionStart = _positionedData(const CoordModel(x: 0, y: 0));
    final positionEnd = _positionedData(const CoordModel(x: 2, y: 0));
    return Positioned.fill(
      top: positionStart.top,
      left: positionStart.left,
      bottom: positionStart.bottom,
      right: positionStart.right,
      child: Padding(
        padding: EdgeInsets.all(_cellSize * 0.2),
        child: AnimatedCircle(diameter: _cellSize),
      ),
    );
    return WidgetMover(
      startPosition: positionStart,
      endPosition: positionEnd,
      child: AnimatedCircle(diameter: _cellSize),
    );
    switch (widget.coords.length) {
      case 0:
        return const SizedBox.shrink();
      case 1:
        final position = _positionedData(widget.coords.first);
        return Positioned.fill(
          top: position.top,
          left: position.left,
          bottom: position.bottom,
          right: position.right,
          child: Padding(
            padding: EdgeInsets.all(_cellSize * 0.2),
            child: AnimatedCircle(diameter: _cellSize),
          ),
        );
      default:
        final positionStart = _positionedData(widget.coords.first);
        final positionEnd = _positionedData(widget.coords.last);
        return WidgetMover(
            startPosition: positionStart,
            endPosition: positionEnd,
            child: AnimatedCircle(diameter: _cellSize),
        );
    }
  }

  PositionedData _positionedData(CoordModel coord) => (
        top: coord.y * (_strokeSize + _cellSize),
        left: coord.x * (_strokeSize + _cellSize),
        bottom: (AppConstants.gridDimension - coord.y - 1) * (_strokeSize + _cellSize),
        right: (AppConstants.gridDimension - coord.x - 1) * (_strokeSize + _cellSize),
      );
}
