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

  testWidgets('Home page loads, search filters, and a store sheet opens without exceptions', (tester) async {
    await tester.pumpWidget(const TirazApp());
    await tester.pump();
    // splash auto-navigate
    await tester.pump(const Duration(milliseconds: 2300));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);

    // Role picker (Arabic is the default locale) -> pick "shop" -> continue.
    await tester.tap(find.text('التسوّق'));
    await tester.pump();
    await tester.tap(find.text('متابعة'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // Auth page -> browse as guest -> home.
    final guestFinder = find.text('أو تصفّحي كضيفة');
    expect(guestFinder, findsOneWidget);
    await tester.tap(guestFinder);
    await tester.pump();
    // HomeCubit.load() has a 400ms mock delay.
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(tester.takeException(), isNull);

    // Search bar should be present and filter content.
    final searchField = find.byType(TextField).first;
    await tester.enterText(searchField, 'جلابية');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);

    // Clear search, go back to browse mode.
    await tester.enterText(searchField, '');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);

    // Open a store sheet via Hero and interact with it.
    final storeCard = find.text('أتيليه نورة');
    expect(storeCard, findsWidgets);
    await tester.tap(storeCard.first);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
