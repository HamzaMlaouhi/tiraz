import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/new_seller_product.dart';
import '../../domain/entities/seller_product.dart';
import '../../domain/repositories/seller_repository.dart';
import '../datasources/seller_remote_data_source.dart';
import '../models/market_event_model.dart';
import '../models/seller_product_model.dart';

class SellerRepositoryImpl implements SellerRepository {
  final SellerDataSource remoteDataSource;
  const SellerRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, SellerOverview>> getOverview() => _run(() async {
        // The store must exist before the seller-guarded product list is asked for.
        final store = await remoteDataSource.ensureStore();
        // Future.wait (not a record `.wait`) so a failure surfaces as the
        // original ServerException rather than a ParallelWaitError.
        final results = await Future.wait([remoteDataSource.getProducts(), remoteDataSource.getEvents()]);
        final products = results[0] as List<SellerProductModel>;
        final events = results[1] as List<MarketEventModel>;
        return (
          store: store,
          products: products,
          events: events,
          reservedEventIds: {for (final e in events) if (e.isReservedByMe) e.id},
        );
      });

  @override
  Future<Either<Failure, SellerProduct>> getProduct(String id) => _run(() => remoteDataSource.getProduct(id));

  @override
  Future<Either<Failure, SellerProduct>> createProduct(NewSellerProduct product) =>
      _run(() => remoteDataSource.createProduct(product));

  @override
  Future<Either<Failure, Unit>> deleteProduct(String id) => _runUnit(() => remoteDataSource.deleteProduct(id));

  @override
  Future<Either<Failure, EventStatus>> getEvent(String id) => _run(() async {
        final event = await remoteDataSource.getEvent(id);
        return (event: event, reserved: event.isReservedByMe);
      });

  @override
  Future<Either<Failure, Unit>> reserveEvent(String id) => _runUnit(() => remoteDataSource.reserveEvent(id));

  @override
  Future<Either<Failure, Unit>> cancelReservation(String id) =>
      _runUnit(() => remoteDataSource.cancelReservation(id));

  Future<Either<Failure, T>> _run<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  Future<Either<Failure, Unit>> _runUnit(Future<void> Function() call) => _run(() async {
        await call();
        return unit;
      });
}
