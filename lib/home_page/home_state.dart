import 'package:equatable/equatable.dart';
import 'package:missible/data/coord_model.dart';
import 'package:missible/data/scan_model.dart';

import '../common/app_constants.dart';
import '../common/app_enums.dart';

abstract class HomeState extends Equatable {
  final String title;
  final BottomItemType bottomItemType;

  HomeState({required this.bottomItemType})
      : title = switch (bottomItemType) {
          BottomItemType.qrScan => AppConstants.titleQrScan,
          BottomItemType.goMap => AppConstants.titleGoMap,
        };

  @override
  List<Object> get props => [bottomItemType];
}

class HomeScanStartState extends HomeState {
  HomeScanStartState() : super(bottomItemType: BottomItemType.qrScan);
}

class HomeScanResultState extends HomeState {
  final List<ScanModel> models;

  HomeScanResultState({required this.models}) : super(bottomItemType: BottomItemType.qrScan);

  @override
  List<Object> get props => [...super.props, models];
}

class HomeScanDatabaseState extends HomeState {
  final List<ScanModel> models;

  HomeScanDatabaseState({required this.models}) : super(bottomItemType: BottomItemType.qrScan);

  @override
  List<Object> get props => [...super.props, models];
}

class HomeScanSavedState extends HomeState {
  final List<ScanModel> models;

  HomeScanSavedState({required this.models}) : super(bottomItemType: BottomItemType.qrScan);

  @override
  List<Object> get props => [...super.props, models];
}

class HomeGoMapState extends HomeState {
  final CoordModel? model;

  HomeGoMapState({this.model}) : super(bottomItemType: BottomItemType.goMap);

  @override
  List<Object> get props => [...super.props, if (model != null) model!];
}
