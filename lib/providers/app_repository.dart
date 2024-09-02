import 'package:missible/data/coord_model.dart';
import 'package:missible/data/scan_model.dart';

abstract interface class AppRepository {
  Future<List<ScanModel>> readScanModels();

  Future<bool> writeScanModels({required List<ScanModel> models});

  Stream<CoordModel> get coordStream;

  Future<CoordModel> readCoordinate();

  void coordStreamResume();

  void coordStreamPause();

}
