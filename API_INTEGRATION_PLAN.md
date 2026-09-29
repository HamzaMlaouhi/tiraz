# Tiraz — API Integration Plan

Backend: `tiraz-backend` (NestJS + Prisma + Postgres), run with `npm run start:dev` → `http://localhost:3000`.
App base URL comes from `lib/core/network/api_config.dart` (override with `--dart-define=API_BASE_URL=...`).

**Auth:** A global `JwtAuthGuard` protects every route except the ones marked 🌐 Public. The app sends
`Authorization: Bearer <token>` automatically through `ApiClient`.
🏪 Seller means the route also needs `SellerGuard`, so the user must have a seller profile (`POST /sellers/me`).

**Pattern per feature** (same as auth/home/product): `data/datasources/*_remote_data_source.dart` →
`data/repositories/*_repository_impl.dart` → `domain/usecases` → cubit, wired in `lib/core/di/injection_container.dart`.
All calls go through `guardApiCall` so errors surface as `ServerException` → `Failure`.

Status legend: ✅ done · ⏳ in progress · ⬜ todo · ➖ intentionally not used (reason given)

---

## 0. Health
| Status | Method | Path | Notes |
|---|---|---|---|
| ✅ | GET | `/` 🌐 | `{status, service}` (server check) |

## 1. Auth — `features/auth`
| Status | Method | Path | Body | Used by |
|---|---|---|---|---|
| ✅ | POST | `/auth/otp/request` 🌐 | `{phone: "5XXXXXXXX" (9 digits), emirate: AuthEmirate}` | AuthPage |
| ✅ | POST | `/auth/otp/verify` 🌐 | `{challengeId: uuid, code: "1234"}` → token + user | OtpPage |

## 2. Home & Catalog
| Status | Method | Path | Query/Body | Used by |
|---|---|---|---|---|
| ✅ | GET | `/home` 🌐 | – | HomePage |
| ✅ | GET | `/products/:id` 🌐 | – | ProductPage |
| ✅ | GET | `/products` 🌐 | `?search=&sellerId=` | Home search bar, StoreSheet full catalog |
| ➖ | GET | `/stores` 🌐 | – | Not needed: `/home` already returns every store with the same DTO |
| ➖ | GET | `/stores/:id` 🌐 | – | Not needed: StoreSheet already has the store from `/home`; its catalog comes from `/products?sellerId=` |

## 3. User profile — `features/account`
| Status | Method | Path | Body | Used by |
|---|---|---|---|---|
| ✅ | GET | `/users/me` | – → `{id, phone, emirate, name, createdAt}` | ProfilePage |
| ✅ | PATCH | `/users/me` | `{name?, emirate?}` | ProfilePage (edit) |

## 4. Wishlist — `features/wishlist`
| Status | Method | Path | Body | Used by |
|---|---|---|---|---|
| ✅ | GET | `/wishlist` | – | WishlistPage |
| ✅ | POST | `/wishlist` | `{productId}` | ProductPage heart |
| ✅ | DELETE | `/wishlist/:id` | – (204) | WishlistPage / heart |

## 5. Addresses — `features/addresses`
| Status | Method | Path | Body | Used by |
|---|---|---|---|---|
| ✅ | GET | `/addresses` | – | AddressesPage, Checkout |
| ✅ | POST | `/addresses` | `{label:{ar,en}, line:{ar,en}}` | AddressesPage |
| ✅ | PATCH | `/addresses/:id` | `{label?, line?}` | AddressesPage |
| ✅ | DELETE | `/addresses/:id` | – (204) | AddressesPage |
| ✅ | PATCH | `/addresses/:id/default` | – | AddressesPage |

## 6. Cart — `features/cart`
| Status | Method | Path | Body | Used by |
|---|---|---|---|---|
| ✅ | GET | `/cart` | – | CartPage |
| ✅ | POST | `/cart/items` | `{productId, variant?:{ar,en}}` **or** raw `{seller, leadLabel, itemName, variant, priceAed}` | ProductPage "add to cart" |
| ✅ | POST | `/cart/items/batch` | `{items: [AddCartItem, ...]}` | FamilySetPage |
| ✅ | DELETE | `/cart/items/:id` | – (204) | CartPage |
| ✅ | PATCH | `/cart/gift-wrap` | `{giftWrap: bool}` | CartPage |
| ✅ | DELETE | `/cart` | – (204) | after checkout / clear |

## 7. Orders & Checkout — `features/orders`, `features/checkout`
| Status | Method | Path | Body | Used by |
|---|---|---|---|---|
| ✅ | GET | `/orders` | – | OrdersListPage |
| ✅ | GET | `/orders/:id` | – | OrderDetailPage (timeline) |
| ✅ | POST | `/orders` | `{addressId, paymentMethod: applePay\|bankCard\|tabby\|cod}` | CheckoutPage |
| ✅ | POST | `/orders/:id/review` | `{rating: 1–5, comment?}` (delivered orders, once) | OrderDetailPage review card |

## 8. Wallet — `features/wallet`
| Status | Method | Path | Body | Used by |
|---|---|---|---|---|
| ✅ | GET | `/wallet` | – → balance + transactions | WalletPage |

