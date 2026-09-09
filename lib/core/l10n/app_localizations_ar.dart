import 'app_localizations.dart';

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'طِراز';

  @override
  String get appNameLatin => 'TIRAZ';

  @override
  String get splashTagline => 'مصمّمات الإمارات — وكل قطعة على مقاسك';

  @override
  String get authWelcome => 'أهلاً بك في طِراز';

  @override
  String get authSubtitle => 'سجّلي الدخول برقم هاتفك — رمز تحقق واحد، دون كلمات مرور.';

  @override
  String get phoneNumberLabel => 'رقم الهاتف';

  @override
  String get phoneHint => '50 123 4567';

  @override
  String get emirateLabel => 'الإمارة';

  @override
  String get emirateDubai => 'دبي';

  @override
  String get emirateAbuDhabi => 'أبوظبي';

  @override
  String get emirateSharjah => 'الشارقة';

  @override
  String get emirateOther => 'أخرى';

  @override
  String get sendCodeCta => 'إرسال رمز التحقق';

  @override
  String get browseAsGuest => 'أو تصفّحي كضيفة';

  @override
  String get otpTitle => 'رمز التحقق';

  @override
  String otpSubtitle(String phone) {
    return 'أرسلنا الرمز إلى ‎+971 $phone';
  }

  @override
  String otpResend(String seconds) {
    return 'إعادة الإرسال خلال 0:$seconds';
  }

  @override
  String get otpVerifyCta => 'تأكيد ومتابعة';

  @override
  String get otpInvalid => 'رمز غير صحيح — حاولي مرة أخرى';

  @override
  String get roleTitle => 'كيف تودّين استخدام طِراز؟';

  @override
  String get roleSubtitle => 'يمكنك التبديل في أي وقت من حسابك.';

  @override
  String get roleBuyerTitle => 'التسوّق';

  @override
  String get roleBuyerSubtitle => 'تصفّحي الجلابيات والقفاطين من مصمّمات الإمارات';

  @override
  String get roleSellerTitle => 'البيع';

  @override
  String get roleSellerSubtitle => 'اعرضي قطعك واحجزي مكانك في أسواق الفعاليات';

  @override
  String get roleContinueCta => 'متابعة';

  @override
  String eidTitle(String days) {
    return 'العيد بعد $days يوماً';
  }

  @override
  String get eidSubtitle => 'آخر موعد لطلبات التفصيل حسب المقاس: 26 يناير';

  @override
  String get eidChip => 'يصل قبل العيد';

  @override
  String get shopByOccasion => 'تسوّقي بالمناسبة';

  @override
  String get newFromDesigners => 'جديد من مصمّماتك';

  @override
  String get mtmBadge => 'تفصيل';

  @override
  String get familySetsTitle => 'أطقم العائلة';

  @override
  String get familySetsSubtitle => 'تصميم واحد لكل العائلة — طلب واحد';

  @override
  String get storesTitle => 'متاجر في أنحاء الإمارات';

  @override
  String get storesSubtitle => 'أتيليهات مستقلة، توصيل لكل إمارة';

  @override
  String get storeSheetProductsTitle => 'من هذا المتجر';

  @override
  String get offersTitle => 'عروض لكِ';

  @override
  String get offersSubtitle => 'عروض محدودة من متاجر طِراز';

  @override
  String get searchHint => 'ابحثي عن جلابية، قفطان، متجر…';

  @override
  String get searchSectionStores => 'المتاجر';

  @override
  String get searchSectionProducts => 'القطع';

  @override
  String searchNoResults(String query) {
    return 'لا نتائج لـ «$query»';
  }

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navMyFit => 'مقاساتي';

  @override
  String get navOrders => 'طلباتي';

  @override
  String get navAccount => 'حسابي';

  @override
  String get readyToWear => 'جاهزة';

  @override
  String get madeToMeasure => 'تفصيل حسب المقاس';

  @override
  String get deliveredTomorrow => 'التوصيل غداً — دبي والشارقة';

  @override
  String get whoIsThisFor => 'لمن هذه القطعة؟';

  @override
  String get profileMe => 'أنا';

  @override
  String get addNewProfile => '+ ملف جديد';

  @override
  String get mtmGuarantee => 'يصل مضموناً قبل 8 فبراير — أو استرداد جزئي';

  @override
  String get mtmAlteration => 'وإن لم تضبط القصّة، التعديل مجاني لدى خيّاط شريك. نتحمّل التكلفة كاملة.';

  @override
  String mtmLeadTime(String seller) {
    return 'مدة التنفيذ: 12 يوم عمل لدى $seller';
  }

  @override
  String get fabricCareTitle => 'القماش والعناية';

  @override
  String get howDidItFit => 'كيف كانت القصّة؟';

  @override
  String addToCartCta(String price) {
    return 'أضيفي إلى السلة · $price';
  }

  @override
  String orderMtmCta(String price) {
    return 'اطلبي التفصيل · $price';
  }

  @override
  String ratingLabel(String rating, String count) {
    return '★ $rating ($count تقييماً)';
  }

  @override
  String get addedToCart => 'أُضيفت إلى السلة';

  @override
  String get comingSoon => 'قريباً';

  @override
  String get comingSoonBody => 'هذه الشاشة قيد الإنشاء في النسخة القادمة.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get genericError => 'حدث خطأ ما — حاولي مرة أخرى';

  @override
  String get switchToEnglish => 'English';

  @override
  String get browseDesigns => 'تصفّحي التصاميم';

  @override
  String get changeLabel => 'تغيير';

  @override
  String get cartTitle => 'السلة';

  @override
  String get cartEmptyMessage => 'سلتك فارغة.';

  @override
  String get cartGiftTitle => 'هدية؟';

  @override
  String get cartGiftSubtitle => 'تغليف وبطاقة، وإخفاء السعر من الفاتورة';

  @override
  String get cartSubtotal => 'المجموع الفرعي';

  @override
  String get cartShipping => 'التوصيل';

  @override
  String get cartTotal => 'المجموع';

  @override
  String get cartCheckoutCta => 'إتمام الشراء';

  @override
  String get checkoutTitle => 'الدفع';

  @override
  String get checkoutEtaTitle => 'يصل قبل العيد — مضمون';

  @override
  String get checkoutEtaSubtitle => 'التفصيل قبل 8 فبراير، والجاهز غداً. تأخّر الموعد يعني استرداداً جزئياً.';

  @override
  String get checkoutPaymentTitle => 'طريقة الدفع';

  @override
  String checkoutPlaceOrderCta(String total) {
    return 'تأكيد الطلب · $total';
  }

  @override
  String get paymentApplePay => 'Apple Pay';

  @override
  String get paymentBankCard => 'بطاقة بنكية';

  @override
  String get paymentBankCardNote => 'فيزا 4421 ••••';

  @override
  String get paymentTabby => 'تابي — 4 دفعات';

  @override
  String get paymentTabbyNote => 'بلا فوائد ولا رسوم';

  @override
  String get paymentCod => 'الدفع عند الاستلام';

  @override
  String get paymentCodNote => '+15 د.إ — للقطع الجاهزة فقط';

  @override
  String get addressesTitle => 'العناوين';

  @override
  String get addressDefaultBadge => 'افتراضي';

  @override
  String get addressAddCta => '+ إضافة عنوان جديد';

  @override
  String get wishlistTitle => 'المفضّلة';

  @override
  String get wishlistEmptyMessage => 'ما من قطع محفوظة بعد.';

  @override
  String get walletTitle => 'المحفظة';

  @override
  String get walletBalanceLabel => 'رصيد الإحالة المتاح';

  @override
  String get walletTip => 'ادعي صديقة واحصلي على 50 درهم لكلٍّ منكما عند أول طلب لها.';

  @override
  String get walletInviteCta => 'نسخ رابط الدعوة';

  @override
  String get walletCopiedMessage => 'تم نسخ الرابط ✓';

  @override
  String get walletHistoryTitle => 'سجلّ الرصيد';

  @override
  String get orderDetailTitle => 'تفاصيل الطلب';

  @override
  String get orderPlacedBanner => 'تم تأكيد طلبك. ستصلك رسالة عند بدء التنفيذ.';

  @override
  String get orderStatusInProduction => 'قيد التنفيذ';

  @override
  String get orderStatusDelivered => 'تم التوصيل';

  @override
  String get orderChatCta => 'محادثة البائعة';

  @override
  String get orderTrackCta => 'تتبّع الشحنة';

  @override
  String get orderGuarantee => 'هذا الطلب مشمول بضمان التعديل المجاني: إن لم تضبط القصّة، نعدّلها لدى خيّاط شريك دون أي تكلفة.';

  @override
  String get fitSubtitle => 'قيسي مرّة واحدة، واطلبي تفصيلاً من أي مصمّمة على طِراز.';

  @override
  String get fitAddProfileCta => '+ إضافة ملف مقاسات';

  @override
  String get fitTip => 'الأسهل؟ قيسي من جلابية مفضّلة مضبوطة المقاس — افرشيها وقيسي خمس نقاط فقط.';

  @override
  String entryStepLabel(String step, String total) {
    return 'الخطوة $step من $total';
  }

  @override
  String get entryBack => 'السابق';

  @override
  String get entryNext => 'التالي';

  @override
  String get measureUnitCm => 'سم';

  @override
  String get measureAltMeasure => 'أو قيسي من ثوب مفضّل بدلاً من ذلك — أسهل بكثير';

  @override
  String get measureIllustrationPlaceholder => 'رسم توضيحي — فيديو الشرح متوفر';

  @override
  String get measureStepShoulderName => 'عرض الكتف';

  @override
  String get measureStepShoulderTip => 'قيسي من طرف الكتف إلى طرفه الآخر عبر الظهر.';

  @override
  String get measureStepBustName => 'محيط الصدر';

  @override
  String get measureStepBustTip => 'لفّي الشريط حول أوسع نقطة، دون شدّ.';

  @override
  String get measureStepWaistName => 'محيط الخصر';

  @override
  String get measureStepWaistTip => 'عند أضيق نقطة، والشريط مستوٍ.';

  @override
  String get familyWhoTitle => 'لمن؟';

  @override
  String get familySetDesignName => 'طقم ياسمين المتطابق';

  @override
  String get familySetSeller => 'بيت الحرير — الشارقة';

  @override
  String get familyTotalLabel => 'المجموع — طلب واحد، توصيل واحد';

  @override
  String get familyOrderCta => 'اطلبي الطقم';

  @override
  String get accountUserName => 'حمزة';

  @override
  String get accountMemberSince => 'عضو منذ 2026 · أبوظبي';

  @override
  String get accountOrdersRow => 'طلباتي';

  @override
  String accountOrdersInProgress(String count) {
    return '$count طلب قيد التنفيذ';
  }

  @override
  String get accountNoOrders => 'لا طلبات بعد';

  @override
  String get accountProfilesRow => 'ملفّات المقاسات';

  @override
  String accountProfilesValue(String count) {
    return '$count ملفّات';
  }

  @override
  String get accountWishlistRow => 'قائمة الأمنيات';

  @override
  String accountWishlistValue(String count) {
    return '$count قطع';
  }

  @override
  String get accountWalletRow => 'المحفظة';

  @override
  String get accountWalletSubtitle => 'رصيد إحالة';

  @override
  String get accountLanguageRow => 'اللغة';

  @override
  String get currentLanguageName => 'العربية';

  @override
  String get accountNotificationsRow => 'الإشعارات';

  @override
  String get accountNotificationsSubtitle => 'صامتة وقت الصلاة والإفطار';

  @override
  String get accountBecomeSellerRow => 'كوني بائعة';

  @override
  String get accountBecomeSellerSubtitle => 'اعرضي قطعك الخاصة على طِراز';

  @override
  String get navSellerHome => 'لوحتي';

  @override
  String get navSellerProducts => 'منتجاتي';

  @override
  String get navSellerEvents => 'الفعاليات';

  @override
  String get sellerDashboardTitle => 'لوحتك';

  @override
  String get sellerYourStoreLabel => 'متجرك';

  @override
  String get sellerProductsPreviewTitle => 'منتجاتك';

  @override
  String get sellerEventsPreviewTitle => 'الفعاليات القادمة';

  @override
  String get seeAllCta => 'عرض الكل';

  @override
  String get sellerProductsTitle => 'منتجاتك';

  @override
  String sellerProductsSubtitle(String count) {
    return '$count قطعة معروضة';
  }

  @override
  String get sellerAddProductCta => 'أضيفي منتجًا';

  @override
  String get sellerNoProducts => 'لا منتجات بعد — أضيفي أول قطعة.';

  @override
  String get sellerRemoveProductCta => 'إزالة';

  @override
  String get sellerProductRemoved => 'تمّت إزالة المنتج';

  @override
  String get sellerAddProductTitle => 'إضافة منتج';

  @override
  String get sellerProductNameLabel => 'اسم المنتج';

  @override
  String get sellerProductNameHint => 'مثال: جلابية أمل';

  @override
  String get sellerPriceLabel => 'السعر (د.إ)';

  @override
  String get sellerPriceHint => '0';

  @override
  String get sellerProductTypeLabel => 'النوع';

  @override
  String get sellerSaveProductCta => 'حفظ المنتج';

  @override
  String get sellerProductAdded => 'أُضيف إلى متجرك';

  @override
  String get sellerEventsTitle => 'أسواق الفعاليات';

  @override
  String get sellerEventsSubtitle => 'احجزي مكانًا لعرض قطعك حضوريًا';

  @override
  String get sellerYourReservationsTitle => 'حجوزاتك';

  @override
  String get sellerNoReservations => 'لا حجوزات بعد.';

  @override
  String get sellerReserveCta => 'احجزي مكانك';

  @override
  String get sellerReservedLabel => 'محجوز';

  @override
  String get sellerCancelReservationCta => 'إلغاء الحجز';

  @override
  String sellerSlotsLeft(String count) {
    return '$count مكان متبقٍ';
  }

  @override
  String get sellerSlotsFull => 'اكتمل الحجز';

  @override
  String get sellerEventFreeLabel => 'الانضمام مجاني';

  @override
  String get sellerEventFeeLabel => 'رسوم المشاركة';

  @override
  String get sellerEventTimeLabel => 'الوقت';

  @override
  String get sellerEventAttendeesLabel => 'الحضور المتوقّع';

  @override
  String sellerEventAttendeesCount(String count) {
    return 'يحضرها $count شخص';
  }

  @override
  String get sellerAccountTitle => 'حساب البائع';

  @override
  String get sellerSwitchToBuyingCta => 'التبديل إلى التسوّق';

  @override
  String get sellerSwitchToBuyingSubtitle => 'عودي للتسوّق كمشترية';
}
