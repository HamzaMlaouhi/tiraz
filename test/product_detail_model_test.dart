import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tiraz/features/product/data/models/product_detail_model.dart';
import 'package:tiraz/features/product/domain/entities/eid_deadline.dart';

void main() {
  // A real GET /products/:id response (mtm status edited to closingSoon to
  // cover a non-default value).
  Map<String, dynamic> fixture() =>
      jsonDecode(File('test/fixtures/product_detail.json').readAsStringSync()) as Map<String, dynamic>;

  test('parses both Eid deadlines from the API', () {
    final detail = ProductDetailModel.fromJson(fixture());

    expect(detail.eidDeadlineRtw!.status, EidDeadlineStatus.open);
    expect(detail.eidDeadlineMtm!.status, EidDeadlineStatus.closingSoon);
    expect(detail.eidDeadlineMtm!.label.en, startsWith('Order by'));
    // MTM needs its lead time on top, so it must be ordered earlier than RTW.
    expect(detail.eidDeadlineMtm!.orderBy.isBefore(detail.eidDeadlineRtw!.orderBy), isTrue);
  });

  test('a server without eidDeadline (or after Eid) still parses, with no deadlines', () {
    final json = fixture()..remove('eidDeadline');
    final detail = ProductDetailModel.fromJson(json);

    expect(detail.eidDeadlineRtw, isNull);
    expect(detail.eidDeadlineMtm, isNull);

    final afterEid = fixture()..['eidDeadline'] = null;
    expect(ProductDetailModel.fromJson(afterEid).eidDeadlineMtm, isNull);
  });
}