## 9. Fit / Measurement profiles — `features/fit`
| Status | Method | Path | Body | Used by |
|---|---|---|---|---|
| ✅ | GET | `/fit/profiles` | – | MeasurementProfilesPage |
| ✅ | POST | `/fit/profiles` | `{name:{ar,en}}` | MeasurementProfilesPage (add) |
| ✅ | POST | `/fit/profiles/:id/measurements` | `{key, valueCm}` | MeasurementEntryPage |

## 10. Seller mode — `features/seller`
| Status | Method | Path | Body | Used by |
|---|---|---|---|---|
| ✅ | GET | `/sellers/me` 🏪 | – | SellerAccountPage / Dashboard |
| ✅ | POST | `/sellers/me` | `{nameAr?, nameEn?, emirateAr?, emirateEn?}` (201 created / 200 updated) | RolePicker → become seller, SellerAccountPage |
| ✅ | GET | `/sellers/products` 🏪 | – | SellerProductsPage |
| ✅ | GET | `/sellers/products/:id` 🏪 | – | SellerProductDetailPage |
| ✅ | POST | `/sellers/products` 🏪 | `{name, description, priceAed, isMadeToMeasure, isHandmade, handmadeExtraCostAed, lengthCm, chestCm, sleeveCm, quality, imageUrl}` | AddProductPage |
| ✅ | DELETE | `/sellers/products/:id` 🏪 | – (204) | SellerProductDetailPage |
| ✅ | POST | `/uploads/product-image` 🏪 | multipart field `file` (≤5 MB) → `{imageUrl}` | AddProductPage (image_picker) |

## 11. Market events — `features/seller` (events)
| Status | Method | Path | Body | Used by |
|---|---|---|---|---|
| ✅ | GET | `/events` 🌐 (optional JWT → personalised `reserved` flag) | – | SellerEventsPage |
| ✅ | GET | `/events/:id` 🌐 (optional JWT) | – | EventDetailPage |
| ✅ | POST | `/events/:id/reservations` 🏪 | – | EventDetailPage "attend" |
| ✅ | DELETE | `/events/:id/reservations` 🏪 | – (204) | EventDetailPage "cancel" |

---

## Integration order
1. Users `/users/me` (profile)
2. Wishlist
3. Addresses
4. Cart
5. Orders + Checkout (depends on Cart + Addresses)
6. Wallet
7. Fit profiles
8. Catalog: `/products` search, `/stores`
9. Seller: `/sellers/me` → uploads → seller products
10. Events + reservations

Total: **43 endpoints** (including health): **41 wired**, 2 intentionally unused (`/stores`, `/stores/:id` — see §2).

## Backend changes made during integration (tiraz-backend, uncommitted)
- `wishlist.service.ts` — DTO now includes `productId` (needed for the product-page heart / un-save).
- `addresses.service.ts` — deleting the default address promotes the oldest remaining one (keeps "exactly one default").
- `cart` DTO + service — optional `mode: 'rtw' | 'mtm'` on `POST /cart/items`; MTM lines are now charged `priceMtmAed` instead of the RTW price. Omitting it keeps the old behaviour.

## Features added after the integration
- **Recently viewed** (app only, shared_preferences) and **Share a product** (share_plus 10.x).
- **Eid order-by dates** — `GET /products/:id` returns `eidDeadline.{rtw,mtm}`; shown as a pill on the product page.
- **Reviews after delivery** — `OrderReview` table, `POST /orders/:id/review`, order DTO gains `review` + `canReview`. Ratings fold into product/seller aggregates.
- **Honest delivery dates** — cart/order items store `leadDays`; order ETA = slowest item's production + 2 days; `GET /cart` returns `delivery` (ETA + `beforeEid`) for the checkout banner.
- **Shipping in totals** — orders store `totalAed` incl. the 20 AED fee; `GET /cart` returns `subtotalAed`/`shippingAed`/`totalAed`.
- Test-deployment flags: `OTP_TEST_CODE`, `SEED_ONLY_IF_EMPTY`, `ORDER_AUTO_DELIVER_MINUTES`.

## Known issues / follow-ups
- `POST /uploads/product-image` returns `http://localhost:<port>/…`, which fails the create-product `@IsUrl()` check and doesn't resolve on emulators/devices. The app rewrites the host to the API host (loopback → `127.0.0.1`) in `seller_remote_data_source.dart`. A backend fix (echo the request host, `@IsUrl({ require_tld: false })`) was proposed but not applied.
- `GET /sellers/me` answers 403 (not 404) when there is no store; the app falls back to `POST /sellers/me`.
- Seller mode needs a signed-in user (every seller route is JWT-guarded), but the auth page still offers "browse as guest" after picking the seller role — that path ends on a dashboard error.
- The Eid date is a hard-coded constant (`EID_TARGET_DATE` in `src/common/utils/eid.util.ts`).
- Widget tests run against `test/support/fake_api.dart` (fixtures in `test/fixtures/api`, captured from a freshly seeded server). Re-capture them if the seed data or DTOs change.
