import 'package:get_it/get_it.dart';
import 'package:missible/home_page/home_bloc.dart';
import 'package:missible/providers/app_repository.dart';
import 'package:missible/providers/app_repository_local_impl.dart';
import 'package:missible/providers/sp_manager.dart';

class AppDi {
  static void provides() {
    GetIt.I.registerFactory(() => HomeBloc(GetIt.I.get()));
    GetIt.I.registerFactory<AppRepository>(() => AppRepositoryLocalImpl(GetIt.I.get()));
    GetIt.I.registerSingletonAsync(() => SpManager.createInstance());
  }

  static Future<void> initAsyncSingletons() => Future.wait([
        GetIt.I.getAsync<SpManager>(),
      ]).then((_) => null);
}
