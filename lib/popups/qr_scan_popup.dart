import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../data/scan_model.dart';

class QrScanPopup {
  Future<List<ScanModel>?> show(BuildContext context) {
    return showDialog<List<ScanModel>?>(
      context: context,
      barrierDismissible: false,
      builder: _popupBuilder,
    );
  }

  Widget _popupBuilder(BuildContext context) {
    var isStop = false;
    return Dialog.fullscreen(
      child: Stack(
        children: [
          MobileScanner(
            onDetect: (capture) {
              if (isStop) {
                return;
              }
              if (capture.barcodes.isEmpty) {
                return;
              }
              isStop = true;
              final barcodes = capture.barcodes.where((barcode) => barcode.rawValue != null);
              if (barcodes.isEmpty) {
                return;
              }
              final uniqueMap = {for (final barcode in barcodes) barcode.rawValue!: null};
              final now = DateTime.now();
              final models = uniqueMap.keys
                  .map(
                    (content) => ScanModel(content: content, dateTime: now),
                  )
                  .toList(growable: false);
              Navigator.of(context).pop(models);
            },
          ),
          Align(
            alignment: AlignmentDirectional.topEnd,
            child: InkWell(
              onTap: () => Navigator.of(context).pop(),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.close_rounded),
              ),
            ),
          ),
          const Center(child: Divider(color: Colors.red)),
          const Center(child: VerticalDivider(color: Colors.red)),
        ],
      ),
    );
  }
}
