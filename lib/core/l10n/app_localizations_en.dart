import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Tiraz';

  @override
  String get appNameLatin => 'TIRAZ';

  @override
  String get splashTagline => 'The UAE’s designers — every piece made to fit';

  @override
  String get authWelcome => 'Welcome to Tiraz';

  @override
  String get authSubtitle => 'Sign in with your phone number — one verification code, no passwords.';

  @override
  String get phoneNumberLabel => 'Phone number';

  @override
  String get phoneHint => '50 123 4567';

  @override
  String get emirateLabel => 'Emirate';

  @override
  String get emirateDubai => 'Dubai';

  @override
  String get emirateAbuDhabi => 'Abu Dhabi';

  @override
  String get emirateSharjah => 'Sharjah';

  @override
  String get emirateOther => 'Other';

  @override
  String get sendCodeCta => 'Send verification code';

  @override
  String get browseAsGuest => 'Or browse as a guest';

  @override
  String get otpTitle => 'Verification code';

  @override
  String otpSubtitle(String phone) {
    return 'We sent the code to +971 $phone';
  }

  @override
  String otpResend(String seconds) {
    return 'Resend in 0:$seconds';
  }

  @override
  String get otpVerifyCta => 'Verify and continue';

  @override
  String get otpInvalid => 'Incorrect code — try again';

  @override
  String eidTitle(String days) {
    return 'Eid is $days days away';
  }

  @override
  String get eidSubtitle => 'Last day for made-to-measure orders: January 26';

  @override
  String get eidChip => 'Arrives before Eid';

  @override
  String get shopByOccasion => 'Shop by occasion';

  @override
  String get newFromDesigners => 'New from your designers';

  @override
  String get mtmBadge => 'MTM';

  @override
  String get familySetsTitle => 'Family sets';

  @override
  String get familySetsSubtitle => 'One design for the whole family — one order';

  @override
  String get storesTitle => 'Stores across the UAE';

  @override
  String get storesSubtitle => 'Independent ateliers, shipping to every emirate';

  @override
  String get storeSheetProductsTitle => 'From this store';

  @override
  String get offersTitle => 'Offers for you';

  @override
  String get offersSubtitle => 'Limited-time deals from Tiraz stores';

  @override
  String get searchHint => 'Search jalabiyas, kaftans, stores…';

  @override
  String get searchSectionStores => 'Stores';

  @override
  String get searchSectionProducts => 'Pieces';

  @override
  String searchNoResults(String query) {
    return 'No matches for “$query”';
  }

  @override
  String get navHome => 'Home';

  @override
  String get navMyFit => 'My fit';

  @override
  String get navOrders => 'Orders';

  @override
  String get navAccount => 'Account';

  @override
  String get readyToWear => 'Ready-to-wear';

  @override
  String get madeToMeasure => 'Made-to-measure';

  @override
  String get deliveredTomorrow => 'Delivered tomorrow — Dubai & Sharjah';

  @override
  String get whoIsThisFor => 'Who is this piece for?';

  @override
  String get profileMe => 'Me';

  @override
  String get addNewProfile => '+ New profile';

  @override
  String get mtmGuarantee => 'Guaranteed before February 8 — or a partial refund';

  @override
  String get mtmAlteration => 'If the fit is off, alteration at a partner tailor is free. We cover the full cost.';

  @override
  String mtmLeadTime(String seller) {
    return 'Lead time: 12 working days at $seller';
  }

  @override
  String get fabricCareTitle => 'Fabric & care';

  @override
  String get howDidItFit => 'How did it fit?';

  @override
  String addToCartCta(String price) {
    return 'Add to cart · $price';
  }

  @override
  String orderMtmCta(String price) {
    return 'Order made-to-measure · $price';
  }

  @override
  String ratingLabel(String rating, String count) {
    return '★ $rating ($count reviews)';
  }

  @override
  String get addedToCart => 'Added to cart';

  @override
  String get comingSoon => 'Coming soon';

  @override
  String get comingSoonBody => 'This screen is being built in the next iteration.';

  @override
  String get retry => 'Retry';

  @override
  String get genericError => 'Something went wrong — please try again';

  @override
  String get switchToEnglish => 'العربية';

  @override
  String get browseDesigns => 'Browse designs';

  @override
  String get changeLabel => 'Change';

  @override
  String get cartTitle => 'Cart';

  @override
  String get cartEmptyMessage => 'Your cart is empty.';

  @override
  String get cartGiftTitle => 'Is this a gift?';

  @override
  String get cartGiftSubtitle => 'Wrapping and a card, with the price hidden';

  @override
  String get cartSubtotal => 'Subtotal';

  @override
  String get cartShipping => 'Delivery';

  @override
  String get cartTotal => 'Total';

  @override
  String get cartCheckoutCta => 'Check out';

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutEtaTitle => 'Arrives before Eid — guaranteed';

  @override
  String get checkoutEtaSubtitle => 'MTM before February 8, ready-to-wear tomorrow. A missed date means a partial refund.';

  @override
  String get checkoutPaymentTitle => 'Payment';

  @override
  String checkoutPlaceOrderCta(String total) {
    return 'Place order · $total';
  }

  @override
  String get paymentApplePay => 'Apple Pay';

  @override
  String get paymentBankCard => 'Bank card';

  @override
  String get paymentBankCardNote => 'Visa •••• 4421';

  @override
  String get paymentTabby => 'Tabby — 4 payments';

  @override
  String get paymentTabbyNote => 'No interest, no fees';

  @override
  String get paymentCod => 'Cash on delivery';

  @override
  String get paymentCodNote => '+AED 15 — ready-to-wear only';

  @override
  String get addressesTitle => 'Addresses';

  @override
  String get addressDefaultBadge => 'Default';

  @override
  String get addressAddCta => '+ Add a new address';

  @override
  String get wishlistTitle => 'Wishlist';

  @override
  String get wishlistEmptyMessage => 'No saved pieces yet.';

  @override
  String get walletTitle => 'Wallet';

  @override
  String get walletBalanceLabel => 'Available referral credit';

  @override
  String get walletTip => 'Invite a friend — you both get AED 50 credit on her first order.';

  @override
  String get walletInviteCta => 'Copy invite link';

  @override
  String get walletCopiedMessage => 'Link copied ✓';

  @override
  String get walletHistoryTitle => 'Credit history';

  @override
  String get orderDetailTitle => 'Order details';

  @override
  String get orderPlacedBanner => 'Your order is confirmed. We will message you when production begins.';

  @override
  String get orderStatusInProduction => 'In production';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderChatCta => 'Message the seller';

  @override
  String get orderTrackCta => 'Track shipment';

  @override
  String get orderGuarantee => 'This order carries the free alteration guarantee: if the fit is off, we alter it at a partner tailor at no cost.';

  @override
  String get fitSubtitle => 'Measure once, then order made-to-measure from any designer on Tiraz.';

  @override
  String get fitAddProfileCta => '+ Add a measurement profile';

  @override
  String get fitTip => 'Easiest way? Measure a favourite, well-fitting jalabiya — lay it flat and measure just five points.';

  @override
  String entryStepLabel(String step, String total) {
    return 'Step $step of $total';
  }

  @override
  String get entryBack => 'Back';

  @override
  String get entryNext => 'Next';

  @override
  String get measureUnitCm => 'cm';

  @override
  String get measureAltMeasure => 'Or measure from a favourite garment instead — much easier';

  @override
  String get measureIllustrationPlaceholder => 'Illustration — how-to video available';

  @override
  String get measureStepShoulderName => 'Shoulder width';

  @override
  String get measureStepShoulderTip => 'Measure from shoulder edge to shoulder edge across the back.';

  @override
  String get measureStepBustName => 'Bust';

  @override
  String get measureStepBustTip => 'Wrap the tape around the fullest point, without pulling tight.';

  @override
  String get measureStepWaistName => 'Waist';

  @override
  String get measureStepWaistTip => 'At the narrowest point, keeping the tape level.';

  @override
  String get familyWhoTitle => 'For whom?';

  @override
  String get familySetDesignName => 'Matching Yasmeen set';

  @override
  String get familySetSeller => 'Silk House — Sharjah';

  @override
  String get familyTotalLabel => 'Total — one order, one delivery';

  @override
  String get familyOrderCta => 'Order the set';

  @override
  String get accountUserName => 'Hamza';

  @override
  String get accountMemberSince => 'Member since 2026 · Abu Dhabi';

  @override
  String get accountOrdersRow => 'My orders';

  @override
  String accountOrdersInProgress(String count) {
    return '$count order in production';
  }

  @override
  String get accountNoOrders => 'No orders yet';

  @override
  String get accountProfilesRow => 'Measurement profiles';

  @override
  String accountProfilesValue(String count) {
    return '$count profiles';
  }

  @override
  String get accountWishlistRow => 'Wishlist';

  @override
  String accountWishlistValue(String count) {
    return '$count pieces';
  }

  @override
  String get accountWalletRow => 'Wallet';

  @override
  String get accountWalletSubtitle => 'Referral credit';

  @override
  String get accountLanguageRow => 'Language';

  @override
  String get currentLanguageName => 'English';

  @override
  String get accountNotificationsRow => 'Notifications';

  @override
  String get accountNotificationsSubtitle => 'Silent during prayer times and iftar';
}
