import 'package:flutter_test/flutter_test.dart';

import 'package:tiraz/app.dart';
import 'package:tiraz/core/di/injection_container.dart';

void main() {
  setUp(() async {
    await initDependencies();
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('App boots to the splash screen showing the Tiraz wordmark', (WidgetTester tester) async {
    await tester.pumpWidget(const TirazApp());
    await tester.pump();

    expect(find.text('طِراز'), findsOneWidget);

    // Let the splash screen's auto-navigate timer fire so it doesn't leak
    // into the next test.
    await tester.pump(const Duration(milliseconds: 2300));
  });
}
