import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:missible/common/app_di.dart';
import 'package:get_it/get_it.dart';

import 'app.dart';
import 'debug/app_bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kDebugMode) {
    Bloc.observer = AppBlocObserver();
  }

  await _initAppDi();

  runApp(const App());
}

Future<void> _initAppDi() async {
  AppDi.provides();
  return GetIt.I.allReady().then((_) => AppDi.initAsyncSingletons());
}


