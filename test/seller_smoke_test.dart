import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tiraz/app.dart';
import 'package:tiraz/core/di/injection_container.dart';

import 'support/fake_network_images.dart';

void main() {
  setUp(() async {
    HttpOverrides.global = FakeNetworkImageHttpOverrides();
    await initDependencies();
  });

  tearDown(() async {
    HttpOverrides.global = null;
    await sl.reset();
  });

  testWidgets('Seller flow: pick seller, browse tabs, add a product, reserve an event, switch back', (tester) async {
    await tester.pumpWidget(const TirazApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2300)); // splash auto-navigate
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Role picker -> pick "sell" -> continue.
    await tester.tap(find.text('البيع'));
    await tester.pump();
    await tester.tap(find.text('متابعة'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Auth -> browse as guest -> seller dashboard.
    final guestFinder = find.text('أو تصفّحي كضيفة');
    await tester.ensureVisible(guestFinder);
    await tester.tap(guestFinder);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500)); // no cubit delay, but let animations settle
    await tester.pumpAndSettle(const Duration(milliseconds: 500));
    expect(tester.takeException(), isNull);
    expect(find.text('لوحتك'), findsOneWidget);

    // Seller bottom nav should differ from the buyer's.
    expect(find.text('منتجاتي'), findsWidgets);
    expect(find.text('الفعاليات'), findsWidgets);

    // Switch to the Products tab and add a product.
    await tester.tap(find.text('منتجاتي').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('أضيفي منتجًا').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Name, description, dimensions (length/chest/sleeve), then price.
    await tester.enterText(find.byType(TextField).at(0), 'Layla jalabiya');
    await tester.enterText(find.byType(TextField).at(1), 'A lightweight everyday piece.');
    await tester.enterText(find.byType(TextField).at(2), '140');
    await tester.enterText(find.byType(TextField).at(3), '106');
    await tester.enterText(find.byType(TextField).at(4), '56');
    await tester.enterText(find.byType(TextField).at(5), '399');
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.tap(find.text('حفظ المنتج'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Layla jalabiya'), findsOneWidget);

    // Switch to the Events tab and reserve a spot.
    await tester.tap(find.text('الفعاليات').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('احجزي مكانك').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('محجوز'), findsWidgets);

    // Switch back to buying from the seller account tab.
    await tester.tap(find.text('حسابي').first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('التبديل إلى التسوّق'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Landed on the buyer home page (its own search bar is present).
    expect(find.text('طِراز'), findsWidgets);
  });
}
