import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tiraz/app.dart';
import 'package:tiraz/core/di/injection_container.dart';

import 'support/fake_network_images.dart';

// Kept in its own file — see event_detail_smoke_test.dart for why
// (appRouter is a module-level singleton shared within a test file).
void main() {
  setUp(() async {
    HttpOverrides.global = FakeNetworkImageHttpOverrides();
    await initDependencies();
  });

  tearDown(() async {
    HttpOverrides.global = null;
    await sl.reset();
  });

  testWidgets(
    'Add product: photo gallery, dimensions, handmade extra cost, and quality all show on the detail page',
    (tester) async {
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

      await tester.tap(find.text('منتجاتي').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('أضيفي منتجًا').first);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // Pick a stock photo, fill the form, toggle handmade (revealing the
      // extra-cost field), and choose a quality tier.
      final galleryThumbnails = find.byType(GestureDetector);
      await tester.tap(galleryThumbnails.at(2));
      await tester.pump();

      await tester.enterText(find.byType(TextField).at(0), 'Noor set');
      await tester.enterText(find.byType(TextField).at(1), 'Hand-finished hem, soft cotton blend.');
      await tester.enterText(find.byType(TextField).at(2), '145');
      await tester.enterText(find.byType(TextField).at(3), '110');
      await tester.enterText(find.byType(TextField).at(4), '58');
      await tester.enterText(find.byType(TextField).at(5), '500');
      await tester.pump();

      final premiumChip = find.text('ممتازة'); // Premium quality chip
      await tester.ensureVisible(premiumChip);
      await tester.tap(premiumChip);
      await tester.pump();

      final handmadeSwitch = find.byType(Switch);
      expect(handmadeSwitch, findsOneWidget);
      await tester.ensureVisible(handmadeSwitch);
      await tester.tap(handmadeSwitch);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      // The extra-cost field is the 7th TextField once it appears.
      final extraCostField = find.byType(TextField).at(6);
      await tester.ensureVisible(extraCostField);
      await tester.enterText(extraCostField, '150');
      await tester.pump();

      final saveButton = find.text('حفظ المنتج');
      await tester.ensureVisible(saveButton);
      await tester.tap(saveButton);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Noor set'), findsOneWidget);

      // Open the new product's detail page.
      await tester.tap(find.text('Noor set'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      expect(find.text('Hand-finished hem, soft cotton blend.'), findsOneWidget);
      expect(find.text('145 cm'), findsOneWidget);
      expect(find.text('110 cm'), findsOneWidget);
      expect(find.text('58 cm'), findsOneWidget);
      expect(find.text('صناعة يدوية'), findsWidgets); // handmade badge
      expect(find.text('ممتازة'), findsWidgets); // quality badge
      expect(find.text('500 د.إ'), findsOneWidget); // base price
      expect(find.text('+ 150 د.إ'), findsOneWidget); // handmade extra
      expect(find.text('650 د.إ'), findsOneWidget); // total price
    },
  );
}
