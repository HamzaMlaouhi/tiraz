import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:tiraz/app.dart';
import 'package:tiraz/core/di/injection_container.dart';

import 'support/fake_network_images.dart';

// The new auth hero leans on Directionality-sensitive bits (an arch drawn
// with CustomPaint, MirroredIcon, wordmark ordering) that the other smoke
// tests never exercise in English — they all stay on the Arabic default.
void main() {
  setUp(() async {
    HttpOverrides.global = FakeNetworkImageHttpOverrides();
    await initDependencies();
  });

  tearDown(() async {
    HttpOverrides.global = null;
    await sl.reset();
  });

  testWidgets('Auth page renders without exceptions in both Arabic (RTL) and English (LTR)', (tester) async {
    await tester.pumpWidget(const TirazApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 2300)); // splash auto-navigate
    await tester.pumpAndSettle();

    // Role picker -> pick "shop" -> continue -> lands on the new auth page
    // (Arabic/RTL is the app's default).
    await tester.tap(find.text('التسوّق'));
    await tester.pump();
    await tester.tap(find.text('متابعة'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('أهلاً بك في طِراز'), findsOneWidget);

    // Switch to English (LTR) from the hero's language pill.
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Welcome to Tiraz'), findsOneWidget);

    // Interact with the phone field and emirate chips in this direction too.
    await tester.enterText(find.byType(TextField).first, '501234567');
    await tester.tap(find.text('Sharjah'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
