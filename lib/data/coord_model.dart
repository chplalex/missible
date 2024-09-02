import 'package:equatable/equatable.dart';

class CoordModel extends Equatable {
  final int x;
  final int y;

  const CoordModel({required this.x, required this.y});

  @override
  List<Object> get props => [x, y];
}
