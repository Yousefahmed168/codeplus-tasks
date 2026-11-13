///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsAr with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsAr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ar,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ar>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key);

	late final TranslationsAr _root = this; // ignore: unused_field

	@override 
	TranslationsAr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsAr(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$common$ar common = _Translations$common$ar._(_root);
	@override late final _Translations$onboarding$ar onboarding = _Translations$onboarding$ar._(_root);
	@override late final _Translations$roleSelection$ar roleSelection = _Translations$roleSelection$ar._(_root);
	@override late final _Translations$auth$ar auth = _Translations$auth$ar._(_root);
	@override late final _Translations$home$ar home = _Translations$home$ar._(_root);
	@override late final _Translations$findDoctors$ar findDoctors = _Translations$findDoctors$ar._(_root);
	@override late final _Translations$doctorDetails$ar doctorDetails = _Translations$doctorDetails$ar._(_root);
	@override late final _Translations$favorite$ar favorite = _Translations$favorite$ar._(_root);
	@override late final _Translations$appointment$ar appointment = _Translations$appointment$ar._(_root);
	@override late final _Translations$selectTime$ar selectTime = _Translations$selectTime$ar._(_root);
	@override late final _Translations$review$ar review = _Translations$review$ar._(_root);
	@override late final _Translations$admin$ar admin = _Translations$admin$ar._(_root);
	@override late final _Translations$patientProfile$ar patientProfile = _Translations$patientProfile$ar._(_root);
	@override late final _Translations$patientSettings$ar patientSettings = _Translations$patientSettings$ar._(_root);
	@override late final _Translations$privacyPolicy$ar privacyPolicy = _Translations$privacyPolicy$ar._(_root);
	@override late final _Translations$logoutDialog$ar logoutDialog = _Translations$logoutDialog$ar._(_root);
	@override late final _Translations$menu$ar menu = _Translations$menu$ar._(_root);
	@override late final _Translations$appointments$ar appointments = _Translations$appointments$ar._(_root);
	@override late final _Translations$changePassword$ar changePassword = _Translations$changePassword$ar._(_root);
}

// Path: common
class _Translations$common$ar implements Translations$common$en {
	_Translations$common$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get appName => 'دكتور هانت';
	@override String get email => 'البريد الإلكتروني';
	@override String get password => 'كلمة السر';
	@override String get google => 'جوجل';
	@override String get continueBtn => 'متابعة';
	@override String get skip => 'تخطي';
	@override String get next => 'التالي';
	@override String get getStarted => 'ابدأ الآن';
	@override String get name => 'الاسم';
	@override String get bookNow => 'احجز الآن';
	@override String get nextAvailable => 'أقرب موعد متاح';
	@override String get search => 'بحث';
	@override String get phone => 'رقم الهاتف';
	@override String get confirmPassword => 'تأكيد كلمة السر';
	@override String get logout => 'تسجيل الخروج';
	@override String get ok => 'حسنًا';
	@override String get cancel => 'إلغاء';
	@override String get undo => 'تراجع';
	@override String get notice => 'تنبيه';
	@override String get confirm => 'تأكيد';
	@override String get edit => 'تعديل';
	@override String get delete => 'حذف';
	@override String get tapBackAgainToExit => 'اضغط رجوع مرة أخرى للخروج';
	@override String get loading => 'جارٍ التحميل...';
	@override String get errorGeneric => 'حدث خطأ ما. حاول مرة أخرى';
	@override String get loginRequired => 'سجّل الدخول للمتابعة';
	@override String get language => 'اللغة';
	@override String get languageEnglish => 'English';
	@override String get languageArabic => 'العربية';
	@override String get languageUpdated => 'تم تغيير اللغة';
	@override late final _Translations$common$validation$ar validation = _Translations$common$validation$ar._(_root);
	@override String get notProvided => 'غير مسجل';
	@override String amount({required Object amount}) => '\$${amount}';
}

// Path: onboarding
class _Translations$onboarding$ar implements Translations$onboarding$en {
	_Translations$onboarding$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override List<dynamic> get pages => [
		_Translations$onboarding$pages$0$ar._(_root),
		_Translations$onboarding$pages$1$ar._(_root),
		_Translations$onboarding$pages$2$ar._(_root),
	];
}

// Path: roleSelection
class _Translations$roleSelection$ar implements Translations$roleSelection$en {
	_Translations$roleSelection$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'اختر نوعك';
	@override String get subtitle => 'نوع المستخدم المختار يحدّد التجربة والميزات المتاحة.';
	@override late final _Translations$roleSelection$roles$ar roles = _Translations$roleSelection$roles$ar._(_root);
	@override String get errorNoRole => 'من فضلك اختر نوع المستخدم';
}

// Path: auth
class _Translations$auth$ar implements Translations$auth$en {
	_Translations$auth$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$auth$login$ar login = _Translations$auth$login$ar._(_root);
	@override late final _Translations$auth$register$ar register = _Translations$auth$register$ar._(_root);
	@override String get resetEmailSent => 'تم إرسال بريد استعادة كلمة السر';
	@override String get registrationSuccessful => 'تم إنشاء الحساب بنجاح';
	@override late final _Translations$auth$errors$ar errors = _Translations$auth$errors$ar._(_root);
}

// Path: home
class _Translations$home$ar implements Translations$home$en {
	_Translations$home$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get popularDoctor => 'أشهر الأطباء';
	@override String get topRatedDoctor => 'أعلى الأطباء تقييمًا';
	@override String get specialties => 'التخصصات';
	@override String get allSpecialties => 'الكل';
	@override String get favouriteDoctors => 'الأطباء المفضلين';
	@override String get seeAll => 'عرض الكل';
	@override String get findYourDoctor => 'اعثر على دكتورك';
	@override String greeting({required Object name}) => 'أهلًا، ${name} 👋';
	@override String get searchHint => 'ابحث....';
	@override String get bookNow => 'احجز الآن';
	@override String reviewsCount({required Object count}) => '(${count})';
	@override String get failedToLoadDoctors => 'تعذّر تحميل الأطباء';
	@override String get noDoctorsAvailableYet => 'لا يوجد دكتور متاح حتى الآن';
}

// Path: findDoctors
class _Translations$findDoctors$ar implements Translations$findDoctors$en {
	_Translations$findDoctors$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'بحث الأطباء';
	@override String get searchHint => 'طبيب أسنان';
	@override String get noDoctorsFound => 'لم يتم العثور على أطباء';
	@override String get tryDifferentSearchTerm => 'جرّب كلمة بحث مختلفة';
}

// Path: doctorDetails
class _Translations$doctorDetails$ar implements Translations$doctorDetails$en {
	_Translations$doctorDetails$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'تفاصيل الدكتور';
	@override String get patient => 'المريض';
	@override String get doctorInfo => 'معلومات الدكتور';
	@override String get reviews => 'التقييم';
	@override String get reviewsTitle => 'تقييمات المرضى';
	@override String reviewsCount({required Object count}) => '${count} مراجعة';
	@override String get noReviews => 'لا توجد تقييمات بعد';
	@override String get clinicInfo => 'معلومات العيادة';
	@override String get location => 'الموقع';
	@override String get workingDays => 'أيام العمل';
	@override String get workingHours => 'ساعات العمل';
	@override String get consultationFee => 'سعر الكشفية';
	@override String removedFromFavorites({required Object doctorName}) => 'تم حذف ${doctorName} من المفضلة';
}

