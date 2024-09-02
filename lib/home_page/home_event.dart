import 'package:missible/data/coord_model.dart';

import '../common/app_enums.dart';
import '../data/scan_model.dart';

abstract class HomeEvent {
  const HomeEvent();
}

class HomeBottomItemEvent extends HomeEvent {
  final BottomItemType bottomItemType;

  const HomeBottomItemEvent({required this.bottomItemType});
}

class HomeQrScanButtonStartEvent extends HomeEvent {
  const HomeQrScanButtonStartEvent();
}

class HomeQrScanButtonBackEvent extends HomeEvent {
  const HomeQrScanButtonBackEvent();
}

class HomeQrScanButtonSaveEvent extends HomeEvent {
  final List<ScanModel> models;

  const HomeQrScanButtonSaveEvent({required this.models});
}

class HomeQrScanButtonDatabaseEvent extends HomeEvent {
  const HomeQrScanButtonDatabaseEvent();
}

class HomeQrScanResultEvent extends HomeEvent {
  final List<ScanModel> models;

  const HomeQrScanResultEvent({required this.models});
}

class HomeGoMapUpdateEvent extends HomeEvent {
  final CoordModel model;

  const HomeGoMapUpdateEvent({required this.model});
}

