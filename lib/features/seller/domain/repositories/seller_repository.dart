import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/market_event.dart';
import '../entities/new_seller_product.dart';
import '../entities/seller_product.dart';
import '../entities/seller_store_profile.dart';

/// A seller's dashboard in one fetch: store, listings, events, and which
/// events they've reserved.
typedef SellerOverview = ({
  SellerStoreProfile store,
  List<SellerProduct> products,
  List<MarketEvent> events,
  Set<String> reservedEventIds,
});

/// One event plus whether the current seller holds a booth there.
typedef EventStatus = ({MarketEvent event, bool reserved});

abstract class SellerRepository {
  Future<Either<Failure, SellerOverview>> getOverview();
  Future<Either<Failure, SellerProduct>> getProduct(String id);
  Future<Either<Failure, SellerProduct>> createProduct(NewSellerProduct product);
  Future<Either<Failure, Unit>> deleteProduct(String id);
  Future<Either<Failure, EventStatus>> getEvent(String id);
  Future<Either<Failure, Unit>> reserveEvent(String id);
  Future<Either<Failure, Unit>> cancelReservation(String id);
}
