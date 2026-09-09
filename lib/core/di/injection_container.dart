import 'package:get_it/get_it.dart';

import '../../features/addresses/presentation/cubit/addresses_cubit.dart';
import '../../features/auth/data/datasources/auth_local_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/send_otp.dart';
import '../../features/auth/domain/usecases/verify_otp.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/cart/presentation/cubit/cart_cubit.dart';
import '../../features/fit/data/datasources/fit_local_data_source.dart';
import '../../features/fit/data/repositories/fit_repository_impl.dart';
import '../../features/fit/domain/repositories/fit_repository.dart';
import '../../features/fit/domain/usecases/get_measurement_profiles.dart';
import '../../features/fit/presentation/cubit/fit_cubit.dart';
import '../../features/home/data/datasources/home_local_data_source.dart';
import '../../features/home/data/repositories/home_repository_impl.dart';
import '../../features/home/domain/repositories/home_repository.dart';
import '../../features/home/domain/usecases/get_home_data.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/orders/data/datasources/orders_local_data_source.dart';
import '../../features/orders/data/repositories/orders_repository_impl.dart';
import '../../features/orders/domain/repositories/orders_repository.dart';
import '../../features/orders/domain/usecases/get_orders.dart';
import '../../features/orders/presentation/cubit/orders_cubit.dart';
import '../../features/product/data/datasources/product_local_data_source.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/product/domain/usecases/get_product_detail.dart';
import '../../features/product/presentation/cubit/product_cubit.dart';
import '../../features/seller/presentation/cubit/seller_cubit.dart';
import '../../features/wallet/presentation/cubit/wallet_cubit.dart';
import '../../features/wishlist/presentation/cubit/wishlist_cubit.dart';
import '../role/role_cubit.dart';

final sl = GetIt.instance;

/// Wires every layer for every feature: data sources -> repositories ->
/// use cases -> cubits. Call once from `main()` before `runApp`.
Future<void> initDependencies() async {
  // ---- App-wide (shared across tabs, so registered as singletons) ----
  sl.registerLazySingleton(() => CartCubit());
  sl.registerLazySingleton(() => AddressesCubit());
  sl.registerLazySingleton(() => WishlistCubit());
  sl.registerLazySingleton(() => WalletCubit());
  sl.registerLazySingleton(() => RoleCubit());

  // ---- Seller (buyer/seller are both singletons: local, mutable,
  // session-lived state — no repository, like Cart/Wishlist/Wallet) ----
  sl.registerLazySingleton(() => SellerCubit());

  // ---- Auth ----
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));
  sl.registerLazySingleton(() => SendOtp(sl()));
  sl.registerLazySingleton(() => VerifyOtp(sl()));
  // Singleton (not factory): Auth and OTP pages share one flow instance
  // so phone/OTP entry survives the push from /auth to /otp.
  sl.registerLazySingleton(() => AuthCubit(sendOtp: sl(), verifyOtp: sl()));

  // ---- Home ----
  sl.registerLazySingleton<HomeLocalDataSource>(() => HomeLocalDataSourceImpl());
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetHomeData(sl()));
  sl.registerFactory(() => HomeCubit(getHomeData: sl()));

  // ---- Product ----
  sl.registerLazySingleton<ProductLocalDataSource>(() => ProductLocalDataSourceImpl());
  sl.registerLazySingleton<ProductRepository>(() => ProductRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetProductDetail(sl()));
  sl.registerFactory(() => ProductCubit(getProductDetail: sl()));

  // ---- Orders (singleton: Checkout appends to the same list the
  // Orders tab reads) ----
  sl.registerLazySingleton<OrdersLocalDataSource>(() => OrdersLocalDataSourceImpl());
  sl.registerLazySingleton<OrdersRepository>(() => OrdersRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetOrders(sl()));
  sl.registerLazySingleton(() => OrdersCubit(getOrders: sl())..load());

  // ---- Fit / measurement profiles (singleton: Account's row count
  // reads the same list the My Fit tab loads) ----
  sl.registerLazySingleton<FitLocalDataSource>(() => FitLocalDataSourceImpl());
  sl.registerLazySingleton<FitRepository>(() => FitRepositoryImpl(sl()));
  sl.registerLazySingleton(() => GetMeasurementProfiles(sl()));
  sl.registerLazySingleton(() => FitCubit(getMeasurementProfiles: sl())..load());
}
