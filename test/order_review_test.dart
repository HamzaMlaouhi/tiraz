import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart' hide Order;
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tiraz/core/di/injection_container.dart';
import 'package:tiraz/core/error/failure.dart';
import 'package:tiraz/core/l10n/app_localizations.dart';
import 'package:tiraz/features/orders/data/models/order_model.dart';
import 'package:tiraz/features/orders/domain/entities/order.dart';
import 'package:tiraz/features/orders/domain/repositories/orders_repository.dart';
import 'package:tiraz/features/orders/domain/usecases/get_order.dart';
import 'package:tiraz/features/orders/domain/usecases/get_orders.dart';
import 'package:tiraz/features/orders/domain/usecases/place_order.dart';
import 'package:tiraz/features/orders/domain/usecases/submit_order_review.dart';
import 'package:tiraz/features/orders/presentation/cubit/orders_cubit.dart';
import 'package:tiraz/features/orders/presentation/widgets/order_review_card.dart';

/// A real GET /orders/:id response for a delivered, not-yet-reviewed order.
Map<String, dynamic> _deliveredJson() =>
    jsonDecode(File('test/fixtures/order_delivered.json').readAsStringSync()) as Map<String, dynamic>;

/// Answers submitReview the way the server does: the same order, now reviewed.
class _FakeOrdersRepository implements OrdersRepository {
  ({String orderId, int rating, String? comment})? submitted;

  @override
  Future<Either<Failure, Order>> submitReview(String orderId, {required int rating, String? comment}) async {
    submitted = (orderId: orderId, rating: rating, comment: comment);
    final json = _deliveredJson()
      ..['canReview'] = false
      ..['review'] = {'rating': rating, 'comment': comment};
    return Right(OrderModel.fromJson(json));
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('parses review fields from the API (and tolerates an older server without them)', () {
    final order = OrderModel.fromJson(_deliveredJson());
    expect(order.status, OrderStatusKind.delivered);
    expect(order.canReview, isTrue);
    expect(order.review, isNull);

    final reviewed = OrderModel.fromJson(_deliveredJson()
      ..['canReview'] = false
      ..['review'] = {'rating': 4, 'comment': null});
    expect(reviewed.review, const OrderReview(rating: 4));

    final legacy = OrderModel.fromJson(_deliveredJson()
      ..remove('canReview')
      ..remove('review'));
    expect(legacy.canReview, isFalse);
  });

  group('OrderReviewCard', () {
    late _FakeOrdersRepository repository;

    setUp(() {
      repository = _FakeOrdersRepository();
      sl.registerSingleton(OrdersCubit(
        getOrders: GetOrders(repository),
        getOrder: GetOrder(repository),
        placeOrder: PlaceOrder(repository),
        submitOrderReview: SubmitOrderReview(repository),
      ));
    });

    tearDown(() => sl.reset());

    testWidgets('rate, comment, submit → shows the submitted review', (tester) async {
      await tester.pumpWidget(MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(
          body: StreamBuilder<void>(
            stream: sl<OrdersCubit>().stream,
            builder: (context, _) {
              final order = sl<OrdersCubit>().state.byId('TRZ-2790') ?? OrderModel.fromJson(_deliveredJson());
              return SingleChildScrollView(child: OrderReviewCard(order: order));
            },
          ),
        ),
      ));

      expect(find.text('How was your order?'), findsOneWidget);
      final submit = find.widgetWithText(ElevatedButton, 'Submit review');
      // No stars yet → can't submit.
      expect(tester.widget<ElevatedButton>(submit).onPressed, isNull);

      await tester.tap(find.byIcon(Icons.star_outline_rounded).at(3)); // 4th star
      await tester.enterText(find.byType(TextField), 'Perfect fit');
      await tester.pump();
      expect(find.byIcon(Icons.star_rounded), findsNWidgets(4));

      await tester.tap(submit);
      await tester.pumpAndSettle();

      expect(repository.submitted, (orderId: 'TRZ-2790', rating: 4, comment: 'Perfect fit'));
      expect(find.text('Your review'), findsOneWidget);
      expect(find.text('Perfect fit'), findsOneWidget);
      expect(find.text('Submit review'), findsNothing);
      expect(find.text('Thanks for your review!'), findsOneWidget);
    });
  });
}
