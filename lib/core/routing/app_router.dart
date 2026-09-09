import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/account/presentation/pages/profile_page.dart';
import '../../features/addresses/presentation/pages/addresses_page.dart';
import '../../features/auth/presentation/pages/auth_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/auth/presentation/pages/role_picker_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/cart/presentation/pages/cart_page.dart';
import '../../features/checkout/presentation/pages/checkout_page.dart';
import '../../features/family/presentation/pages/family_set_page.dart';
import '../../features/fit/presentation/pages/measurement_entry_page.dart';
import '../../features/fit/presentation/pages/measurement_profiles_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/orders/presentation/pages/order_detail_page.dart';
import '../../features/orders/presentation/pages/orders_list_page.dart';
import '../../features/product/presentation/pages/product_page.dart';
import '../../features/seller/presentation/pages/add_product_page.dart';
import '../../features/seller/presentation/pages/event_detail_page.dart';
import '../../features/seller/presentation/pages/seller_account_page.dart';
import '../../features/seller/presentation/pages/seller_dashboard_page.dart';
import '../../features/seller/presentation/pages/seller_events_page.dart';
import '../../features/seller/presentation/pages/seller_product_detail_page.dart';
import '../../features/seller/presentation/pages/seller_products_page.dart';
import '../../features/shell/presentation/pages/app_shell.dart';
import '../../features/wallet/presentation/pages/wallet_page.dart';
import '../../features/wishlist/presentation/pages/wishlist_page.dart';
import '../di/injection_container.dart';
import '../l10n/app_localizations.dart';
import '../role/role_cubit.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _homeBranchKey = GlobalKey<NavigatorState>(debugLabel: 'homeBranch');
final GlobalKey<NavigatorState> _myFitBranchKey = GlobalKey<NavigatorState>(debugLabel: 'myFitBranch');
final GlobalKey<NavigatorState> _ordersBranchKey = GlobalKey<NavigatorState>(debugLabel: 'ordersBranch');
final GlobalKey<NavigatorState> _accountBranchKey = GlobalKey<NavigatorState>(debugLabel: 'accountBranch');
final GlobalKey<NavigatorState> _sellerHomeBranchKey = GlobalKey<NavigatorState>(debugLabel: 'sellerHomeBranch');
final GlobalKey<NavigatorState> _sellerProductsBranchKey =
    GlobalKey<NavigatorState>(debugLabel: 'sellerProductsBranch');
final GlobalKey<NavigatorState> _sellerEventsBranchKey = GlobalKey<NavigatorState>(debugLabel: 'sellerEventsBranch');
final GlobalKey<NavigatorState> _sellerAccountBranchKey = GlobalKey<NavigatorState>(debugLabel: 'sellerAccountBranch');

