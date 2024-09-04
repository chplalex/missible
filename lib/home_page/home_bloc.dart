import 'dart:async';
import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:missible/common/app_enums.dart';
import 'package:missible/home_page/home_event.dart';
import 'package:missible/home_page/home_state.dart';
import 'package:missible/providers/app_repository.dart';

import '../data/coord_model.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AppRepository _appRepository;

  final popupStreamController = StreamController<PopupType>();

  late final StreamSubscription<CoordModel> _subscription;

  HomeBloc(this._appRepository) : super(HomeScanStartState()) {
    on<HomeBottomItemEvent>(_onBottomItem);
    on<HomeQrScanButtonStartEvent>(_onButtonStart);
    on<HomeQrScanResultEvent>(_onResult);
    on<HomeQrScanButtonSaveEvent>(_onButtonSave);
    on<HomeQrScanButtonDatabaseEvent>(_onButtonDatabase);
    on<HomeQrScanButtonBackEvent>(_onQrScanButtonBack);
    on<HomeGoMapUpdateEvent>(_onMapUpdate);

    _subscription = _appRepository.coordStream.listen((model) {
      add(HomeGoMapUpdateEvent(model: model));
    });
  }

  @override
  Future<void> close() {
    _appRepository.coordStreamPause();
    return _subscription.cancel().then((_) => popupStreamController.close()).then((_) => super.close());
  }

  FutureOr<void> _onBottomItem(HomeBottomItemEvent event, Emitter<HomeState> emitter) {
    final newState = switch (event.bottomItemType) {
      BottomItemType.qrScan => HomeScanStartState(),
      BottomItemType.goMap => HomeGoMapState.init(),
    };
    if (event.bottomItemType == BottomItemType.goMap) {
      _appRepository.coordStreamResume();
    } else {
      _appRepository.coordStreamPause();
    }
    emitter(newState);
  }

  FutureOr<void> _onButtonStart(HomeQrScanButtonStartEvent event, Emitter<HomeState> emitter) {
    popupStreamController.add(PopupType.qrScan);
  }

  FutureOr<void> _onResult(HomeQrScanResultEvent event, Emitter<HomeState> emitter) async {
    emitter(HomeScanResultState(models: event.models));
  }

  FutureOr<void> _onQrScanButtonBack(HomeQrScanButtonBackEvent event, Emitter<HomeState> emitter) {
    emitter(HomeScanStartState());
  }

  FutureOr<void> _onButtonSave(HomeQrScanButtonSaveEvent event, Emitter<HomeState> emitter) async {
    await _appRepository.writeScanModels(models: event.models);
    final models = await _appRepository.readScanModels();
    final newState = HomeScanDatabaseState(models: models);
    emitter(newState);
  }

  FutureOr<void> _onButtonDatabase(HomeQrScanButtonDatabaseEvent event, Emitter<HomeState> emitter) async {
    final models = await _appRepository.readScanModels();
    final newState = HomeScanDatabaseState(models: models);
    emitter(newState);
  }

  FutureOr<void> _onMapUpdate(HomeGoMapUpdateEvent event, Emitter<HomeState> emitter) {
    final oldCoords = (state as HomeGoMapState).coords;
    final newCoords = Queue<CoordModel>.from(oldCoords);
    newCoords.addFirst(event.model);
    if (newCoords.length > 2) {
      newCoords.removeLast();
    }
    emitter(HomeGoMapState(coords: newCoords));
  }
}
