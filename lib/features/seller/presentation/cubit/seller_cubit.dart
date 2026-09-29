import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/market_event.dart';
import '../../domain/entities/new_seller_product.dart';
import '../../domain/entities/seller_product.dart';
import '../../domain/entities/seller_store_profile.dart';
import '../../domain/usecases/create_seller_product.dart';
import '../../domain/usecases/delete_seller_product.dart';
import '../../domain/usecases/get_market_event.dart';
import '../../domain/usecases/get_seller_overview.dart';
import '../../domain/usecases/get_seller_product.dart';
import '../../domain/usecases/set_event_reservation.dart';

part 'seller_state.dart';

/// Everything about the current user's seller side — their store profile
/// (created on first load), their listings, and their event reservations.
/// A lazy singleton shared by every seller page.
///
/// Mutations return the failure message, or null on success. Deleting and
/// (un)reserving are optimistic and roll back on failure; a reservation
/// change then re-fetches that event so its slot counts are current.
class SellerCubit extends Cubit<SellerState> {
  final GetSellerOverview _getOverview;
  final GetSellerProduct _getProduct;
  final CreateSellerProduct _createProduct;
  final DeleteSellerProduct _deleteProduct;
  final GetMarketEvent _getEvent;
  final SetEventReservation _setReservation;

  SellerCubit({
    required GetSellerOverview getOverview,
    required GetSellerProduct getProduct,
    required CreateSellerProduct createProduct,
    required DeleteSellerProduct deleteProduct,
    required GetMarketEvent getEvent,
    required SetEventReservation setReservation,
  })  : _getOverview = getOverview,
        _getProduct = getProduct,
        _createProduct = createProduct,
        _deleteProduct = deleteProduct,
        _getEvent = getEvent,
        _setReservation = setReservation,
        super(const SellerState());

  Future<void> load() async {
    if (state.status != SellerStatus.loaded) emit(state.copyWith(status: SellerStatus.loading));
    final result = await _getOverview(const NoParams());
    result.fold(
      (failure) => emit(state.copyWith(status: SellerStatus.error, errorMessage: failure.message)),
      (overview) => emit(SellerState(
        status: SellerStatus.loaded,
        store: overview.store,
        products: overview.products,
        events: overview.events,
        reservedEventIds: overview.reservedEventIds,
      )),
    );
  }

  Future<String?> addProduct(NewSellerProduct product) async {
    final result = await _createProduct(product);
    return result.fold((failure) => failure.message, (created) {
      // Newest first, matching the server's ordering.
      emit(state.copyWith(products: [created, ...state.products]));
      return null;
    });
  }

  /// Refreshes one listing (detail page) and merges it into the list.
  Future<String?> loadProduct(String id) async {
    final result = await _getProduct(id);
    return result.fold((failure) => failure.message, (product) {
      final exists = state.products.any((p) => p.id == id);
      emit(state.copyWith(
        products: exists ? [for (final p in state.products) p.id == id ? product : p] : [product, ...state.products],
      ));
      return null;
    });
  }

  Future<String?> removeProduct(String id) async {
    final previous = state;
    emit(state.copyWith(products: state.products.where((p) => p.id != id).toList()));
    final result = await _deleteProduct(id);
    return result.fold((failure) {
      emit(previous);
      return failure.message;
    }, (_) => null);
  }

  Future<String?> reserveEvent(String eventId) => _setReserved(eventId, true);

  Future<String?> cancelReservation(String eventId) => _setReserved(eventId, false);

  /// Refreshes one event (detail page), including whether it's reserved.
  Future<String?> loadEvent(String eventId) async {
    final result = await _getEvent(eventId);
    return result.fold((failure) => failure.message, (status) {
      _mergeEvent(status.event, status.reserved);
      return null;
    });
  }

  Future<String?> _setReserved(String eventId, bool reserve) async {
    if (state.reservedEventIds.contains(eventId) == reserve) return null;
    final previous = state;
    final ids = {...state.reservedEventIds};
    reserve ? ids.add(eventId) : ids.remove(eventId);
    emit(state.copyWith(reservedEventIds: ids));

    final result = await _setReservation(EventReservationParams(eventId: eventId, reserve: reserve));
    if (result.isLeft()) {
      emit(previous);
      return result.fold((failure) => failure.message, (_) => null);
    }
    await loadEvent(eventId);
    return null;
  }

  void _mergeEvent(MarketEvent event, bool reserved) {
    final ids = {...state.reservedEventIds};
    reserved ? ids.add(event.id) : ids.remove(event.id);
    final exists = state.events.any((e) => e.id == event.id);
    emit(state.copyWith(
      events: exists ? [for (final e in state.events) e.id == event.id ? event : e] : [...state.events, event],
      reservedEventIds: ids,
    ));
  }
}
