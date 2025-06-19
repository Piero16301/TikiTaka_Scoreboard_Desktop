import 'package:flutter_test/flutter_test.dart';
import 'package:tikitaka_scoreboard_desktop/app/app.dart';
import 'package:tikitaka_scoreboard_desktop/counter/counter.dart';

void main() {
  group('App', () {
    testWidgets('renders CounterPage', (tester) async {
      await tester.pumpWidget(const App());
      expect(find.byType(CounterPage), findsOneWidget);
    });
  });
}
