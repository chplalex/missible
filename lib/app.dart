import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:missible/common/app_themes.dart';

import 'home_page/home_bloc.dart';
import 'home_page/home_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appThemeLight(),
      home: BlocProvider(
        create: (_) => GetIt.I.get<HomeBloc>(),
        child: const HomePage(),
      ),
    );
  }
}
