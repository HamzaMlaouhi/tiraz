import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:tiraz/app.dart';
import 'package:tiraz/core/di/injection_container.dart';

import 'support/fake_network_images.dart';

// Kept in its own file (not appended to seller_smoke_test.dart): `appRouter`
// is a module-level singleton, so two `testWidgets` in the same file would
// share its navigation state across tests — a fresh file gets a fresh
// isolate, and so a fresh router.
void main() {
  setUp(() async {
    HttpOverrides.global = FakeNetworkImageHttpOverrides();
    await initDependencies();
  });

  tearDown(() async {
    HttpOverrides.global = null;
    await sl.reset();
  });

  testWidgets('Event detail: tapping an event card shows place, time, price, and attendance', (tester) async {
    await tester.pumpWidget(const TirazApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pumpAndSettle();

    await tester.tap(find.text('البيع'));
    await tester.pump();
    await tester.tap(find.text('متابعة'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('أو تصفّحي كضيفة'));
    await tester.pump();
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('الفعاليات').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Tap the event's name (not the reserve button) to open its detail page.
    await tester.tap(find.text('سوق رمضان').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Place, time, price, and attendance all show on the detail page.
    expect(find.text('مدينة جميرا الرياضية · دبي'), findsOneWidget);
    expect(find.text('4:00 م – 11:00 م'), findsOneWidget);
    expect(find.text('250 د.إ'), findsOneWidget);
    expect(find.textContaining('2,400'), findsWidgets);

    // Reserve from the detail page itself.
    await tester.tap(find.text('احجزي مكانك'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('إلغاء الحجز'), findsOneWidget);
  });
}
