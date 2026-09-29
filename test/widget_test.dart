import 'package:flutter_test/flutter_test.dart';

import 'package:tiraz/app.dart';

import 'support/test_app.dart';

void main() {
  setUp(setUpTestApp);

  tearDown(tearDownTestApp);

  testWidgets('App boots to the splash screen showing the Tiraz wordmark', (WidgetTester tester) async {
    await tester.pumpWidget(const TirazApp());
    await tester.pump();

    expect(find.text('طِراز'), findsOneWidget);

    // Let the splash screen's auto-navigate timer fire so it doesn't leak
    // into the next test.
    await tester.pump(const Duration(milliseconds: 2300));
  });
}
