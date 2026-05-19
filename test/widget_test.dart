import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapingo_app/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: MapingoApp()));
    await tester.pumpAndSettle();

    expect(find.text('Could not start Mapingo'), findsOneWidget);
  });
}
