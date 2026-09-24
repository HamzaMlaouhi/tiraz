import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'طِراز'**
  String get appName;

  /// No description provided for @appNameLatin.
  ///
  /// In ar, this message translates to:
  /// **'TIRAZ'**
  String get appNameLatin;

  /// No description provided for @splashTagline.
  ///
  /// In ar, this message translates to:
  /// **'مصمّمات الإمارات — وكل قطعة على مقاسك'**
  String get splashTagline;

  /// No description provided for @authWelcome.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بك في طِراز'**
  String get authWelcome;

  /// No description provided for @authSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اكتشفي أحدث العبايات وتصاميم الأزياء'**
  String get authSubtitle;

  /// No description provided for @authFormSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أدخلي رقم هاتفك لتسجيل الدخول أو إنشاء حساب'**
  String get authFormSubtitle;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In ar, this message translates to:
  /// **'رقم الهاتف'**
  String get phoneNumberLabel;

  /// No description provided for @phoneHint.
  ///
  /// In ar, this message translates to:
  /// **'50 123 4567'**
  String get phoneHint;

  /// No description provided for @emirateLabel.
  ///
  /// In ar, this message translates to:
  /// **'الإمارة'**
  String get emirateLabel;

  /// No description provided for @emirateDubai.
  ///
  /// In ar, this message translates to:
  /// **'دبي'**
  String get emirateDubai;

  /// No description provided for @emirateAbuDhabi.
  ///
  /// In ar, this message translates to:
  /// **'أبوظبي'**
  String get emirateAbuDhabi;

  /// No description provided for @emirateSharjah.
  ///
  /// In ar, this message translates to:
  /// **'الشارقة'**
  String get emirateSharjah;

  /// No description provided for @emirateOther.
  ///
  /// In ar, this message translates to:
  /// **'أخرى'**
  String get emirateOther;

  /// No description provided for @sendCodeCta.
  ///
  /// In ar, this message translates to:
  /// **'إرسال رمز التحقق'**
  String get sendCodeCta;

  /// No description provided for @browseAsGuest.
  ///
  /// In ar, this message translates to:
  /// **'أو تصفّحي كضيفة'**
  String get browseAsGuest;

  /// No description provided for @otpTitle.
  ///
  /// In ar, this message translates to:
  /// **'رمز التحقق'**
  String get otpTitle;

  /// No description provided for @otpSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا الرمز إلى ‎+971 {phone}'**
  String otpSubtitle(String phone);

  /// No description provided for @otpResend.
  ///
  /// In ar, this message translates to:
  /// **'إعادة الإرسال خلال 0:{seconds}'**
  String otpResend(String seconds);

  /// No description provided for @otpVerifyCta.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد ومتابعة'**
  String get otpVerifyCta;

  /// No description provided for @otpInvalid.
  ///
  /// In ar, this message translates to:
  /// **'رمز غير صحيح — حاولي مرة أخرى'**
  String get otpInvalid;

  /// No description provided for @roleTitle.
  ///
  /// In ar, this message translates to:
  /// **'كيف تودّين استخدام طِراز؟'**
  String get roleTitle;

  /// No description provided for @roleSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك التبديل في أي وقت من حسابك.'**
  String get roleSubtitle;

  /// No description provided for @roleBuyerTitle.
  ///
  /// In ar, this message translates to:
  /// **'التسوّق'**
  String get roleBuyerTitle;

  /// No description provided for @roleBuyerSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تصفّحي الجلابيات والقفاطين من مصمّمات الإمارات'**
  String get roleBuyerSubtitle;

  /// No description provided for @roleSellerTitle.
  ///
  /// In ar, this message translates to:
  /// **'البيع'**
  String get roleSellerTitle;

  /// No description provided for @roleSellerSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اعرضي قطعك واحجزي مكانك في أسواق الفعاليات'**
  String get roleSellerSubtitle;

  /// No description provided for @roleContinueCta.
  ///
  /// In ar, this message translates to:
  /// **'متابعة'**
  String get roleContinueCta;

  /// No description provided for @eidTitle.
  ///
  /// In ar, this message translates to:
  /// **'العيد بعد {days} يوماً'**
  String eidTitle(String days);

  /// No description provided for @eidSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'آخر موعد لطلبات التفصيل حسب المقاس: 26 يناير'**
  String get eidSubtitle;

  /// No description provided for @eidChip.
  ///
  /// In ar, this message translates to:
  /// **'يصل قبل العيد'**
  String get eidChip;

  /// No description provided for @shopByOccasion.
  ///
  /// In ar, this message translates to:
  /// **'تسوّقي بالمناسبة'**
  String get shopByOccasion;

  /// No description provided for @newFromDesigners.
  ///
  /// In ar, this message translates to:
  /// **'جديد من مصمّماتك'**
  String get newFromDesigners;

  /// No description provided for @mtmBadge.
  ///
  /// In ar, this message translates to:
  /// **'تفصيل'**
  String get mtmBadge;

  /// No description provided for @familySetsTitle.
  ///
  /// In ar, this message translates to:
  /// **'أطقم العائلة'**
  String get familySetsTitle;

  /// No description provided for @familySetsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تصميم واحد لكل العائلة — طلب واحد'**
  String get familySetsSubtitle;

  /// No description provided for @storesTitle.
  ///
  /// In ar, this message translates to:
  /// **'متاجر في أنحاء الإمارات'**
  String get storesTitle;

  /// No description provided for @storesSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أتيليهات مستقلة، توصيل لكل إمارة'**
  String get storesSubtitle;

  /// No description provided for @storeSheetProductsTitle.
  ///
  /// In ar, this message translates to:
  /// **'من هذا المتجر'**
  String get storeSheetProductsTitle;

  /// No description provided for @offersTitle.
  ///
  /// In ar, this message translates to:
  /// **'عروض لكِ'**
  String get offersTitle;

  /// No description provided for @offersSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'عروض محدودة من متاجر طِراز'**
  String get offersSubtitle;

  /// No description provided for @searchHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحثي عن جلابية، قفطان، متجر…'**
  String get searchHint;

  /// No description provided for @searchSectionStores.
  ///
  /// In ar, this message translates to:
  /// **'المتاجر'**
  String get searchSectionStores;

  /// No description provided for @searchSectionProducts.
  ///
  /// In ar, this message translates to:
  /// **'القطع'**
  String get searchSectionProducts;

  /// No description provided for @searchNoResults.
  ///
  /// In ar, this message translates to:
  /// **'لا نتائج لـ «{query}»'**
  String searchNoResults(String query);

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @navMyFit.
  ///
  /// In ar, this message translates to:
  /// **'مقاساتي'**
  String get navMyFit;

  /// No description provided for @navOrders.
  ///
  /// In ar, this message translates to:
  /// **'طلباتي'**
  String get navOrders;

  /// No description provided for @navAccount.
  ///
  /// In ar, this message translates to:
  /// **'حسابي'**
  String get navAccount;

  /// No description provided for @readyToWear.
  ///
  /// In ar, this message translates to:
  /// **'جاهزة'**
  String get readyToWear;

  /// No description provided for @madeToMeasure.
  ///
  /// In ar, this message translates to:
  /// **'تفصيل حسب المقاس'**
  String get madeToMeasure;

  /// No description provided for @deliveredTomorrow.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل غداً — دبي والشارقة'**
  String get deliveredTomorrow;

  /// No description provided for @whoIsThisFor.
  ///
  /// In ar, this message translates to:
  /// **'لمن هذه القطعة؟'**
  String get whoIsThisFor;

  /// No description provided for @profileMe.
  ///
  /// In ar, this message translates to:
  /// **'أنا'**
  String get profileMe;

  /// No description provided for @addNewProfile.
  ///
  /// In ar, this message translates to:
  /// **'+ ملف جديد'**
  String get addNewProfile;

  /// No description provided for @mtmGuarantee.
  ///
  /// In ar, this message translates to:
  /// **'يصل مضموناً قبل 8 فبراير — أو استرداد جزئي'**
  String get mtmGuarantee;

  /// No description provided for @mtmAlteration.
  ///
  /// In ar, this message translates to:
  /// **'وإن لم تضبط القصّة، التعديل مجاني لدى خيّاط شريك. نتحمّل التكلفة كاملة.'**
  String get mtmAlteration;

  /// No description provided for @mtmLeadTime.
  ///
  /// In ar, this message translates to:
  /// **'مدة التنفيذ: 12 يوم عمل لدى {seller}'**
  String mtmLeadTime(String seller);

  /// No description provided for @fabricCareTitle.
  ///
  /// In ar, this message translates to:
  /// **'القماش والعناية'**
  String get fabricCareTitle;

  /// No description provided for @howDidItFit.
  ///
  /// In ar, this message translates to:
  /// **'كيف كانت القصّة؟'**
  String get howDidItFit;

  /// No description provided for @addToCartCta.
  ///
  /// In ar, this message translates to:
  /// **'أضيفي إلى السلة · {price}'**
  String addToCartCta(String price);

  /// No description provided for @orderMtmCta.
  ///
  /// In ar, this message translates to:
  /// **'اطلبي التفصيل · {price}'**
  String orderMtmCta(String price);

  /// No description provided for @ratingLabel.
  ///
  /// In ar, this message translates to:
  /// **'★ {rating} ({count} تقييماً)'**
  String ratingLabel(String rating, String count);

  /// No description provided for @addedToCart.
  ///
  /// In ar, this message translates to:
  /// **'أُضيفت إلى السلة'**
  String get addedToCart;

  /// No description provided for @comingSoon.
  ///
  /// In ar, this message translates to:
  /// **'قريباً'**
  String get comingSoon;

  /// No description provided for @comingSoonBody.
  ///
  /// In ar, this message translates to:
  /// **'هذه الشاشة قيد الإنشاء في النسخة القادمة.'**
  String get comingSoonBody;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @genericError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ ما — حاولي مرة أخرى'**
  String get genericError;

  /// No description provided for @switchToEnglish.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get switchToEnglish;

  /// No description provided for @browseDesigns.
  ///
  /// In ar, this message translates to:
  /// **'تصفّحي التصاميم'**
  String get browseDesigns;

  /// No description provided for @changeLabel.
  ///
  /// In ar, this message translates to:
  /// **'تغيير'**
  String get changeLabel;

  /// No description provided for @cartTitle.
  ///
  /// In ar, this message translates to:
  /// **'السلة'**
  String get cartTitle;

  /// No description provided for @cartEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'سلتك فارغة.'**
  String get cartEmptyMessage;

  /// No description provided for @cartGiftTitle.
  ///
  /// In ar, this message translates to:
  /// **'هدية؟'**
  String get cartGiftTitle;

  /// No description provided for @cartGiftSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تغليف وبطاقة، وإخفاء السعر من الفاتورة'**
  String get cartGiftSubtitle;

  /// No description provided for @cartSubtotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع الفرعي'**
  String get cartSubtotal;

  /// No description provided for @cartShipping.
  ///
  /// In ar, this message translates to:
  /// **'التوصيل'**
  String get cartShipping;

  /// No description provided for @cartTotal.
  ///
  /// In ar, this message translates to:
  /// **'المجموع'**
  String get cartTotal;

  /// No description provided for @cartCheckoutCta.
  ///
  /// In ar, this message translates to:
  /// **'إتمام الشراء'**
  String get cartCheckoutCta;

  /// No description provided for @checkoutTitle.
  ///
  /// In ar, this message translates to:
  /// **'الدفع'**
  String get checkoutTitle;

  /// No description provided for @checkoutEtaTitle.
  ///
  /// In ar, this message translates to:
  /// **'يصل قبل العيد — مضمون'**
  String get checkoutEtaTitle;

  /// No description provided for @checkoutEtaSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'التفصيل قبل 8 فبراير، والجاهز غداً. تأخّر الموعد يعني استرداداً جزئياً.'**
  String get checkoutEtaSubtitle;

  /// No description provided for @checkoutPaymentTitle.
  ///
  /// In ar, this message translates to:
  /// **'طريقة الدفع'**
  String get checkoutPaymentTitle;

  /// No description provided for @checkoutPlaceOrderCta.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد الطلب · {total}'**
  String checkoutPlaceOrderCta(String total);

  /// No description provided for @paymentApplePay.
  ///
  /// In ar, this message translates to:
  /// **'Apple Pay'**
  String get paymentApplePay;

  /// No description provided for @paymentBankCard.
  ///
  /// In ar, this message translates to:
  /// **'بطاقة بنكية'**
  String get paymentBankCard;

  /// No description provided for @paymentBankCardNote.
  ///
  /// In ar, this message translates to:
  /// **'فيزا 4421 ••••'**
  String get paymentBankCardNote;

  /// No description provided for @paymentTabby.
  ///
  /// In ar, this message translates to:
  /// **'تابي — 4 دفعات'**
  String get paymentTabby;

  /// No description provided for @paymentTabbyNote.
  ///
  /// In ar, this message translates to:
  /// **'بلا فوائد ولا رسوم'**
  String get paymentTabbyNote;

  /// No description provided for @paymentCod.
  ///
  /// In ar, this message translates to:
  /// **'الدفع عند الاستلام'**
  String get paymentCod;

  /// No description provided for @paymentCodNote.
  ///
  /// In ar, this message translates to:
  /// **'+15 د.إ — للقطع الجاهزة فقط'**
  String get paymentCodNote;

  /// No description provided for @addressesTitle.
  ///
  /// In ar, this message translates to:
  /// **'العناوين'**
  String get addressesTitle;

  /// No description provided for @addressDefaultBadge.
  ///
  /// In ar, this message translates to:
  /// **'افتراضي'**
  String get addressDefaultBadge;

  /// No description provided for @addressAddCta.
  ///
  /// In ar, this message translates to:
  /// **'+ إضافة عنوان جديد'**
  String get addressAddCta;

  /// No description provided for @wishlistTitle.
  ///
  /// In ar, this message translates to:
  /// **'المفضّلة'**
  String get wishlistTitle;

  /// No description provided for @wishlistEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'ما من قطع محفوظة بعد.'**
  String get wishlistEmptyMessage;

  /// No description provided for @walletTitle.
  ///
  /// In ar, this message translates to:
  /// **'المحفظة'**
  String get walletTitle;

  /// No description provided for @walletBalanceLabel.
  ///
  /// In ar, this message translates to:
  /// **'رصيد الإحالة المتاح'**
  String get walletBalanceLabel;

  /// No description provided for @walletTip.
  ///
  /// In ar, this message translates to:
  /// **'ادعي صديقة واحصلي على 50 درهم لكلٍّ منكما عند أول طلب لها.'**
  String get walletTip;

  /// No description provided for @walletInviteCta.
  ///
  /// In ar, this message translates to:
  /// **'نسخ رابط الدعوة'**
  String get walletInviteCta;

  /// No description provided for @walletCopiedMessage.
  ///
  /// In ar, this message translates to:
  /// **'تم نسخ الرابط ✓'**
  String get walletCopiedMessage;

  /// No description provided for @walletHistoryTitle.
  ///
  /// In ar, this message translates to:
  /// **'سجلّ الرصيد'**
  String get walletHistoryTitle;

  /// No description provided for @orderDetailTitle.
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الطلب'**
  String get orderDetailTitle;

  /// No description provided for @orderPlacedBanner.
  ///
  /// In ar, this message translates to:
  /// **'تم تأكيد طلبك. ستصلك رسالة عند بدء التنفيذ.'**
  String get orderPlacedBanner;

  /// No description provided for @orderStatusInProduction.
  ///
  /// In ar, this message translates to:
  /// **'قيد التنفيذ'**
  String get orderStatusInProduction;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In ar, this message translates to:
  /// **'تم التوصيل'**
  String get orderStatusDelivered;

  /// No description provided for @orderChatCta.
  ///
  /// In ar, this message translates to:
  /// **'محادثة البائعة'**
  String get orderChatCta;

  /// No description provided for @orderTrackCta.
  ///
  /// In ar, this message translates to:
  /// **'تتبّع الشحنة'**
  String get orderTrackCta;

  /// No description provided for @orderGuarantee.
  ///
  /// In ar, this message translates to:
  /// **'هذا الطلب مشمول بضمان التعديل المجاني: إن لم تضبط القصّة، نعدّلها لدى خيّاط شريك دون أي تكلفة.'**
  String get orderGuarantee;

  /// No description provided for @fitSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'قيسي مرّة واحدة، واطلبي تفصيلاً من أي مصمّمة على طِراز.'**
  String get fitSubtitle;

  /// No description provided for @fitAddProfileCta.
  ///
  /// In ar, this message translates to:
  /// **'+ إضافة ملف مقاسات'**
  String get fitAddProfileCta;

  /// No description provided for @fitTip.
  ///
  /// In ar, this message translates to:
  /// **'الأسهل؟ قيسي من جلابية مفضّلة مضبوطة المقاس — افرشيها وقيسي خمس نقاط فقط.'**
  String get fitTip;

  /// No description provided for @entryStepLabel.
  ///
  /// In ar, this message translates to:
  /// **'الخطوة {step} من {total}'**
  String entryStepLabel(String step, String total);

  /// No description provided for @entryBack.
  ///
  /// In ar, this message translates to:
  /// **'السابق'**
  String get entryBack;

  /// No description provided for @entryNext.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get entryNext;

  /// No description provided for @measureUnitCm.
  ///
  /// In ar, this message translates to:
  /// **'سم'**
  String get measureUnitCm;

  /// No description provided for @measureAltMeasure.
  ///
  /// In ar, this message translates to:
  /// **'أو قيسي من ثوب مفضّل بدلاً من ذلك — أسهل بكثير'**
  String get measureAltMeasure;

  /// No description provided for @measureIllustrationPlaceholder.
  ///
  /// In ar, this message translates to:
  /// **'رسم توضيحي — فيديو الشرح متوفر'**
  String get measureIllustrationPlaceholder;

  /// No description provided for @measureStepShoulderName.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكتف'**
  String get measureStepShoulderName;

  /// No description provided for @measureStepShoulderTip.
  ///
  /// In ar, this message translates to:
  /// **'قيسي من طرف الكتف إلى طرفه الآخر عبر الظهر.'**
  String get measureStepShoulderTip;

  /// No description provided for @measureStepBustName.
  ///
  /// In ar, this message translates to:
  /// **'محيط الصدر'**
  String get measureStepBustName;

  /// No description provided for @measureStepBustTip.
  ///
  /// In ar, this message translates to:
  /// **'لفّي الشريط حول أوسع نقطة، دون شدّ.'**
  String get measureStepBustTip;

  /// No description provided for @measureStepWaistName.
  ///
  /// In ar, this message translates to:
  /// **'محيط الخصر'**
  String get measureStepWaistName;

  /// No description provided for @measureStepWaistTip.
  ///
  /// In ar, this message translates to:
  /// **'عند أضيق نقطة، والشريط مستوٍ.'**
  String get measureStepWaistTip;

  /// No description provided for @familyWhoTitle.
  ///
  /// In ar, this message translates to:
  /// **'لمن؟'**
  String get familyWhoTitle;

  /// No description provided for @familySetDesignName.
  ///
  /// In ar, this message translates to:
  /// **'طقم ياسمين المتطابق'**
  String get familySetDesignName;

  /// No description provided for @familySetSeller.
  ///
  /// In ar, this message translates to:
  /// **'بيت الحرير — الشارقة'**
  String get familySetSeller;

  /// No description provided for @familyTotalLabel.
  ///
  /// In ar, this message translates to:
  /// **'المجموع — طلب واحد، توصيل واحد'**
  String get familyTotalLabel;

  /// No description provided for @familyOrderCta.
  ///
  /// In ar, this message translates to:
  /// **'اطلبي الطقم'**
  String get familyOrderCta;

  /// No description provided for @accountUserName.
  ///
  /// In ar, this message translates to:
  /// **'حمزة'**
  String get accountUserName;

  /// No description provided for @accountMemberSince.
  ///
  /// In ar, this message translates to:
  /// **'عضو منذ 2026 · أبوظبي'**
  String get accountMemberSince;

  /// No description provided for @accountOrdersRow.
  ///
  /// In ar, this message translates to:
  /// **'طلباتي'**
  String get accountOrdersRow;

  /// No description provided for @accountOrdersInProgress.
  ///
  /// In ar, this message translates to:
  /// **'{count} طلب قيد التنفيذ'**
  String accountOrdersInProgress(String count);

  /// No description provided for @accountNoOrders.
  ///
  /// In ar, this message translates to:
  /// **'لا طلبات بعد'**
  String get accountNoOrders;

  /// No description provided for @accountProfilesRow.
  ///
  /// In ar, this message translates to:
  /// **'ملفّات المقاسات'**
  String get accountProfilesRow;

  /// No description provided for @accountProfilesValue.
  ///
  /// In ar, this message translates to:
  /// **'{count} ملفّات'**
  String accountProfilesValue(String count);

  /// No description provided for @accountWishlistRow.
  ///
  /// In ar, this message translates to:
  /// **'قائمة الأمنيات'**
  String get accountWishlistRow;

  /// No description provided for @accountWishlistValue.
  ///
  /// In ar, this message translates to:
  /// **'{count} قطع'**
  String accountWishlistValue(String count);

  /// No description provided for @accountWalletRow.
  ///
  /// In ar, this message translates to:
  /// **'المحفظة'**
  String get accountWalletRow;

  /// No description provided for @accountWalletSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'رصيد إحالة'**
  String get accountWalletSubtitle;

  /// No description provided for @accountLanguageRow.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get accountLanguageRow;

  /// No description provided for @currentLanguageName.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get currentLanguageName;

  /// No description provided for @accountNotificationsRow.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get accountNotificationsRow;

  /// No description provided for @accountNotificationsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'صامتة وقت الصلاة والإفطار'**
  String get accountNotificationsSubtitle;

  /// No description provided for @accountBecomeSellerRow.
  ///
  /// In ar, this message translates to:
  /// **'كوني بائعة'**
  String get accountBecomeSellerRow;

  /// No description provided for @accountBecomeSellerSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اعرضي قطعك الخاصة على طِراز'**
  String get accountBecomeSellerSubtitle;

  /// No description provided for @navSellerHome.
  ///
  /// In ar, this message translates to:
  /// **'لوحتي'**
  String get navSellerHome;

  /// No description provided for @navSellerProducts.
  ///
  /// In ar, this message translates to:
  /// **'منتجاتي'**
  String get navSellerProducts;

  /// No description provided for @navSellerEvents.
  ///
  /// In ar, this message translates to:
  /// **'الفعاليات'**
  String get navSellerEvents;

  /// No description provided for @sellerDashboardTitle.
  ///
  /// In ar, this message translates to:
  /// **'لوحتك'**
  String get sellerDashboardTitle;

  /// No description provided for @sellerYourStoreLabel.
  ///
  /// In ar, this message translates to:
  /// **'متجرك'**
  String get sellerYourStoreLabel;

  /// No description provided for @sellerProductsPreviewTitle.
  ///
  /// In ar, this message translates to:
  /// **'منتجاتك'**
  String get sellerProductsPreviewTitle;

  /// No description provided for @sellerEventsPreviewTitle.
  ///
  /// In ar, this message translates to:
  /// **'الفعاليات القادمة'**
  String get sellerEventsPreviewTitle;

  /// No description provided for @seeAllCta.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get seeAllCta;

  /// No description provided for @sellerProductsTitle.
  ///
  /// In ar, this message translates to:
  /// **'منتجاتك'**
  String get sellerProductsTitle;

  /// No description provided for @sellerProductsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'{count} قطعة معروضة'**
  String sellerProductsSubtitle(String count);

  /// No description provided for @sellerAddProductCta.
  ///
  /// In ar, this message translates to:
  /// **'أضيفي منتجًا'**
  String get sellerAddProductCta;

  /// No description provided for @sellerNoProducts.
  ///
  /// In ar, this message translates to:
  /// **'لا منتجات بعد — أضيفي أول قطعة.'**
  String get sellerNoProducts;

  /// No description provided for @sellerRemoveProductCta.
  ///
  /// In ar, this message translates to:
  /// **'إزالة'**
  String get sellerRemoveProductCta;

  /// No description provided for @sellerProductRemoved.
  ///
  /// In ar, this message translates to:
  /// **'تمّت إزالة المنتج'**
  String get sellerProductRemoved;

  /// No description provided for @sellerAddProductTitle.
  ///
  /// In ar, this message translates to:
  /// **'إضافة منتج'**
  String get sellerAddProductTitle;

  /// No description provided for @sellerProductNameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم المنتج'**
  String get sellerProductNameLabel;

  /// No description provided for @sellerProductNameHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: جلابية أمل'**
  String get sellerProductNameHint;

  /// No description provided for @sellerPriceLabel.
  ///
  /// In ar, this message translates to:
  /// **'السعر (د.إ)'**
  String get sellerPriceLabel;

  /// No description provided for @sellerPriceHint.
  ///
  /// In ar, this message translates to:
  /// **'0'**
  String get sellerPriceHint;

  /// No description provided for @sellerProductTypeLabel.
  ///
  /// In ar, this message translates to:
  /// **'النوع'**
  String get sellerProductTypeLabel;

  /// No description provided for @sellerSaveProductCta.
  ///
  /// In ar, this message translates to:
  /// **'حفظ المنتج'**
  String get sellerSaveProductCta;

  /// No description provided for @sellerProductAdded.
  ///
  /// In ar, this message translates to:
  /// **'أُضيف إلى متجرك'**
  String get sellerProductAdded;

  /// No description provided for @sellerHandmadeBadge.
  ///
  /// In ar, this message translates to:
  /// **'صناعة يدوية'**
  String get sellerHandmadeBadge;

  /// No description provided for @sellerPhotoLabel.
  ///
  /// In ar, this message translates to:
  /// **'الصورة'**
  String get sellerPhotoLabel;

  /// No description provided for @sellerPhotoGalleryLabel.
  ///
  /// In ar, this message translates to:
  /// **'اختاري نمطًا'**
  String get sellerPhotoGalleryLabel;

  /// No description provided for @sellerPhotoUploadCta.
  ///
  /// In ar, this message translates to:
  /// **'رفع من الجهاز'**
  String get sellerPhotoUploadCta;

  /// No description provided for @sellerPhotoUploadError.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل الصورة — جرّبي غيرها.'**
  String get sellerPhotoUploadError;

  /// No description provided for @sellerDetailsLabel.
  ///
  /// In ar, this message translates to:
  /// **'التفاصيل'**
  String get sellerDetailsLabel;

  /// No description provided for @sellerDetailsHint.
  ///
  /// In ar, this message translates to:
  /// **'القماش، القصّة، تعليمات العناية…'**
  String get sellerDetailsHint;

  /// No description provided for @sellerDimensionsLabel.
  ///
  /// In ar, this message translates to:
  /// **'القياسات (سم)'**
  String get sellerDimensionsLabel;

  /// No description provided for @sellerLengthLabel.
  ///
  /// In ar, this message translates to:
  /// **'الطول'**
  String get sellerLengthLabel;

  /// No description provided for @sellerChestLabel.
  ///
  /// In ar, this message translates to:
  /// **'الصدر'**
  String get sellerChestLabel;

  /// No description provided for @sellerSleeveLabel.
  ///
  /// In ar, this message translates to:
  /// **'الكم'**
  String get sellerSleeveLabel;

  /// No description provided for @sellerHandmadeToggleLabel.
  ///
  /// In ar, this message translates to:
  /// **'قطعة مصنوعة يدويًا'**
  String get sellerHandmadeToggleLabel;

  /// No description provided for @sellerHandmadeToggleSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'تضيف تكلفة إضافية مقابل الصنعة اليدوية'**
  String get sellerHandmadeToggleSubtitle;

  /// No description provided for @sellerHandmadeExtraCostLabel.
  ///
  /// In ar, this message translates to:
  /// **'تكلفة إضافية (د.إ)'**
  String get sellerHandmadeExtraCostLabel;

  /// No description provided for @sellerQualityLabel.
  ///
  /// In ar, this message translates to:
  /// **'الجودة'**
  String get sellerQualityLabel;

  /// No description provided for @sellerQualityStandard.
  ///
  /// In ar, this message translates to:
  /// **'عادية'**
  String get sellerQualityStandard;

  /// No description provided for @sellerQualityPremium.
  ///
  /// In ar, this message translates to:
  /// **'ممتازة'**
  String get sellerQualityPremium;

  /// No description provided for @sellerQualityLuxury.
  ///
  /// In ar, this message translates to:
  /// **'فاخرة'**
  String get sellerQualityLuxury;

  /// No description provided for @sellerBasePriceLabel.
  ///
  /// In ar, this message translates to:
  /// **'السعر الأساسي'**
  String get sellerBasePriceLabel;

  /// No description provided for @sellerHandmadeExtraLabel.
  ///
  /// In ar, this message translates to:
  /// **'إضافة الصنعة اليدوية'**
  String get sellerHandmadeExtraLabel;

  /// No description provided for @sellerTotalPriceLabel.
  ///
  /// In ar, this message translates to:
  /// **'السعر الإجمالي'**
  String get sellerTotalPriceLabel;

  /// No description provided for @sellerEventsTitle.
  ///
  /// In ar, this message translates to:
  /// **'أسواق الفعاليات'**
  String get sellerEventsTitle;

  /// No description provided for @sellerEventsSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'احجزي مكانًا لعرض قطعك حضوريًا'**
  String get sellerEventsSubtitle;

  /// No description provided for @sellerYourReservationsTitle.
  ///
  /// In ar, this message translates to:
  /// **'حجوزاتك'**
  String get sellerYourReservationsTitle;

  /// No description provided for @sellerNoReservations.
  ///
  /// In ar, this message translates to:
  /// **'لا حجوزات بعد.'**
  String get sellerNoReservations;

  /// No description provided for @sellerReserveCta.
  ///
  /// In ar, this message translates to:
  /// **'احجزي مكانك'**
  String get sellerReserveCta;

  /// No description provided for @sellerReservedLabel.
  ///
  /// In ar, this message translates to:
  /// **'محجوز'**
  String get sellerReservedLabel;

  /// No description provided for @sellerCancelReservationCta.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الحجز'**
  String get sellerCancelReservationCta;

  /// No description provided for @sellerSlotsLeft.
  ///
  /// In ar, this message translates to:
  /// **'{count} مكان متبقٍ'**
  String sellerSlotsLeft(String count);

  /// No description provided for @sellerSlotsFull.
  ///
  /// In ar, this message translates to:
  /// **'اكتمل الحجز'**
  String get sellerSlotsFull;

  /// No description provided for @sellerEventFreeLabel.
  ///
  /// In ar, this message translates to:
  /// **'الانضمام مجاني'**
  String get sellerEventFreeLabel;

  /// No description provided for @sellerEventFeeLabel.
  ///
  /// In ar, this message translates to:
  /// **'رسوم المشاركة'**
  String get sellerEventFeeLabel;

  /// No description provided for @sellerEventTimeLabel.
  ///
  /// In ar, this message translates to:
  /// **'الوقت'**
  String get sellerEventTimeLabel;

  /// No description provided for @sellerEventAttendeesLabel.
  ///
  /// In ar, this message translates to:
  /// **'الحضور المتوقّع'**
  String get sellerEventAttendeesLabel;

  /// No description provided for @sellerEventAttendeesCount.
  ///
  /// In ar, this message translates to:
  /// **'يحضرها {count} شخص'**
  String sellerEventAttendeesCount(String count);

  /// No description provided for @sellerAccountTitle.
  ///
  /// In ar, this message translates to:
  /// **'حساب البائع'**
  String get sellerAccountTitle;

  /// No description provided for @sellerSwitchToBuyingCta.
  ///
  /// In ar, this message translates to:
  /// **'التبديل إلى التسوّق'**
  String get sellerSwitchToBuyingCta;

  /// No description provided for @sellerSwitchToBuyingSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'عودي للتسوّق كمشترية'**
  String get sellerSwitchToBuyingSubtitle;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
