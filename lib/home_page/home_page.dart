import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:missible/common/app_constants.dart';
import 'package:missible/common/app_extensions.dart';
import 'package:missible/data/coord_model.dart';
import 'package:missible/data/scan_model.dart';
import 'package:missible/home_page/home_event.dart';
import 'package:missible/popups/qr_scan_popup.dart';
import 'package:missible/widgets/app_colored_button.dart';
import 'package:missible/widgets/app_section_title.dart';
import 'package:missible/widgets/app_text_button.dart';
import 'package:missible/widgets/map_widget.dart';

import '../common/app_enums.dart';
import 'home_bloc.dart';
import 'home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final _bloc = BlocProvider.of<HomeBloc>(context)..popupStreamController.stream.listen(_onPopup);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
        return Scaffold(
          appBar: _appBar(context, state),
          body: _body(context, state),
          bottomNavigationBar: _bottomNavigationBar(context, state),
        );
      }),
    );
  }

  AppBar _appBar(BuildContext context, HomeState state) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(state.title, style: const TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.w600)),
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Image.asset(AppConstants.imLogo),
      ),
    );
  }

  Widget _bottomNavigationBar(BuildContext context, HomeState state) => BottomAppBar(
        color: Theme.of(context).colorScheme.inversePrimary,
        elevation: 8.0,
        child: SizedBox(
          height: 80.0 + 2 * 26.0,
          child: Row(
            children: [
              _buttonNavigationBar(
                context,
                state,
                Icons.qr_code_2_rounded,
                AppConstants.labelQrScan,
                BottomItemType.qrScan,
              ),
              _buttonNavigationBar(
                context,
                state,
                Icons.map_rounded,
                AppConstants.labelGoMap,
                BottomItemType.goMap,
              ),
            ],
          ),
        ),
      );

  Widget _buttonNavigationBar(
    BuildContext context,
    HomeState state,
    IconData iconData,
    String label,
    BottomItemType bottomItemType,
  ) {
    final theme = Theme.of(context);
    final color = state.bottomItemType == bottomItemType
        ? theme.bottomNavigationBarTheme.selectedItemColor
        : theme.bottomNavigationBarTheme.unselectedItemColor;
    final fontWeight = state.bottomItemType == bottomItemType ? FontWeight.w600 : FontWeight.w400;
    final textStyle = theme.textTheme.bodySmall!.copyWith(color: color, fontSize: 15.0, fontWeight: fontWeight);
    return Expanded(
      child: InkWell(
        onTap: () => state.bottomItemType != bottomItemType
            ? _bloc.add(HomeBottomItemEvent(bottomItemType: bottomItemType))
            : {},
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.square(dimension: 24.0, child: Icon(iconData, color: color)),
            const SizedBox(height: 8.0),
            Text(label, style: textStyle),
          ],
        ),
      ),
    );
  }

  Widget _body(BuildContext context, HomeState state) {
    return switch (state) {
      HomeScanStartState _ => _bodyScanStart(context, state),
      HomeScanResultState _ => _bodyScanResult(context, state),
      HomeScanDatabaseState _ => _bodyScanDatabase(context, state),
      HomeGoMapState _ => _bodyGoMap(context, state),
      _ => throw 'Unknown state $state',
    };
  }

  Widget _bodyScanStart(BuildContext context, HomeScanStartState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Spacer(),
          _scanButton(context),
          const Spacer(),
          _databaseButton(text: 'Go to Secret database'),
        ],
      ),
    );
  }

  IconButton _scanButton(BuildContext context) {
    return IconButton(
      style: IconButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.all(16.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: Colors.grey),
        ),
      ),
      onPressed: () => _bloc.add(const HomeQrScanButtonStartEvent()),
      icon: const Icon(Icons.qr_code_scanner_rounded),
      iconSize: 100.0,
    );
  }

  Widget _bodyScanResult(BuildContext context, HomeScanResultState state) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const AppSectionTitle(text: 'Just scanned'),
          _sectionItems(models: state.models),
          _saveButton(models: state.models),
          const SizedBox(height: 16.0),
          _databaseButton(text: 'Go to Secret database without saving'),
          const SizedBox(height: 8.0),
          _backButton(),
        ],
      ),
    );
  }

  Widget _sectionItems({required List<ScanModel> models}) {
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        shrinkWrap: true,
        itemBuilder: (context, index) => _scanItem(model: models[index]),
        separatorBuilder: (_, __) => _separator(),
        itemCount: models.length,
      ),
    );
  }

  Widget _bodyGoMap(BuildContext context, HomeGoMapState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          AppSectionTitle(text: "Enemy's coordinate: (X:Y) => (${_coordsText(state.coords)})"),
          const SizedBox(height: 16.0),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Theme.of(context).colorScheme.inversePrimary,
                border: const Border.fromBorderSide(BorderSide(color: Colors.grey))),
            child: MapWidget(coords: state.coords),
          ),
        ],
      ),
    );
  }

  Object _coordText(int? value) => value != null ? (value + 1).toString() : 'N/A';

  void _onPopup(PopupType popupType) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      return switch (popupType) {
        PopupType.qrScan => _popupQrScan(),
      };
    });
  }

  void _popupQrScan() {
    QrScanPopup().show(context).then((models) {
      if (models != null) {
        _bloc.add(HomeQrScanResultEvent(models: models));
      }
    });
  }

  Widget _scanItem({required ScanModel model}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Text(model.dateTime.format('dd.MM.yy HH:mm')),
            const SizedBox(width: 8.0),
            Expanded(child: Text(model.content, maxLines: 3)),
          ],
        ),
      );

  Widget _sectionItemsEmpty() => const Expanded(
        child: Center(child: Text('The Secret database is empty')),
      );

  Widget _separator() => const Divider(height: 11.0, thickness: 1.0, color: Colors.black12);

  Widget _saveButton({required List<ScanModel> models}) => AppColoredButton(
        text: 'Save in Secret database',
        onTap: () => _bloc.add(HomeQrScanButtonSaveEvent(models: models)),
      );

  Widget _databaseButton({required String text}) => AppColoredButton(
        text: text,
        onTap: () => _bloc.add(const HomeQrScanButtonDatabaseEvent()),
      );

  Widget _backButton() => AppTextButton(
        text: 'Go back without saving',
        onTap: () => _bloc.add(const HomeQrScanButtonBackEvent()),
      );

  Widget _bodyScanDatabase(BuildContext context, HomeScanDatabaseState state) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const AppSectionTitle(text: 'Secret QR codes database'),
          if (state.models.isNotEmpty) _sectionItems(models: state.models) else _sectionItemsEmpty(),
          AppColoredButton(text: 'Go back', onTap: () => _bloc.add(const HomeQrScanButtonBackEvent()))
        ],
      ),
    );
  }

  String _coordsText(Queue<CoordModel> coords) {
    return coords.isNotEmpty ? '${_coordText(coords.first.x)}:${_coordText(coords.first.y)}' : "N/A";
  }
}