// Path: favorite
class _Translations$favorite$ar implements Translations$favorite$en {
	_Translations$favorite$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get pleaseLogin => 'من فضلك سجّل الدخول لعرض المفضلة';
	@override String get noFavoriteDoctors => 'لا يوجد دكتور مفضل بعد';
	@override String get tapHeartHint => 'اضغط أيقونة القلب على أي دكتور لإضافته هنا';
	@override String doctorRemoved({required Object doctorName}) => 'تم حذف ${doctorName} من المفضلة';
	@override String doctorAdded({required Object doctorName}) => 'تم إضافة ${doctorName} إلى المفضلة';
}

// Path: appointment
class _Translations$appointment$ar implements Translations$appointment$en {
	_Translations$appointment$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get successTitle => 'شكرًا ليك !';
	@override String get successSubtitle => 'تم تأكيد حجزك بنجاح';
	@override String successMessage({required Object doctorName, required Object date, required Object time}) => 'لقد حجزت موعدًا مع ${doctorName} يوم ${date} الساعة ${time}';
	@override String get doneBtn => 'تم';
	@override String get editBtn => 'تعديل موعدك';
}

// Path: selectTime
class _Translations$selectTime$ar implements Translations$selectTime$en {
	_Translations$selectTime$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'اختر وقت الموعد';
	@override String today({required Object date}) => 'اليوم، ${date}';
	@override String tomorrow({required Object date}) => 'غدًا، ${date}';
	@override String get noSlotsAvailable => 'لا توجد مواعيد متاحة';
	@override String slotsAvailable({required Object count}) => '${count} موعد متاح';
	@override String afternoonSlots({required Object count}) => 'بعد الظهر: ${count} موعد';
	@override String eveningSlots({required Object count}) => 'المساء: ${count} موعد';
	@override String get proceed => 'متابعة';
	@override String get slotJustBooked => 'تم حجز هذا الموعد للتو. اختر وقتًا آخر.';
	@override String nextAvailabilityOn({required Object date}) => 'أقرب موعد متاح ${date}';
	@override String get noUpcomingDates => 'لا توجد مواعيد قادمة';
	@override String clinicLocationLabel({required Object location}) => 'موقع العيادة: ${location}';
	@override String get or => 'أو';
	@override String get contactClinic => 'تواصل مع العيادة';
}

// Path: review
class _Translations$review$ar implements Translations$review$en {
	_Translations$review$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'مراجعة الحجز';
	@override String get subtitle => 'من فضلك راجع بيانات موعدك';
	@override String get doctor => 'الدكتور';
	@override String get date => 'التاريخ';
	@override String get time => 'الوقت';
	@override String get fee => 'سعر الكشفية';
	@override String get location => 'موقع العيادة';
	@override String get confirm => 'تأكيد الحجز';
	@override String get confirming => 'جارٍ الحجز...';
}

// Path: admin
class _Translations$admin$ar implements Translations$admin$en {
	_Translations$admin$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$admin$chooseRole$ar chooseRole = _Translations$admin$chooseRole$ar._(_root);
	@override late final _Translations$admin$login$ar login = _Translations$admin$login$ar._(_root);
	@override late final _Translations$admin$doctors$ar doctors = _Translations$admin$doctors$ar._(_root);
	@override late final _Translations$admin$createDoctor$ar createDoctor = _Translations$admin$createDoctor$ar._(_root);
	@override late final _Translations$admin$editDoctor$ar editDoctor = _Translations$admin$editDoctor$ar._(_root);
	@override late final _Translations$admin$doctorDetails$ar doctorDetails = _Translations$admin$doctorDetails$ar._(_root);
	@override late final _Translations$admin$availability$ar availability = _Translations$admin$availability$ar._(_root);
	@override late final _Translations$admin$editProfile$ar editProfile = _Translations$admin$editProfile$ar._(_root);
	@override late final _Translations$admin$appointments$ar appointments = _Translations$admin$appointments$ar._(_root);
	@override late final _Translations$admin$settings$ar settings = _Translations$admin$settings$ar._(_root);
}

// Path: patientProfile
class _Translations$patientProfile$ar implements Translations$patientProfile$en {
	_Translations$patientProfile$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الملف الشخصي';
	@override String get personalInfo => 'المعلومات الشخصية';
	@override String get contactNumber => 'رقم الهاتف';
	@override String get dateOfBirth => 'تاريخ الميلاد';
	@override String get gender => 'النوع';
	@override String get male => 'ذكر';
	@override String get female => 'أنثى';
	@override String get profileUpdated => 'تم تحديث بياناتك بنجاح';
	@override String get noProfileData => 'لا توجد بيانات ملف شخصي';
}

// Path: patientSettings
class _Translations$patientSettings$ar implements Translations$patientSettings$en {
	_Translations$patientSettings$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الإعدادات';
	@override String get accountSettings => 'إعدادات الحساب';
	@override String get changePassword => 'تغيير كلمة السر';
	@override String get notifications => 'الإشعارات';
	@override String get privacyPolicy => 'سياسة الخصوصية';
	@override String get moreOptions => 'خيارات أخرى';
	@override String get buildVersion => 'إصدار البناء';
}

// Path: privacyPolicy
class _Translations$privacyPolicy$ar implements Translations$privacyPolicy$en {
	_Translations$privacyPolicy$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'سياسة الخصوصية';
	@override String get heading => 'سياسة خصوصية تطبيقات دكتور هانت';
	@override String get intro => 'تشرح هذه السياسة المعلومات التي يجمعها تطبيق دكتور هانت وكيفية استخدامها والخيارات المتاحة لك. نجمع فقط البيانات اللازمة لتشغيل الخدمة: بيانات حسابك ومعلومات ملفك الشخصي والمواعيد التي تحجزها.';
	@override String get bullet1 => 'لا نبيع أو نشارك بياناتك الشخصية مع أطراف ثالثة.';
	@override String get bullet2 => 'مواعيدك وتقييماتك خاصة بك وللدكتور المعني فقط.';
	@override String get bullet3 => 'يمكنك تعديل أو حذف بيانات ملفك الشخصي في أي وقت.';
	@override String get bullet4 => 'تواصل معنا إذا كان لديك أي سؤال حول بياناتك.';
	@override String get outro => 'باستخدامك تطبيق دكتور هانت، فإنك توافق على هذه السياسة. قد نقوم بتحديثها من وقت لآخر وسنخبرك بأي تغييرات مهمة.';
}

// Path: logoutDialog
class _Translations$logoutDialog$ar implements Translations$logoutDialog$en {
	_Translations$logoutDialog$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'تسجيل الخروج';
	@override String get confirmMessage => 'هل أنت متأكد من تسجيل الخروج؟';
}

// Path: menu
class _Translations$menu$ar implements Translations$menu$en {
	_Translations$menu$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get home => 'الرئيسية';
	@override String get favourites => 'المفضلة';
	@override String get myAppointments => 'مواعيدي';
	@override String get profile => 'الملف الشخصي';
	@override String get settings => 'الإعدادات';
	@override String get logout => 'تسجيل الخروج';
}