final GoRouter appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
    GoRoute(path: '/role', builder: (context, state) => const RolePickerPage()),
    GoRoute(path: '/auth', builder: (context, state) => const AuthPage()),
    GoRoute(path: '/otp', builder: (context, state) => const OtpPage()),
    // Reachable from both the seller dashboard and the products tab, so it
    // escapes the seller shell entirely rather than living under one
    // branch's route tree.
    GoRoute(
      path: '/seller/products/add',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => AddProductPage(onBack: () => context.pop(), onSaved: () => context.pop()),
    ),
    // Reachable from both the seller dashboard and the products tab, so —
    // like the routes above — it escapes the seller shell rather than
    // living under one branch's route tree.
    GoRoute(
      path: '/seller/products/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => SellerProductDetailPage(
        productId: state.pathParameters['id']!,
        onBack: () => context.pop(),
      ),
    ),
    // Reachable from both the seller dashboard and the events tab, so —
    // like the add-product route above — it escapes the seller shell
    // rather than living under one branch's route tree.
    GoRoute(
      path: '/seller/events/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => EventDetailPage(
        eventId: state.pathParameters['id']!,
        onBack: () => context.pop(),
      ),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell, tabs: buyerNavTabs(AppLocalizations.of(context))),
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeBranchKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => HomePage(
                onOpenProduct: (id) => context.push('/home/product/$id'),
                onOpenFamilySets: () => context.push('/home/family'),
                onOpenCart: () => context.push('/home/cart'),
              ),
              routes: [
                GoRoute(
                  path: 'product/:id',
                  builder: (context, state) => ProductPage(
                    productId: state.pathParameters['id']!,
                    onBack: () => context.pop(),
                    onOpenCart: () => context.push('/home/cart'),
                  ),
                ),
                GoRoute(
                  path: 'family',
                  builder: (context, state) => FamilySetPage(
                    onBack: () => context.pop(),
                    onOrdered: () => context.push('/home/cart'),
                  ),
                ),
                GoRoute(
                  path: 'cart',
                  builder: (context, state) => CartPage(
                    onBack: () => context.pop(),
                    onBrowse: () => context.go('/home'),
                    onCheckout: () => context.push('/home/cart/checkout'),
                  ),
                  routes: [
                    GoRoute(
                      path: 'checkout',
                      builder: (context, state) => CheckoutPage(
                        onBack: () => context.pop(),
                        onChangeAddress: () => context.push('/home/cart/checkout/addresses'),
                        onOrderPlaced: (orderId) => context.go('/orders/$orderId'),
                      ),
                      routes: [
                        GoRoute(
                          path: 'addresses',
                          builder: (context, state) => AddressesPage(onBack: () => context.pop(), returnOnPick: true),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _myFitBranchKey,
          routes: [
            GoRoute(
              path: '/my-fit',
              builder: (context, state) => MeasurementProfilesPage(
                onOpenEntry: (id, name) => context.push('/my-fit/entry/$id?name=${Uri.encodeComponent(name)}'),
              ),
              routes: [
                GoRoute(
                  path: 'entry/:id',
                  builder: (context, state) => MeasurementEntryPage(
                    profileName: state.uri.queryParameters['name'] ?? '',
                    onBack: () => context.pop(),
                    onDone: () => context.pop(),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _ordersBranchKey,
          routes: [
            GoRoute(
              path: '/orders',
              builder: (context, state) => OrdersListPage(onOpenOrder: (id) => context.push('/orders/$id')),
              routes: [
                GoRoute(
                  path: ':id',
                  builder: (context, state) => OrderDetailPage(
                    orderId: state.pathParameters['id']!,
                    onBack: () => context.pop(),
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _accountBranchKey,
          routes: [
            GoRoute(
              path: '/account',
              builder: (context, state) => ProfilePage(
                onOpenOrders: () => context.go('/orders'),
                onOpenMeasurements: () => context.go('/my-fit'),
                onOpenWishlist: () => context.push('/account/wishlist'),
                onOpenWallet: () => context.push('/account/wallet'),
                onOpenAddresses: () => context.push('/account/addresses'),
                onBecomeSeller: () {
                  sl<RoleCubit>().choose(UserRole.seller);
                  context.go('/seller');
                },
              ),
              routes: [
                GoRoute(
                  path: 'wishlist',
                  builder: (context, state) =>
                      WishlistPage(onBack: () => context.pop(), onBrowse: () => context.go('/home')),
                ),
                GoRoute(
                  path: 'wallet',
                  builder: (context, state) => WalletPage(onBack: () => context.pop()),
                ),
                GoRoute(
                  path: 'addresses',
                  builder: (context, state) => AddressesPage(onBack: () => context.pop()),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell, tabs: sellerNavTabs(AppLocalizations.of(context))),
      branches: [
        StatefulShellBranch(
          navigatorKey: _sellerHomeBranchKey,
          routes: [
            GoRoute(
              path: '/seller',
              builder: (context, state) => SellerDashboardPage(
                onOpenProducts: () => context.go('/seller/products'),
                onOpenEvents: () => context.go('/seller/events'),
                onAddProduct: () => context.push('/seller/products/add'),
                onOpenEventDetail: (id) => context.push('/seller/events/$id'),
                onOpenProductDetail: (id) => context.push('/seller/products/$id'),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _sellerProductsBranchKey,
          routes: [
            GoRoute(
              path: '/seller/products',
              builder: (context, state) => SellerProductsPage(
                onAddProduct: () => context.push('/seller/products/add'),
                onOpenProductDetail: (id) => context.push('/seller/products/$id'),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _sellerEventsBranchKey,
          routes: [
            GoRoute(
              path: '/seller/events',
              builder: (context, state) =>
                  SellerEventsPage(onOpenEventDetail: (id) => context.push('/seller/events/$id')),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _sellerAccountBranchKey,
          routes: [
            GoRoute(
              path: '/seller/account',
              builder: (context, state) => SellerAccountPage(
                onSwitchToBuying: () {
                  sl<RoleCubit>().choose(UserRole.buyer);
                  context.go('/home');
                },
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
