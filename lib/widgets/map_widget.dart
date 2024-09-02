import 'dart:math';

import 'package:flutter/material.dart';
import 'package:missible/common/app_constants.dart';
import 'package:missible/data/coord_model.dart';
import 'package:missible/widgets/square_grid.dart';

import 'animated_circle.dart';

class MapWidget extends StatefulWidget {
  final CoordModel? coord;

  const MapWidget({super.key, required this.coord});

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
          if (widget.coord != null) _circle(coord: widget.coord!),
        ],
      );
    });
  }

  Widget _circle({required CoordModel coord}) {
    return Positioned.fill(
      top: coord.y * (_strokeSize + _cellSize),
      left: coord.x * (_strokeSize + _cellSize),
      bottom: (AppConstants.gridDimension - coord.y - 1) * (_strokeSize + _cellSize),
      right: (AppConstants.gridDimension - coord.x - 1) * (_strokeSize + _cellSize),
      child: Padding(
        padding: EdgeInsets.all(_cellSize * 0.2),
        child: AnimatedCircle(diameter: _cellSize),
      ),
    );
  }
}