// Path: appointments
class _Translations$appointments$ar implements Translations$appointments$en {
	_Translations$appointments$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'المواعيد';
	@override String get upcoming => 'القادمة';
	@override String get completed => 'المنتهية';
	@override String get cancelled => 'الملغاة';
	@override String get patient => 'المريض';
	@override String get appointmentDate => 'تاريخ الموعد';
	@override String get appointmentTime => 'وقت الموعد';
	@override String get consultationFee => 'سعر الكشفية';
	@override String get viewDetails => 'عرض التفاصيل';
	@override String get cancelAppointment => 'إلغاء الموعد';
	@override String get rateDoctor => 'قيّم الدكتور';
	@override String get rateDialogTitle => 'قيّم زيارتك';
	@override String get reviewCommentLabel => 'تعليق (اختياري)';
	@override String get reviewCommentHint => 'شاركنا تجربتك...';
	@override String get submit => 'إرسال';
	@override String get noUpcoming => 'لا توجد مواعيد قادمة';
	@override String get noCompleted => 'لا توجد مواعيد منتهية';
	@override String get noCancelled => 'لا توجد مواعيد ملغاة';
	@override String get cancelConfirmTitle => 'إلغاء الموعد';
	@override String get cancelConfirmMessage => 'هل أنت متأكد من إلغاء هذا الموعد؟';
	@override String get cancelSuccess => 'تم إلغاء الموعد';
	@override String get cancelFailed => 'تعذّر إلغاء الموعد';
	@override String get reviewSuccess => 'شكرًا على تقييمك!';
	@override String get reviewFailed => 'تعذّر إرسال التقييم';
	@override String get bookingFailed => 'تعذّر حجز الموعد';
	@override String get slotUnavailable => 'تم حجز هذا الموعد للتو بواسطة مستخدم آخر. اختر موعدًا مختلفًا.';
	@override String get noUpcomingSubtitle => 'احجز موعدًا مع دكتور ليظهر هنا.';
	@override String get noCompletedSubtitle => 'ستظهر مواعيدك المنتهية هنا.';
	@override String get noCancelledSubtitle => 'ستظهر مواعيدك الملغاة هنا.';
}

// Path: changePassword
class _Translations$changePassword$ar implements Translations$changePassword$en {
	_Translations$changePassword$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'تغيير كلمة السر';
	@override String get currentPassword => 'كلمة السر الحالية';
	@override String get newPassword => 'كلمة السر الجديدة';
	@override String get confirmNewPassword => 'تأكيد كلمة السر الجديدة';
	@override String get updatePassword => 'تحديث كلمة السر';
	@override String get updating => 'جارٍ التحديث...';
	@override String get success => 'تم تحديث كلمة السر بنجاح';
	@override String get failed => 'تعذّر تحديث كلمة السر';
	@override String get currentPasswordRequired => 'من فضلك أدخل كلمة السر الحالية';
}

// Path: common.validation
class _Translations$common$validation$ar implements Translations$common$validation$en {
	_Translations$common$validation$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get enterEmail => 'أدخل بريدك الإلكتروني';
	@override String get validEmail => 'أدخل بريدًا إلكترونيًا صحيحًا';
	@override String get enterPassword => 'أدخل كلمة السر';
	@override String get minPassword => '6 أحرف على الأقل';
	@override String get enterName => 'أدخل اسمك';
	@override String get enterPhone => 'أدخل رقم هاتفك';
	@override String get passwordsDoNotMatch => 'كلمتا السر غير متطابقتين';
	@override String get enterConfirmPassword => 'من فضلك أكّد كلمة السر';
	@override String get selectRole => 'من فضلك اختر نوع المستخدم';
	@override String fieldRequired({required Object field}) => 'من فضلك أدخل ${field}';
	@override String get invalidNumber => 'من فضلك أدخل رقمًا صحيحًا';
	@override String get validPhone => 'أدخل رقم هاتف صحيح';
}

// Path: onboarding.pages.0
class _Translations$onboarding$pages$0$ar implements Translations$onboarding$pages$0$en {
	_Translations$onboarding$pages$0$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ابحث عن أطباء موثوقين';
	@override String get description => 'ابحث بالاسم أو التخصص لتجد الدكتور المناسب لك.';
}

// Path: onboarding.pages.1
class _Translations$onboarding$pages$1$ar implements Translations$onboarding$pages$1$en {
	_Translations$onboarding$pages$1$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'اختر أفضل الأطباء';
	@override String get description => 'قارن التقييمات والرسوم واختر أفضل دكتور بسهولة.';
}

// Path: onboarding.pages.2
class _Translations$onboarding$pages$2$ar implements Translations$onboarding$pages$2$en {
	_Translations$onboarding$pages$2$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'حجز مواعيد سهل';
	@override String get description => 'احجز موعدك في نقرات قليلة وتابعه من مكان واحد.';
}

// Path: roleSelection.roles
class _Translations$roleSelection$roles$ar implements Translations$roleSelection$roles$en {
	_Translations$roleSelection$roles$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$roleSelection$roles$patient$ar patient = _Translations$roleSelection$roles$patient$ar._(_root);
}

// Path: auth.login
class _Translations$auth$login$ar implements Translations$auth$login$en {
	_Translations$auth$login$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'أهلًا بعودتك';
	@override String get subtitle => 'يمكنك البحث عن دكتور وحجز المواعيد ومتابعة صحتك';
	@override String get forgotPassword => 'نسيت كلمة السر؟';
	@override String get forgotPasswordTitle => 'استعادة كلمة السر';
	@override String get forgotPasswordSubtitle => 'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة السر.';
	@override String get forgotPasswordSend => 'إرسال رابط الاستعادة';
	@override String get forgotPasswordSending => 'جارٍ الإرسال...';
	@override String get forgotPasswordSuccess => 'تم إرسال الرابط! راجع بريدك الإلكتروني';
	@override String get forgotPasswordError => 'تعذّر إرسال بريد الاستعادة. حاول مرة أخرى.';
	@override String get noAccount => 'ليس لديك حساب؟ ';
	@override String get joinUs => 'انضم إلينا';
	@override String get submitBtn => 'تسجيل الدخول';
	@override String get loggingIn => 'جارٍ تسجيل الدخول...';
}

// Path: auth.register
class _Translations$auth$register$ar implements Translations$auth$register$en {
	_Translations$auth$register$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'انضم إلينا لبدء البحث';
	@override String get subtitle => 'يمكنك البحث عن دكتور وحجز المواعيد ومتابعة صحتك';
	@override String get termsPrefix => 'أوافق على ';
	@override String get terms => 'شروط الخدمة';
	@override String get termsAnd => ' و ';
	@override String get privacy => 'سياسة الخصوصية';
	@override String get acceptTermsError => 'من فضلك وافق على الشروط';
	@override String get haveAccount => 'لديك حساب بالفعل؟ ';
	@override String get loginLink => 'سجّل الدخول';
	@override String get submitBtn => 'إنشاء حساب';
	@override String get creatingAccount => 'جارٍ إنشاء الحساب...';
}

