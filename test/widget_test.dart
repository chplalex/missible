import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:missible/app.dart';
import 'package:missible/home_page/home_bloc.dart';
import 'package:missible/home_page/home_state.dart';
import 'package:mocktail/mocktail.dart';

class MockedHomeBloc extends Mock implements HomeBloc {}

void main() {
  final homeBlock = MockedHomeBloc();
  final initState = HomeScanStartState();
  final stateStream = Stream.value(initState).asBroadcastStream();

  setUpAll(() {
    GetIt.I.registerFactory<HomeBloc>(() => homeBlock);
    when(() => homeBlock.stream).thenAnswer((_) => stateStream);
    when(() => homeBlock.state).thenReturn(initState);
    when(() => homeBlock.close()).thenAnswer((_) => Future.value());
  });

  testWidgets('Start page test', (WidgetTester tester) async {

    await tester.pumpWidget(const App());

    expect(find.text('You have the "Missible"!'), findsOneWidget);
    expect(find.text('Go to Secret database'), findsOneWidget);
  });
}
