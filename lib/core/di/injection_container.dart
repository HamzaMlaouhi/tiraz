import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import '../../features/account/data/datasources/account_remote_data_source.dart';
import '../../features/account/data/repositories/account_repository_impl.dart';
import '../../features/account/domain/repositories/account_repository.dart';
import '../../features/account/domain/usecases/get_profile.dart';
import '../../features/account/domain/usecases/update_profile.dart';
import '../../features/account/presentation/cubit/account_cubit.dart';
import '../../features/addresses/data/datasources/addresses_remote_data_source.dart';
import '../../features/addresses/data/repositories/addresses_repository_impl.dart';
import '../../features/addresses/domain/repositories/addresses_repository.dart';
import '../../features/addresses/domain/usecases/delete_address.dart';
import '../../features/addresses/domain/usecases/get_addresses.dart';
import '../../features/addresses/domain/usecases/save_address.dart';
import '../../features/addresses/domain/usecases/set_default_address.dart';
import '../../features/addresses/presentation/cubit/addresses_cubit.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/send_otp.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/cart/data/datasources/cart_remote_data_source.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/cart/domain/usecases/add_custom_items_to_cart.dart';
import '../../features/cart/domain/usecases/add_product_to_cart.dart';
import '../../features/cart/domain/usecases/get_cart.dart';
import '../../features/cart/domain/usecases/remove_cart_item.dart';
import '../../features/cart/domain/usecases/set_gift_wrap.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/fit/data/datasources/fit_remote_data_source.dart';
import '../../features/fit/data/repositories/fit_repository_impl.dart';
import '../../features/fit/domain/repositories/fit_repository.dart';
import '../../features/fit/domain/usecases/create_measurement_profile.dart';
import '../../features/fit/domain/usecases/get_measurement_profiles.dart';
import '../../features/fit/domain/usecases/submit_measurement.dart';
import '../../features/fit/presentation/cubit/fit_cubit.dart';
import '../../features/home/data/datasources/home_remote_data_source.dart';
import '../../features/home/data/datasources/recently_viewed_local_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/data/repositories/recently_viewed_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/repositories/recently_viewed_repository.dart';
import '../../features/home/domain/usecases/get_home_data.dart';
import '../../features/home/domain/usecases/get_products.dart';
import '../../features/home/domain/usecases/recently_viewed.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/home/presentation/cubit/product_list_cubit.dart';
import '../../features/home/presentation/cubit/recently_viewed_cubit.dart';
import '../../features/orders/data/datasources/orders_remote_data_source.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/get_order.dart';
import '../../features/orders/domain/usecases/get_orders.dart';
import '../../features/orders/domain/usecases/place_order.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/product/data/datasources/product_remote_data_source.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/get_product_detail.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';
import '../../features/seller/data/datasources/seller_remote_data_source.dart';
import '../../features/seller/data/repositories/seller_repository_impl.dart';
import '../../features/seller/domain/repositories/seller_repository.dart';
import '../../features/seller/domain/usecases/create_seller_product.dart';
import '../../features/seller/domain/usecases/delete_seller_product.dart';
import '../../features/seller/domain/usecases/get_market_event.dart';
import '../../features/seller/domain/usecases/get_seller_overview.dart';
import '../../features/seller/domain/usecases/get_seller_product.dart';
import '../../features/seller/domain/usecases/set_event_reservation.dart';
import '../../features/seller/presentation/cubit/seller_cubit.dart';
import '../../features/wallet/data/datasources/wallet_remote_data_source.dart';
import '../../features/wallet/data/repositories/wallet_repository_impl.dart';
import '../../features/wallet/domain/repositories/wallet_repository.dart';
import '../../features/wallet/domain/usecases/get_wallet.dart';
import '../../features/wallet/presentation/cubit/wallet_cubit.dart';
import '../../features/wishlist/data/datasources/wishlist_remote_data_source.dart';
import '../../features/wishlist/data/repositories/wishlist_repository_impl.dart';
import '../../features/wishlist/domain/repositories/wishlist_repository.dart';
import '../../features/wishlist/domain/usecases/add_to_wishlist.dart';
import '../../features/wishlist/domain/usecases/get_wishlist.dart';
import '../../features/wishlist/domain/usecases/remove_from_wishlist.dart';
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';
import '../network/api_client.dart';
import '../role/role_cubit.dart';
import '../session/session_store.dart';

final sl = GetIt.instance;