// Path: auth.errors
class _Translations$auth$errors$ar implements Translations$auth$errors$en {
	_Translations$auth$errors$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get noAccountFound => 'لا يوجد حساب بهذا البريد الإلكتروني.';
	@override String get useAdminLogin => 'لا يمكنك الدخول من هنا. استخدم شاشة دخول الإدارة.';
	@override String get userNotFound => 'لم يتم العثور على المستخدم بعد الدخول';
	@override String get invalidCredentials => 'البريد الإلكتروني أو كلمة السر غير صحيحة';
	@override String get emailAlreadyInUse => 'يوجد حساب بالفعل بهذا البريد الإلكتروني';
	@override String get weakPassword => 'كلمة السر ضعيفة جدًا';
	@override String get invalidEmail => 'بريد إلكتروني غير صحيح';
	@override String get userDisabled => 'تم تعطيل هذا الحساب';
	@override String get tooManyRequests => 'محاولات كثيرة جدًا. حاول مرة أخرى لاحقًا';
	@override String get networkRequestFailed => 'خطأ في الشبكة. تحقق من اتصالك';
}

// Path: admin.chooseRole
class _Translations$admin$chooseRole$ar implements Translations$admin$chooseRole$en {
	_Translations$admin$chooseRole$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'مدير';
	@override String get description => 'إدارة الأطباء وإعدادات التطبيق';
}

// Path: admin.login
class _Translations$admin$login$ar implements Translations$admin$login$en {
	_Translations$admin$login$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'أهلًا بعودتك!';
	@override String get subtitle => 'سجّل الدخول إلى حسابك الإداري';
	@override String get rememberMe => 'تذكرني';
	@override String get loginBtn => 'تسجيل الدخول';
	@override String get secureAccess => 'الدخول للمديرين فقط';
	@override String get accessDenied => 'غير مصرح بالدخول. أنت لست مديرًا.';
}

// Path: admin.doctors
class _Translations$admin$doctors$ar implements Translations$admin$doctors$en {
	_Translations$admin$doctors$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الأطباء';
	@override String get addDoctor => 'إضافة دكتور';
	@override String get searchHint => 'ابحث عن دكتور...';
	@override String get totalDoctors => 'إجمالي الأطباء';
	@override String get active => 'نشط';
	@override String get allSpecialties => 'الكل';
	@override String get noDoctorsFound => 'لا يوجد أطباء';
	@override String get statusConfirmTitle => 'تغيير حالة الدكتور';
	@override String get activate => 'تفعيل';
	@override String get deactivate => 'تعطيل';
	@override String get activateConfirm => 'هل أنت متأكد من تفعيل د. @name؟';
	@override String get deactivateConfirm => 'هل أنت متأكد من تعطيل د. @name؟ لن يظهر الدكتور للمرضى.';
	@override String get activated => 'تم تفعيل د. @name';
	@override String get deactivated => 'تم تعطيل د. @name';
	@override String get delete => 'حذف الدكتور';
	@override String get deleting => 'جارٍ الحذف...';
	@override String get deleteConfirmTitle => 'حذف الدكتور';
	@override String get deleteConfirm => 'هل أنت متأكد من حذف د. @name؟ سيتم حذف ملفه نهائيًا ولا يمكن التراجع. تُحفظ المواعيد السابقة.';
	@override String get deleted => 'تم حذف د. @name';
	@override String get deleteFailed => 'تعذّر حذف الدكتور';
}

// Path: admin.createDoctor
class _Translations$admin$createDoctor$ar implements Translations$admin$createDoctor$en {
	_Translations$admin$createDoctor$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'إضافة دكتور';
	@override String get nameLabel => 'اسم الدكتور';
	@override String get nameHint => 'مثال: د. أحمد علي';
	@override String get specialtyLabel => 'التخصص';
	@override String get specialtyHint => 'اختر التخصص';
	@override String get feeLabel => 'سعر الكشفية';
	@override String get feeHint => 'مثال: \$28.00';
	@override String get statusLabel => 'حالة الدكتور';
	@override String get statusSubtitle => 'نشط ومتاح';
	@override String get addPhoto => 'إضافة صورة';
	@override String get tapPhotoToChange => 'اضغط الصورة لتغييرها';
	@override String get createBtn => 'إنشاء الدكتور';
	@override String get creatingBtn => 'جارٍ الإنشاء...';
	@override String get success => 'تم إنشاء الدكتور بنجاح';
	@override String get failed => 'تعذّر إنشاء الدكتور';
}

// Path: admin.editDoctor
class _Translations$admin$editDoctor$ar implements Translations$admin$editDoctor$en {
	_Translations$admin$editDoctor$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'تعديل بيانات الدكتور';
	@override String get updateBtn => 'حفظ التعديلات';
	@override String get updatingBtn => 'جارٍ الحفظ...';
	@override String get success => 'تم تحديث بيانات الدكتور بنجاح';
	@override String get failed => 'تعذّر تحديث بيانات الدكتور';
}

// Path: admin.doctorDetails
class _Translations$admin$doctorDetails$ar implements Translations$admin$doctorDetails$en {
	_Translations$admin$doctorDetails$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'تفاصيل الدكتور';
	@override String get specialty => 'التخصص';
	@override String get active => 'نشط';
	@override String get inactive => 'موقوف';
	@override String get reviewCount => 'عدد التقييمات';
	@override String get editDoctor => 'تعديل بيانات الدكتور';
}

// Path: admin.availability
class _Translations$admin$availability$ar implements Translations$admin$availability$en {
	_Translations$admin$availability$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'مواعيد الدكتور';
	@override String get workingDays => 'أيام العمل';
	@override String get workingHours => 'ساعات العمل';
	@override String get startTime => 'وقت البداية';
	@override String get endTime => 'وقت النهاية';
	@override String daysEnabled({required Object count}) => '${count} أيام مفعلة';
	@override String get slotDuration => 'مدة الفترة';
	@override String minutes({required Object count}) => '${count} دقيقة';
	@override late final _Translations$admin$availability$days$ar days = _Translations$admin$availability$days$ar._(_root);
	@override String get updated => 'تم تحديث المواعيد بنجاح';
	@override String get failed => 'تعذّر تحديث المواعيد';
}

// Path: admin.editProfile
class _Translations$admin$editProfile$ar implements Translations$admin$editProfile$en {
	_Translations$admin$editProfile$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'تعديل الملف الشخصي';
	@override String get tapPhotoToChange => 'اضغط الصورة لتغييرها';
	@override String get fullName => 'الاسم الكامل';
	@override String get nameHint => 'مثال: أحمد محمد';
	@override String get emailAddress => 'البريد الإلكتروني';
	@override String get clinicLocation => 'موقع العيادة';
	@override String get clinicLocationHint => '١٢٣ شارع التحرير، وسط البلد، المدينة';
	@override String get saveChanges => 'حفظ التعديلات';
	@override String get saving => 'جارٍ الحفظ...';
	@override String get reauthRequired => 'تغيير البريد يتطلب إعادة تأكيد هويتك';
	@override String get success => 'تم تحديث الملف الشخصي بنجاح';
	@override String get failed => 'تعذّر تحديث الملف الشخصي';
}

