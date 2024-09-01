import 'dart:async';
import 'dart:math';

import 'package:missible/common/app_constants.dart';
import 'package:missible/data/coord_model.dart';
import 'package:missible/data/scan_model.dart';
import 'package:missible/providers/sp_manager.dart';

import 'app_repository.dart';

class AppRepositoryLocalImpl implements AppRepository {
  static const _scanModelsKey = 'scan_models';

  final SpManager _prefs;

  final _coordStreamController = StreamController<CoordModel>();

  final _random = Random();

  CoordModel? _lastCoord;

  Timer? _timer;

  AppRepositoryLocalImpl(this._prefs);

  @override
  Future<List<ScanModel>> readScanModels() => Future(() => _prefs
      .readJsonList(
        _scanModelsKey,
      )
      .map(
        (jsonMap) => ScanModel.fromJson(jsonMap),
      )
      .toList(
        growable: false,
      ));

  @override
  Future<bool> writeScanModels({required List<ScanModel> models}) async {
    final prevModels = await readScanModels();
    final jsonList = (models + prevModels).map((model) => model.toJson()).toList(growable: false);
    return _prefs.writeJsonList(_scanModelsKey, jsonList);
  }

  @override
  Stream<CoordModel> get coordStream => _coordStreamController.stream;

  @override
  Future<CoordModel> readCoordinate() {
    final CoordModel newCoord;

    if (_lastCoord == null) {
      newCoord = CoordModel(x: _random.nextInt(AppConstants.gridDimension), y: _random.nextInt(AppConstants.gridDimension));
    } else {
      final isCoordX = _random.nextBool();
      final ({int x, int y}) data = isCoordX
          ? (
              x: _next(_lastCoord!.x),
              y: _lastCoord!.y,
            )
          : (
              x: _lastCoord!.x,
              y: _next(_lastCoord!.y),
            );
      newCoord = CoordModel(x: data.x, y: data.y);
    }

    _lastCoord = newCoord;

    return Future.value(newCoord);
  }

  int _next(int value) {
    final doIncrement = _random.nextBool();
    return (doIncrement)
        ? (value < AppConstants.gridDimension - 1)
            ? ++value
            : --value
        : (value > 0)
            ? --value
            : ++value;
  }

  @override
  void coordStreamPause() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  @override
  void coordStreamResume() {
    _timer ??= Timer.periodic(
      const Duration(milliseconds: AppConstants.updateCoordDurationInMillis),
      (_) => readCoordinate().then((model) {
        if (!_coordStreamController.isClosed) {
          _coordStreamController.add(model);
        }
      }),
    );
  }
}