/// Wires every layer for every feature: data sources -> repositories ->
/// use cases -> cubits. Call once from `main()` before `runApp`.
Future<void> initDependencies() async {
  // ---- Networking / session (every remote data source depends on these) ----
  final sessionStore = SessionStore();
  await sessionStore.hydrate();
  sl.registerSingleton(sessionStore);
  sl.registerSingleton(ApiClient(sessionStore));
  sl.registerLazySingleton<Dio>(() => sl<ApiClient>().dio);

  // ---- App-wide (shared across tabs, so registered as singletons) ----
  sl.registerLazySingleton(() => RoleCubit());

  // ---- Seller (singleton: every seller tab reads one store/listings/events
  // state; the dashboard loads it) ----
  sl.registerLazySingleton<SellerDataSource>(() => SellerRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<SellerRepository>(() => SellerRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetSellerOverview(sl()));
  sl.registerLazySingleton(() => GetSellerProduct(sl()));
  sl.registerLazySingleton(() => CreateSellerProduct(sl()));
  sl.registerLazySingleton(() => DeleteSellerProduct(sl()));
  sl.registerLazySingleton(() => GetMarketEvent(sl()));
  sl.registerLazySingleton(() => SetEventReservation(sl()));
  sl.registerLazySingleton(
    () => SellerCubit(
      getOverview: sl(),
      getProduct: sl(),
      createProduct: sl(),
      deleteProduct: sl(),
      getEvent: sl(),
      setReservation: sl(),
    ),
  );

  // ---- Auth ----
  sl.registerLazySingleton<AuthDataSource>(() => AuthRemoteDataSourceImpl(sl(), sl()));
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  // Singleton (not factory): Auth and OTP pages share one flow instance
  // so phone/OTP entry survives the push from /auth to /otp.
  sl.registerLazySingleton(() => AuthCubit(sendOtp: sl(), verifyOtp: sl()));

  // ---- Account / user profile (singleton: the header survives tab
  // switches and the edit sheet updates the same instance) ----
  sl.registerLazySingleton<AccountDataSource>(() => AccountRemoteDataSourceImpl(sl(), sl()));
  sl.registerLazySingleton<AccountRepository>(() => AccountRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetProfile(sl()));
  sl.registerLazySingleton(() => UpdateProfile(sl()));
  sl.registerLazySingleton(() => AccountCubit(getProfile: sl(), updateProfile: sl()));

  // ---- Wishlist (singleton: Account count, Wishlist page and the
  // product page heart all read one list) ----
  sl.registerLazySingleton<WishlistDataSource>(() => WishlistRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<WishlistRepository>(() => WishlistRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetWishlist(sl()));
  sl.registerLazySingleton(() => AddToWishlist(sl()));
  sl.registerLazySingleton(() => RemoveFromWishlist(sl()));
  sl.registerLazySingleton(
    () => WishlistCubit(getWishlist: sl(), addToWishlist: sl(), removeFromWishlist: sl()),
  );

  // ---- Addresses (singleton: Checkout and Account share the default) ----
  sl.registerLazySingleton<AddressesDataSource>(() => AddressesRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<AddressesRepository>(() => AddressesRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetAddresses(sl()));
  sl.registerLazySingleton(() => SaveAddress(sl()));
  sl.registerLazySingleton(() => DeleteAddress(sl()));
  sl.registerLazySingleton(() => SetDefaultAddress(sl()));
  sl.registerLazySingleton(
    () => AddressesCubit(getAddresses: sl(), saveAddress: sl(), deleteAddress: sl(), setDefaultAddress: sl()),
  );

  // ---- Cart (singleton: Home badge, Product, Cart and Checkout share it) ----
  sl.registerLazySingleton<CartDataSource>(() => CartRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<CartRepository>(() => CartRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetCart(sl()));
  sl.registerLazySingleton(() => AddProductToCart(sl()));
  sl.registerLazySingleton(() => AddCustomItemsToCart(sl()));
  sl.registerLazySingleton(() => RemoveCartItem(sl()));
  sl.registerLazySingleton(() => SetGiftWrap(sl()));
  sl.registerLazySingleton(
    () => CartCubit(
      getCart: sl(),
      addProductToCart: sl(),
      addCustomItemsToCart: sl(),
      removeCartItem: sl(),
      setGiftWrap: sl(),
    ),
  );

  // ---- Wallet (singleton: Account row and Wallet page share the balance) ----
  sl.registerLazySingleton<WalletDataSource>(() => WalletRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<WalletRepository>(() => WalletRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetWallet(sl()));
  sl.registerLazySingleton(() => WalletCubit(getWallet: sl()));

  // ---- Home ----
  sl.registerLazySingleton<HomeDataSource>(() => HomeRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetHomeData(sl()));
  sl.registerFactory(() => HomeCubit(getHomeData: sl()));
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerFactory(() => ProductListCubit(getProducts: sl()));

  // Recently viewed (on-device; singleton so the Home row survives tab switches)
  sl.registerLazySingleton<RecentlyViewedDataSource>(() => RecentlyViewedLocalDataSourceImpl());
  sl.registerLazySingleton<RecentlyViewedRepository>(() => RecentlyViewedRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetRecentlyViewed(sl()));
  sl.registerLazySingleton(() => RecordProductView(sl()));
  sl.registerLazySingleton(() => ClearRecentlyViewed(sl()));
  sl.registerLazySingleton(
    () => RecentlyViewedCubit(getRecentlyViewed: sl(), recordProductView: sl(), clearRecentlyViewed: sl()),
  );

  // ---- Product ----
  sl.registerLazySingleton<ProductDataSource>(() => ProductRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetProductDetail(sl()));
  sl.registerFactory(() => ProductCubit(getProductDetail: sl()));

  // ---- Orders (singleton: Checkout appends to the same list the
  // Orders tab reads) ----
  sl.registerLazySingleton<OrdersDataSource>(() => OrdersRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetOrders(sl()));
  sl.registerLazySingleton(() => GetOrder(sl()));
  sl.registerLazySingleton(() => PlaceOrder(sl()));
  // Not loaded eagerly: /orders is JWT-guarded, so pages load it once the
  // user is signed in.
  sl.registerLazySingleton(() => OrdersCubit(getOrders: sl(), getOrder: sl(), placeOrder: sl()));

  // ---- Fit / measurement profiles (singleton: Account's row count
  // reads the same list the My Fit tab loads) ----
  sl.registerLazySingleton<FitDataSource>(() => FitRemoteDataSourceImpl(sl()));
  sl.registerLazySingleton<FitRepository>(() => FitRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetMeasurementProfiles(sl()));
  sl.registerLazySingleton(() => CreateMeasurementProfile(sl()));
  sl.registerLazySingleton(() => SubmitMeasurement(sl()));
  // Not loaded eagerly: /fit is JWT-guarded, so pages load it once signed in.
  sl.registerLazySingleton(() => FitCubit(getMeasurementProfiles: sl(), createMeasurementProfile: sl()));
}