// Path: admin.appointments
class _Translations$admin$appointments$ar implements Translations$admin$appointments$en {
	_Translations$admin$appointments$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'المواعيد';
	@override String get detailsTitle => 'تفاصيل الموعد';
	@override String get notFound => 'الموعد غير موجود.';
	@override String get markCompleted => 'إتمام الموعد';
	@override String get cancelAppointment => 'إلغاء الموعد';
	@override String get viewDetails => 'عرض التفاصيل';
	@override String get patient => 'المريض';
	@override String get doctor => 'الدكتور';
	@override String get appointment => 'الموعد';
	@override String get all => 'الكل';
	@override String get upcoming => 'القادمة';
	@override String get completed => 'المنتهية';
	@override String get cancelled => 'الملغاة';
	@override String get date => 'التاريخ';
	@override String get time => 'الوقت';
	@override String get fee => 'السعر';
	@override String get consultationFee => 'سعر الكشفية';
	@override String get clinicLocation => 'موقع العيادة';
	@override String get completeConfirmTitle => 'إتمام الموعد';
	@override String get completeConfirmMessage => 'هل أنت متأكد من إتمام هذا الموعد؟';
	@override String get cancelConfirmTitle => 'إلغاء الموعد';
	@override String get cancelConfirmMessage => 'هل أنت متأكد من إلغاء هذا الموعد؟';
	@override String get completeSuccess => 'تم إتمام الموعد';
	@override String get cancelSuccess => 'تم إلغاء الموعد بنجاح';
	@override String get noAll => 'لا توجد مواعيد بعد';
	@override String get noUpcoming => 'لا توجد مواعيد قادمة';
	@override String get noCompleted => 'لا توجد مواعيد منتهية';
	@override String get noCancelled => 'لا توجد مواعيد ملغاة';
}

// Path: admin.settings
class _Translations$admin$settings$ar implements Translations$admin$settings$en {
	_Translations$admin$settings$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الإعدادات';
	@override String get account => 'الحساب';
	@override String get adminProfile => 'الملف الإداري';
	@override String get adminProfileDesc => 'تعديل بيانات المدير وموقع العيادة الرئيسي';
	@override String get changePassword => 'تغيير كلمة السر';
	@override String get changePasswordDesc => 'تحديث بيانات أمان المدير';
	@override String get appInformation => 'معلومات التطبيق';
	@override String get appVersion => 'إصدار التطبيق';
	@override String get adminFallbackName => 'مدير النظام';
}

// Path: roleSelection.roles.patient
class _Translations$roleSelection$roles$patient$ar implements Translations$roleSelection$roles$patient$en {
	_Translations$roleSelection$roles$patient$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'مريض';
	@override String get description => 'ابحث عن دكتور، احجز موعدك، وتابع زياراتك.';
}

// Path: admin.availability.days
class _Translations$admin$availability$days$ar implements Translations$admin$availability$days$en {
	_Translations$admin$availability$days$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get monday => 'الاثنين';
	@override String get tuesday => 'الثلاثاء';
	@override String get wednesday => 'الأربعاء';
	@override String get thursday => 'الخميس';
	@override String get friday => 'الجمعة';
	@override String get saturday => 'السبت';
	@override String get sunday => 'الأحد';
}

/// The flat map containing all translations for locale <ar>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsAr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.appName' => 'دكتور هانت',
			'common.email' => 'البريد الإلكتروني',
			'common.password' => 'كلمة السر',
			'common.google' => 'جوجل',
			'common.continueBtn' => 'متابعة',
			'common.skip' => 'تخطي',
			'common.next' => 'التالي',
			'common.getStarted' => 'ابدأ الآن',
			'common.name' => 'الاسم',
			'common.bookNow' => 'احجز الآن',
			'common.nextAvailable' => 'أقرب موعد متاح',
			'common.search' => 'بحث',
			'common.phone' => 'رقم الهاتف',
			'common.confirmPassword' => 'تأكيد كلمة السر',
			'common.logout' => 'تسجيل الخروج',
			'common.ok' => 'حسنًا',
			'common.cancel' => 'إلغاء',
			'common.undo' => 'تراجع',
			'common.notice' => 'تنبيه',
			'common.confirm' => 'تأكيد',
			'common.edit' => 'تعديل',
			'common.delete' => 'حذف',
			'common.tapBackAgainToExit' => 'اضغط رجوع مرة أخرى للخروج',
			'common.loading' => 'جارٍ التحميل...',
			'common.errorGeneric' => 'حدث خطأ ما. حاول مرة أخرى',
			'common.loginRequired' => 'سجّل الدخول للمتابعة',
			'common.language' => 'اللغة',
			'common.languageEnglish' => 'English',
			'common.languageArabic' => 'العربية',
			'common.languageUpdated' => 'تم تغيير اللغة',
			'common.validation.enterEmail' => 'أدخل بريدك الإلكتروني',
			'common.validation.validEmail' => 'أدخل بريدًا إلكترونيًا صحيحًا',
			'common.validation.enterPassword' => 'أدخل كلمة السر',
			'common.validation.minPassword' => '6 أحرف على الأقل',
			'common.validation.enterName' => 'أدخل اسمك',
			'common.validation.enterPhone' => 'أدخل رقم هاتفك',
			'common.validation.passwordsDoNotMatch' => 'كلمتا السر غير متطابقتين',
			'common.validation.enterConfirmPassword' => 'من فضلك أكّد كلمة السر',
			'common.validation.selectRole' => 'من فضلك اختر نوع المستخدم',
			'common.validation.fieldRequired' => ({required Object field}) => 'من فضلك أدخل ${field}',
			'common.validation.invalidNumber' => 'من فضلك أدخل رقمًا صحيحًا',
			'common.validation.validPhone' => 'أدخل رقم هاتف صحيح',
			'common.notProvided' => 'غير مسجل',
			'common.amount' => ({required Object amount}) => '\$${amount}',
			'onboarding.pages.0.title' => 'ابحث عن أطباء موثوقين',
			'onboarding.pages.0.description' => 'ابحث بالاسم أو التخصص لتجد الدكتور المناسب لك.',
			'onboarding.pages.1.title' => 'اختر أفضل الأطباء',
			'onboarding.pages.1.description' => 'قارن التقييمات والرسوم واختر أفضل دكتور بسهولة.',
			'onboarding.pages.2.title' => 'حجز مواعيد سهل',
			'onboarding.pages.2.description' => 'احجز موعدك في نقرات قليلة وتابعه من مكان واحد.',
			'roleSelection.title' => 'اختر نوعك',
			'roleSelection.subtitle' => 'نوع المستخدم المختار يحدّد التجربة والميزات المتاحة.',
			'roleSelection.roles.patient.title' => 'مريض',
			'roleSelection.roles.patient.description' => 'ابحث عن دكتور، احجز موعدك، وتابع زياراتك.',
			'roleSelection.errorNoRole' => 'من فضلك اختر نوع المستخدم',
			'auth.login.title' => 'أهلًا بعودتك',
			'auth.login.subtitle' => 'يمكنك البحث عن دكتور وحجز المواعيد ومتابعة صحتك',
			'auth.login.forgotPassword' => 'نسيت كلمة السر؟',
			'auth.login.forgotPasswordTitle' => 'استعادة كلمة السر',
			'auth.login.forgotPasswordSubtitle' => 'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة السر.',
			'auth.login.forgotPasswordSend' => 'إرسال رابط الاستعادة',
			'auth.login.forgotPasswordSending' => 'جارٍ الإرسال...',
			'auth.login.forgotPasswordSuccess' => 'تم إرسال الرابط! راجع بريدك الإلكتروني',
			'auth.login.forgotPasswordError' => 'تعذّر إرسال بريد الاستعادة. حاول مرة أخرى.',
			'auth.login.noAccount' => 'ليس لديك حساب؟ ',
			'auth.login.joinUs' => 'انضم إلينا',
			'auth.login.submitBtn' => 'تسجيل الدخول',
			'auth.login.loggingIn' => 'جارٍ تسجيل الدخول...',
			'auth.register.title' => 'انضم إلينا لبدء البحث',
			'auth.register.subtitle' => 'يمكنك البحث عن دكتور وحجز المواعيد ومتابعة صحتك',
			'auth.register.termsPrefix' => 'أوافق على ',
			'auth.register.terms' => 'شروط الخدمة',
			'auth.register.termsAnd' => ' و ',
			'auth.register.privacy' => 'سياسة الخصوصية',
			'auth.register.acceptTermsError' => 'من فضلك وافق على الشروط',
			'auth.register.haveAccount' => 'لديك حساب بالفعل؟ ',
			'auth.register.loginLink' => 'سجّل الدخول',
			'auth.register.submitBtn' => 'إنشاء حساب',
			'auth.register.creatingAccount' => 'جارٍ إنشاء الحساب...',
			'auth.resetEmailSent' => 'تم إرسال بريد استعادة كلمة السر',
			'auth.registrationSuccessful' => 'تم إنشاء الحساب بنجاح',
			'auth.errors.noAccountFound' => 'لا يوجد حساب بهذا البريد الإلكتروني.',
			'auth.errors.useAdminLogin' => 'لا يمكنك الدخول من هنا. استخدم شاشة دخول الإدارة.',
			'auth.errors.userNotFound' => 'لم يتم العثور على المستخدم بعد الدخول',
			'auth.errors.invalidCredentials' => 'البريد الإلكتروني أو كلمة السر غير صحيحة',
			'auth.errors.emailAlreadyInUse' => 'يوجد حساب بالفعل بهذا البريد الإلكتروني',
			'auth.errors.weakPassword' => 'كلمة السر ضعيفة جدًا',
			'auth.errors.invalidEmail' => 'بريد إلكتروني غير صحيح',
			'auth.errors.userDisabled' => 'تم تعطيل هذا الحساب',
			'auth.errors.tooManyRequests' => 'محاولات كثيرة جدًا. حاول مرة أخرى لاحقًا',
			'auth.errors.networkRequestFailed' => 'خطأ في الشبكة. تحقق من اتصالك',
			'home.popularDoctor' => 'أشهر الأطباء',
			'home.topRatedDoctor' => 'أعلى الأطباء تقييمًا',
			'home.specialties' => 'التخصصات',
			'home.allSpecialties' => 'الكل',
			'home.favouriteDoctors' => 'الأطباء المفضلين',
			'home.seeAll' => 'عرض الكل',
			'home.findYourDoctor' => 'اعثر على دكتورك',
			'home.greeting' => ({required Object name}) => 'أهلًا، ${name} 👋',
			'home.searchHint' => 'ابحث....',
			'home.bookNow' => 'احجز الآن',
			'home.reviewsCount' => ({required Object count}) => '(${count})',
			'home.failedToLoadDoctors' => 'تعذّر تحميل الأطباء',
			'home.noDoctorsAvailableYet' => 'لا يوجد دكتور متاح حتى الآن',
			'findDoctors.title' => 'بحث الأطباء',
			'findDoctors.searchHint' => 'طبيب أسنان',
			'findDoctors.noDoctorsFound' => 'لم يتم العثور على أطباء',
			'findDoctors.tryDifferentSearchTerm' => 'جرّب كلمة بحث مختلفة',
			'doctorDetails.title' => 'تفاصيل الدكتور',
			'doctorDetails.patient' => 'المريض',
			'doctorDetails.doctorInfo' => 'معلومات الدكتور',
			'doctorDetails.reviews' => 'التقييم',
			'doctorDetails.reviewsTitle' => 'تقييمات المرضى',
			'doctorDetails.reviewsCount' => ({required Object count}) => '${count} مراجعة',
			'doctorDetails.noReviews' => 'لا توجد تقييمات بعد',
			'doctorDetails.clinicInfo' => 'معلومات العيادة',
			'doctorDetails.location' => 'الموقع',
			'doctorDetails.workingDays' => 'أيام العمل',
			'doctorDetails.workingHours' => 'ساعات العمل',
			'doctorDetails.consultationFee' => 'سعر الكشفية',
			'doctorDetails.removedFromFavorites' => ({required Object doctorName}) => 'تم حذف ${doctorName} من المفضلة',
			'favorite.pleaseLogin' => 'من فضلك سجّل الدخول لعرض المفضلة',
			'favorite.noFavoriteDoctors' => 'لا يوجد دكتور مفضل بعد',
			'favorite.tapHeartHint' => 'اضغط أيقونة القلب على أي دكتور لإضافته هنا',
			'favorite.doctorRemoved' => ({required Object doctorName}) => 'تم حذف ${doctorName} من المفضلة',
			'favorite.doctorAdded' => ({required Object doctorName}) => 'تم إضافة ${doctorName} إلى المفضلة',
			'appointment.successTitle' => 'شكرًا ليك !',
			'appointment.successSubtitle' => 'تم تأكيد حجزك بنجاح',
			'appointment.successMessage' => ({required Object doctorName, required Object date, required Object time}) => 'لقد حجزت موعدًا مع ${doctorName} يوم ${date} الساعة ${time}',
			'appointment.doneBtn' => 'تم',
			'appointment.editBtn' => 'تعديل موعدك',
			'selectTime.title' => 'اختر وقت الموعد',
			'selectTime.today' => ({required Object date}) => 'اليوم، ${date}',
			'selectTime.tomorrow' => ({required Object date}) => 'غدًا، ${date}',
			'selectTime.noSlotsAvailable' => 'لا توجد مواعيد متاحة',
			'selectTime.slotsAvailable' => ({required Object count}) => '${count} موعد متاح',
			'selectTime.afternoonSlots' => ({required Object count}) => 'بعد الظهر: ${count} موعد',
			'selectTime.eveningSlots' => ({required Object count}) => 'المساء: ${count} موعد',
			'selectTime.proceed' => 'متابعة',
			'selectTime.slotJustBooked' => 'تم حجز هذا الموعد للتو. اختر وقتًا آخر.',
			'selectTime.nextAvailabilityOn' => ({required Object date}) => 'أقرب موعد متاح ${date}',
			'selectTime.noUpcomingDates' => 'لا توجد مواعيد قادمة',
			'selectTime.clinicLocationLabel' => ({required Object location}) => 'موقع العيادة: ${location}',
			'selectTime.or' => 'أو',
			'selectTime.contactClinic' => 'تواصل مع العيادة',
			'review.title' => 'مراجعة الحجز',
			'review.subtitle' => 'من فضلك راجع بيانات موعدك',
			'review.doctor' => 'الدكتور',
			'review.date' => 'التاريخ',
			'review.time' => 'الوقت',
			'review.fee' => 'سعر الكشفية',
			'review.location' => 'موقع العيادة',
			'review.confirm' => 'تأكيد الحجز',
			'review.confirming' => 'جارٍ الحجز...',
			'admin.chooseRole.title' => 'مدير',
			'admin.chooseRole.description' => 'إدارة الأطباء وإعدادات التطبيق',
			'admin.login.title' => 'أهلًا بعودتك!',
			'admin.login.subtitle' => 'سجّل الدخول إلى حسابك الإداري',
			'admin.login.rememberMe' => 'تذكرني',
			'admin.login.loginBtn' => 'تسجيل الدخول',
			'admin.login.secureAccess' => 'الدخول للمديرين فقط',
			'admin.login.accessDenied' => 'غير مصرح بالدخول. أنت لست مديرًا.',
			'admin.doctors.title' => 'الأطباء',
			'admin.doctors.addDoctor' => 'إضافة دكتور',
			'admin.doctors.searchHint' => 'ابحث عن دكتور...',
			'admin.doctors.totalDoctors' => 'إجمالي الأطباء',
			'admin.doctors.active' => 'نشط',
			'admin.doctors.allSpecialties' => 'الكل',
			'admin.doctors.noDoctorsFound' => 'لا يوجد أطباء',
			'admin.doctors.statusConfirmTitle' => 'تغيير حالة الدكتور',
			'admin.doctors.activate' => 'تفعيل',
			'admin.doctors.deactivate' => 'تعطيل',
			'admin.doctors.activateConfirm' => 'هل أنت متأكد من تفعيل د. @name؟',
			'admin.doctors.deactivateConfirm' => 'هل أنت متأكد من تعطيل د. @name؟ لن يظهر الدكتور للمرضى.',
			'admin.doctors.activated' => 'تم تفعيل د. @name',
			'admin.doctors.deactivated' => 'تم تعطيل د. @name',
			'admin.doctors.delete' => 'حذف الدكتور',
			'admin.doctors.deleting' => 'جارٍ الحذف...',
			'admin.doctors.deleteConfirmTitle' => 'حذف الدكتور',
			'admin.doctors.deleteConfirm' => 'هل أنت متأكد من حذف د. @name؟ سيتم حذف ملفه نهائيًا ولا يمكن التراجع. تُحفظ المواعيد السابقة.',
			'admin.doctors.deleted' => 'تم حذف د. @name',
			'admin.doctors.deleteFailed' => 'تعذّر حذف الدكتور',
			'admin.createDoctor.title' => 'إضافة دكتور',
			'admin.createDoctor.nameLabel' => 'اسم الدكتور',
			'admin.createDoctor.nameHint' => 'مثال: د. أحمد علي',
			'admin.createDoctor.specialtyLabel' => 'التخصص',
			'admin.createDoctor.specialtyHint' => 'اختر التخصص',
			'admin.createDoctor.feeLabel' => 'سعر الكشفية',
			'admin.createDoctor.feeHint' => 'مثال: \$28.00',
			'admin.createDoctor.statusLabel' => 'حالة الدكتور',
			'admin.createDoctor.statusSubtitle' => 'نشط ومتاح',
			'admin.createDoctor.addPhoto' => 'إضافة صورة',
			'admin.createDoctor.tapPhotoToChange' => 'اضغط الصورة لتغييرها',
			'admin.createDoctor.createBtn' => 'إنشاء الدكتور',
			'admin.createDoctor.creatingBtn' => 'جارٍ الإنشاء...',
			'admin.createDoctor.success' => 'تم إنشاء الدكتور بنجاح',
			'admin.createDoctor.failed' => 'تعذّر إنشاء الدكتور',
			'admin.editDoctor.title' => 'تعديل بيانات الدكتور',
			'admin.editDoctor.updateBtn' => 'حفظ التعديلات',
			'admin.editDoctor.updatingBtn' => 'جارٍ الحفظ...',
			'admin.editDoctor.success' => 'تم تحديث بيانات الدكتور بنجاح',
			'admin.editDoctor.failed' => 'تعذّر تحديث بيانات الدكتور',
			'admin.doctorDetails.title' => 'تفاصيل الدكتور',
			'admin.doctorDetails.specialty' => 'التخصص',
			'admin.doctorDetails.active' => 'نشط',
			'admin.doctorDetails.inactive' => 'موقوف',
			'admin.doctorDetails.reviewCount' => 'عدد التقييمات',
			'admin.doctorDetails.editDoctor' => 'تعديل بيانات الدكتور',
			'admin.availability.title' => 'مواعيد الدكتور',
			'admin.availability.workingDays' => 'أيام العمل',
			'admin.availability.workingHours' => 'ساعات العمل',
			'admin.availability.startTime' => 'وقت البداية',
			'admin.availability.endTime' => 'وقت النهاية',
			'admin.availability.daysEnabled' => ({required Object count}) => '${count} أيام مفعلة',
			'admin.availability.slotDuration' => 'مدة الفترة',
			'admin.availability.minutes' => ({required Object count}) => '${count} دقيقة',
			'admin.availability.days.monday' => 'الاثنين',
			'admin.availability.days.tuesday' => 'الثلاثاء',
			'admin.availability.days.wednesday' => 'الأربعاء',
			'admin.availability.days.thursday' => 'الخميس',
			'admin.availability.days.friday' => 'الجمعة',
			'admin.availability.days.saturday' => 'السبت',
			'admin.availability.days.sunday' => 'الأحد',
			'admin.availability.updated' => 'تم تحديث المواعيد بنجاح',
			'admin.availability.failed' => 'تعذّر تحديث المواعيد',
			'admin.editProfile.title' => 'تعديل الملف الشخصي',
			'admin.editProfile.tapPhotoToChange' => 'اضغط الصورة لتغييرها',
			'admin.editProfile.fullName' => 'الاسم الكامل',
			'admin.editProfile.nameHint' => 'مثال: أحمد محمد',
			'admin.editProfile.emailAddress' => 'البريد الإلكتروني',
			'admin.editProfile.clinicLocation' => 'موقع العيادة',
			'admin.editProfile.clinicLocationHint' => '١٢٣ شارع التحرير، وسط البلد، المدينة',
			'admin.editProfile.saveChanges' => 'حفظ التعديلات',
			'admin.editProfile.saving' => 'جارٍ الحفظ...',
			'admin.editProfile.reauthRequired' => 'تغيير البريد يتطلب إعادة تأكيد هويتك',
			'admin.editProfile.success' => 'تم تحديث الملف الشخصي بنجاح',
			'admin.editProfile.failed' => 'تعذّر تحديث الملف الشخصي',
			'admin.appointments.title' => 'المواعيد',
			'admin.appointments.detailsTitle' => 'تفاصيل الموعد',
			'admin.appointments.notFound' => 'الموعد غير موجود.',
			'admin.appointments.markCompleted' => 'إتمام الموعد',
			'admin.appointments.cancelAppointment' => 'إلغاء الموعد',
			'admin.appointments.viewDetails' => 'عرض التفاصيل',
			'admin.appointments.patient' => 'المريض',
			'admin.appointments.doctor' => 'الدكتور',
			'admin.appointments.appointment' => 'الموعد',
			'admin.appointments.all' => 'الكل',
			'admin.appointments.upcoming' => 'القادمة',
			'admin.appointments.completed' => 'المنتهية',
			'admin.appointments.cancelled' => 'الملغاة',
			'admin.appointments.date' => 'التاريخ',
			'admin.appointments.time' => 'الوقت',
			'admin.appointments.fee' => 'السعر',
			'admin.appointments.consultationFee' => 'سعر الكشفية',
			'admin.appointments.clinicLocation' => 'موقع العيادة',
			'admin.appointments.completeConfirmTitle' => 'إتمام الموعد',
			'admin.appointments.completeConfirmMessage' => 'هل أنت متأكد من إتمام هذا الموعد؟',
			'admin.appointments.cancelConfirmTitle' => 'إلغاء الموعد',
			'admin.appointments.cancelConfirmMessage' => 'هل أنت متأكد من إلغاء هذا الموعد؟',
			'admin.appointments.completeSuccess' => 'تم إتمام الموعد',
			'admin.appointments.cancelSuccess' => 'تم إلغاء الموعد بنجاح',
			'admin.appointments.noAll' => 'لا توجد مواعيد بعد',
			'admin.appointments.noUpcoming' => 'لا توجد مواعيد قادمة',
			'admin.appointments.noCompleted' => 'لا توجد مواعيد منتهية',
			'admin.appointments.noCancelled' => 'لا توجد مواعيد ملغاة',
			'admin.settings.title' => 'الإعدادات',
			'admin.settings.account' => 'الحساب',
			'admin.settings.adminProfile' => 'الملف الإداري',
			'admin.settings.adminProfileDesc' => 'تعديل بيانات المدير وموقع العيادة الرئيسي',
			'admin.settings.changePassword' => 'تغيير كلمة السر',
			'admin.settings.changePasswordDesc' => 'تحديث بيانات أمان المدير',
			'admin.settings.appInformation' => 'معلومات التطبيق',
			'admin.settings.appVersion' => 'إصدار التطبيق',
			'admin.settings.adminFallbackName' => 'مدير النظام',
			'patientProfile.title' => 'الملف الشخصي',
			'patientProfile.personalInfo' => 'المعلومات الشخصية',
			'patientProfile.contactNumber' => 'رقم الهاتف',
			'patientProfile.dateOfBirth' => 'تاريخ الميلاد',
			'patientProfile.gender' => 'النوع',
			'patientProfile.male' => 'ذكر',
			'patientProfile.female' => 'أنثى',
			'patientProfile.profileUpdated' => 'تم تحديث بياناتك بنجاح',
			'patientProfile.noProfileData' => 'لا توجد بيانات ملف شخصي',
			'patientSettings.title' => 'الإعدادات',
			'patientSettings.accountSettings' => 'إعدادات الحساب',
			'patientSettings.changePassword' => 'تغيير كلمة السر',
			'patientSettings.notifications' => 'الإشعارات',
			'patientSettings.privacyPolicy' => 'سياسة الخصوصية',
			'patientSettings.moreOptions' => 'خيارات أخرى',
			'patientSettings.buildVersion' => 'إصدار البناء',
			'privacyPolicy.title' => 'سياسة الخصوصية',
			'privacyPolicy.heading' => 'سياسة خصوصية تطبيقات دكتور هانت',
			'privacyPolicy.intro' => 'تشرح هذه السياسة المعلومات التي يجمعها تطبيق دكتور هانت وكيفية استخدامها والخيارات المتاحة لك. نجمع فقط البيانات اللازمة لتشغيل الخدمة: بيانات حسابك ومعلومات ملفك الشخصي والمواعيد التي تحجزها.',
			'privacyPolicy.bullet1' => 'لا نبيع أو نشارك بياناتك الشخصية مع أطراف ثالثة.',
			'privacyPolicy.bullet2' => 'مواعيدك وتقييماتك خاصة بك وللدكتور المعني فقط.',
			'privacyPolicy.bullet3' => 'يمكنك تعديل أو حذف بيانات ملفك الشخصي في أي وقت.',
			'privacyPolicy.bullet4' => 'تواصل معنا إذا كان لديك أي سؤال حول بياناتك.',
			'privacyPolicy.outro' => 'باستخدامك تطبيق دكتور هانت، فإنك توافق على هذه السياسة. قد نقوم بتحديثها من وقت لآخر وسنخبرك بأي تغييرات مهمة.',
			'logoutDialog.title' => 'تسجيل الخروج',
			'logoutDialog.confirmMessage' => 'هل أنت متأكد من تسجيل الخروج؟',
			'menu.home' => 'الرئيسية',
			'menu.favourites' => 'المفضلة',
			'menu.myAppointments' => 'مواعيدي',
			'menu.profile' => 'الملف الشخصي',
			'menu.settings' => 'الإعدادات',
			'menu.logout' => 'تسجيل الخروج',
			'appointments.title' => 'المواعيد',
			'appointments.upcoming' => 'القادمة',
			'appointments.completed' => 'المنتهية',
			'appointments.cancelled' => 'الملغاة',
			'appointments.patient' => 'المريض',
			'appointments.appointmentDate' => 'تاريخ الموعد',
			'appointments.appointmentTime' => 'وقت الموعد',
			'appointments.consultationFee' => 'سعر الكشفية',
			'appointments.viewDetails' => 'عرض التفاصيل',
			'appointments.cancelAppointment' => 'إلغاء الموعد',
			'appointments.rateDoctor' => 'قيّم الدكتور',
			'appointments.rateDialogTitle' => 'قيّم زيارتك',
			'appointments.reviewCommentLabel' => 'تعليق (اختياري)',
			'appointments.reviewCommentHint' => 'شاركنا تجربتك...',
			'appointments.submit' => 'إرسال',
			'appointments.noUpcoming' => 'لا توجد مواعيد قادمة',
			'appointments.noCompleted' => 'لا توجد مواعيد منتهية',
			'appointments.noCancelled' => 'لا توجد مواعيد ملغاة',
			'appointments.cancelConfirmTitle' => 'إلغاء الموعد',
			'appointments.cancelConfirmMessage' => 'هل أنت متأكد من إلغاء هذا الموعد؟',
			'appointments.cancelSuccess' => 'تم إلغاء الموعد',
			'appointments.cancelFailed' => 'تعذّر إلغاء الموعد',
			'appointments.reviewSuccess' => 'شكرًا على تقييمك!',
			'appointments.reviewFailed' => 'تعذّر إرسال التقييم',
			'appointments.bookingFailed' => 'تعذّر حجز الموعد',
			'appointments.slotUnavailable' => 'تم حجز هذا الموعد للتو بواسطة مستخدم آخر. اختر موعدًا مختلفًا.',
			'appointments.noUpcomingSubtitle' => 'احجز موعدًا مع دكتور ليظهر هنا.',
			'appointments.noCompletedSubtitle' => 'ستظهر مواعيدك المنتهية هنا.',
			'appointments.noCancelledSubtitle' => 'ستظهر مواعيدك الملغاة هنا.',
			'changePassword.title' => 'تغيير كلمة السر',
			'changePassword.currentPassword' => 'كلمة السر الحالية',
			'changePassword.newPassword' => 'كلمة السر الجديدة',
			'changePassword.confirmNewPassword' => 'تأكيد كلمة السر الجديدة',
			'changePassword.updatePassword' => 'تحديث كلمة السر',
			'changePassword.updating' => 'جارٍ التحديث...',
			'changePassword.success' => 'تم تحديث كلمة السر بنجاح',
			'changePassword.failed' => 'تعذّر تحديث كلمة السر',
			'changePassword.currentPasswordRequired' => 'من فضلك أدخل كلمة السر الحالية',
			_ => null,
		};
	}
}
