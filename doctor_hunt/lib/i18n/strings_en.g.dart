///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$common$en common = Translations$common$en._(_root);
	late final Translations$onboarding$en onboarding = Translations$onboarding$en._(_root);
	late final Translations$roleSelection$en roleSelection = Translations$roleSelection$en._(_root);
	late final Translations$auth$en auth = Translations$auth$en._(_root);
	late final Translations$home$en home = Translations$home$en._(_root);
	late final Translations$findDoctors$en findDoctors = Translations$findDoctors$en._(_root);
	late final Translations$doctorDetails$en doctorDetails = Translations$doctorDetails$en._(_root);
	late final Translations$favorite$en favorite = Translations$favorite$en._(_root);
	late final Translations$appointment$en appointment = Translations$appointment$en._(_root);
	late final Translations$updateProfile$en updateProfile = Translations$updateProfile$en._(_root);
	late final Translations$selectTime$en selectTime = Translations$selectTime$en._(_root);
	late final Translations$dashboard$en dashboard = Translations$dashboard$en._(_root);
}

// Path: common
class Translations$common$en {
	Translations$common$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Doctor Hunt'
	String get appName => 'Doctor Hunt';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Password'
	String get password => 'Password';

	/// en: 'Google'
	String get google => 'Google';

	/// en: 'Facebook'
	String get facebook => 'Facebook';

	/// en: 'Continue'
	String get continueBtn => 'Continue';

	/// en: 'Skip'
	String get skip => 'Skip';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Get Started'
	String get getStarted => 'Get Started';

	/// en: 'Name'
	String get name => 'Name';

	/// en: 'Book Now'
	String get bookNow => 'Book Now';

	/// en: 'Next Available'
	String get nextAvailable => 'Next Available';

	/// en: 'Search'
	String get search => 'Search';

	/// en: 'Phone'
	String get phone => 'Phone';

	/// en: 'Confirm Password'
	String get confirmPassword => 'Confirm Password';

	/// en: 'Logout'
	String get logout => 'Logout';

	/// en: 'OK'
	String get ok => 'OK';

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Undo'
	String get undo => 'Undo';

	/// en: 'Notice'
	String get notice => 'Notice';

	/// en: 'Confirm'
	String get confirm => 'Confirm';

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'An error occurred. Please try again'
	String get errorGeneric => 'An error occurred. Please try again';

	late final Translations$common$validation$en validation = Translations$common$validation$en._(_root);
}

// Path: onboarding
class Translations$onboarding$en {
	Translations$onboarding$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	List<dynamic> get pages => [
		Translations$onboarding$pages$0$en._(_root),
		Translations$onboarding$pages$1$en._(_root),
		Translations$onboarding$pages$2$en._(_root),
	];
}

// Path: roleSelection
class Translations$roleSelection$en {
	Translations$roleSelection$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Choose your role'
	String get title => 'Choose your role';

	/// en: 'The selected role determines the experience and available features.'
	String get subtitle => 'The selected role determines the experience and available features.';

	late final Translations$roleSelection$roles$en roles = Translations$roleSelection$roles$en._(_root);

	/// en: 'Please select a role'
	String get errorNoRole => 'Please select a role';
}

// Path: auth
class Translations$auth$en {
	Translations$auth$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$auth$login$en login = Translations$auth$login$en._(_root);
	late final Translations$auth$register$en register = Translations$auth$register$en._(_root);
}

// Path: home
class Translations$home$en {
	Translations$home$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Live Doctors'
	String get liveDoctors => 'Live Doctors';

	/// en: 'Popular Doctor'
	String get popularDoctor => 'Popular Doctor';

	/// en: 'Feature Doctor'
	String get featureDoctor => 'Feature Doctor';

	/// en: 'Favourite Doctors'
	String get favouriteDoctors => 'Favourite Doctors';

	/// en: 'See all'
	String get seeAll => 'See all';

	/// en: 'Hi Handwerker!'
	String get hiHandwerker => 'Hi Handwerker!';

	/// en: 'Find Your Doctor'
	String get findYourDoctor => 'Find Your Doctor';

	/// en: 'Search.....'
	String get searchHint => 'Search.....';

	/// en: 'LIVE'
	String get live => 'LIVE';

	/// en: 'Our Doctors'
	String get doctorsFromFirestore => 'Our Doctors';

	/// en: 'Seeded doctors to database!'
	String get seededSuccess => 'Seeded doctors to database!';

	/// en: 'Map / Bookings Screen'
	String get mapBookingsPlaceholder => 'Map / Bookings Screen';

	/// en: 'Chat Screen'
	String get chatPlaceholder => 'Chat Screen';

	/// en: 'Failed to load doctors'
	String get failedToLoadDoctors => 'Failed to load doctors';

	/// en: 'No doctors available'
	String get noDoctorsAvailable => 'No doctors available';

	/// en: 'No doctors available yet'
	String get noDoctorsAvailableYet => 'No doctors available yet';
}

// Path: findDoctors
class Translations$findDoctors$en {
	Translations$findDoctors$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Find Doctors'
	String get title => 'Find Doctors';

	/// en: 'Dentist'
	String get searchHint => 'Dentist';

	/// en: 'Search doctors, specialties...'
	String get searchHintExtra => 'Search doctors, specialties...';

	/// en: 'Recent Searches'
	String get recentSearches => 'Recent Searches';

	/// en: 'No doctors found'
	String get noDoctorsFound => 'No doctors found';

	/// en: 'Try a different search term'
	String get tryDifferentSearchTerm => 'Try a different search term';

	/// en: '$count Years experience'
	String yearsExperience({required Object count}) => '${count} Years experience';

	/// en: '$count Patient Stories'
	String patientStories({required Object count}) => '${count} Patient Stories';

	/// en: '$time tomorrow'
	String timeTomorrow({required Object time}) => '${time} tomorrow';

	/// en: '10 years experience'
	String get tenYearsExperience => '10 years experience';
}

// Path: doctorDetails
class Translations$doctorDetails$en {
	Translations$doctorDetails$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Doctor Details'
	String get title => 'Doctor Details';

	/// en: 'Specialist Cardiologist'
	String get specialist => 'Specialist Cardiologist';

	/// en: '$price/hr'
	String perHour({required Object price}) => '${price}/hr';

	/// en: 'Running'
	String get running => 'Running';

	/// en: 'Ongoing'
	String get ongoing => 'Ongoing';

	/// en: 'Patient'
	String get patient => 'Patient';

	/// en: 'Patients'
	String get patients => 'Patients';

	/// en: 'Services'
	String get services => 'Services';

	/// en: 'Patient care should be the number one priority.'
	String get service1 => 'Patient care should be the number one priority.';

	/// en: 'If you run your practice you know how frustrating.'
	String get service2 => 'If you run your practice you know how frustrating.';

	/// en: 'That's why some of appointment reminder system.'
	String get service3 => 'That\'s why some of appointment reminder system.';

	/// en: 'Doctor Info'
	String get doctorInfo => 'Doctor Info';

	/// en: '$doctorName removed from favorites'
	String removedFromFavorites({required Object doctorName}) => '${doctorName} removed from favorites';
}

// Path: favorite
class Translations$favorite$en {
	Translations$favorite$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Please log in to view favorites'
	String get pleaseLogin => 'Please log in to view favorites';

	/// en: 'No favorite doctors yet'
	String get noFavoriteDoctors => 'No favorite doctors yet';

	/// en: 'Tap the heart icon on any doctor to add them here'
	String get tapHeartHint => 'Tap the heart icon on any doctor to add them here';

	/// en: '$doctorName removed from favorites'
	String doctorRemoved({required Object doctorName}) => '${doctorName} removed from favorites';
}

// Path: appointment
class Translations$appointment$en {
	Translations$appointment$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Thank You !'
	String get successTitle => 'Thank You !';

	/// en: 'Your Appointment Successful'
	String get successSubtitle => 'Your Appointment Successful';

	/// en: 'You booked an appointment with $doctorName on $date, at $time'
	String successMessage({required Object doctorName, required Object date, required Object time}) => 'You booked an appointment with ${doctorName} on ${date}, at ${time}';

	/// en: 'Done'
	String get doneBtn => 'Done';

	/// en: 'Edit your appointment'
	String get editBtn => 'Edit your appointment';
}

// Path: updateProfile
class Translations$updateProfile$en {
	Translations$updateProfile$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Complete Registration'
	String get title => 'Complete Registration';

	/// en: 'Bio'
	String get bioLabel => 'Bio';

	/// en: 'Enter general medical information like your academic education and previous experiences...'
	String get bioHint => 'Enter general medical information like your academic education and previous experiences...';

	/// en: 'Clinic Address'
	String get clinicAddressLabel => 'Clinic Address';

	/// en: '123 Main St, Downtown, City'
	String get clinicAddressHint => '123 Main St, Downtown, City';

	/// en: 'Work Hours From'
	String get workHoursFrom => 'Work Hours From';

	/// en: 'To'
	String get to => 'To';

	/// en: 'Phone Number 1'
	String get phone1Label => 'Phone Number 1';

	/// en: 'Phone Number 2 (Optional)'
	String get phone2Label => 'Phone Number 2 (Optional)';

	/// en: '+20xxxxxxxxxx'
	String get phoneHint => '+20xxxxxxxxxx';

	/// en: 'Please select a profile image'
	String get selectImageError => 'Please select a profile image';

	/// en: 'Complete Registration'
	String get completeRegistration => 'Complete Registration';

	/// en: 'Required'
	String get required => 'Required';

	/// en: 'Specialization'
	String get specialization => 'Specialization';

	/// en: 'Choose specialization'
	String get chooseSpecialization => 'Choose specialization';
}

// Path: selectTime
class Translations$selectTime$en {
	Translations$selectTime$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Select Time'
	String get title => 'Select Time';

	/// en: 'Today, $date'
	String today({required Object date}) => 'Today, ${date}';

	/// en: 'Tomorrow, $date'
	String tomorrow({required Object date}) => 'Tomorrow, ${date}';

	/// en: 'No slots available'
	String get noSlotsAvailable => 'No slots available';

	/// en: '$count slots available'
	String slotsAvailable({required Object count}) => '${count} slots available';

	/// en: 'Afternoon $count slots'
	String afternoonSlots({required Object count}) => 'Afternoon ${count} slots';

	/// en: 'Evening $count slots'
	String eveningSlots({required Object count}) => 'Evening ${count} slots';

	/// en: 'Proceed'
	String get proceed => 'Proceed';

	/// en: 'Next availability on Wed, 24 Feb'
	String get nextAvailability => 'Next availability on Wed, 24 Feb';

	/// en: 'OR'
	String get or => 'OR';

	/// en: 'Contact Clinic'
	String get contactClinic => 'Contact Clinic';
}

// Path: dashboard
class Translations$dashboard$en {
	Translations$dashboard$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Doctor Dashboard'
	String get title => 'Doctor Dashboard';

	/// en: 'My Profile'
	String get profile => 'My Profile';

	/// en: 'Appointments'
	String get appointments => 'Appointments';

	/// en: 'My Patients'
	String get myPatients => 'My Patients';

	/// en: 'Availability'
	String get availability => 'Availability';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Update Profile'
	String get updateProfile => 'Update Profile';

	/// en: 'Profile updated successfully'
	String get updateProfileSuccess => 'Profile updated successfully';

	/// en: 'Total Patients'
	String get totalPatients => 'Total Patients';

	/// en: 'Completed Consultations'
	String get completedConsultations => 'Completed Consultations';

	/// en: 'Rating'
	String get rating => 'Rating';

	/// en: 'Available'
	String get available => 'Available';

	/// en: 'Unavailable'
	String get unavailable => 'Unavailable';

	/// en: 'Doctor Info'
	String get doctorInfo => 'Doctor Info';
}

// Path: common.validation
class Translations$common$validation$en {
	Translations$common$validation$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Enter your email'
	String get enterEmail => 'Enter your email';

	/// en: 'Enter a valid email'
	String get validEmail => 'Enter a valid email';

	/// en: 'Enter your password'
	String get enterPassword => 'Enter your password';

	/// en: 'Min 6 characters'
	String get minPassword => 'Min 6 characters';

	/// en: 'Enter your name'
	String get enterName => 'Enter your name';

	/// en: 'Enter your phone number'
	String get enterPhone => 'Enter your phone number';

	/// en: 'Passwords do not match'
	String get passwordsDoNotMatch => 'Passwords do not match';

	/// en: 'Please confirm your password'
	String get enterConfirmPassword => 'Please confirm your password';

	/// en: 'Please select a role'
	String get selectRole => 'Please select a role';
}

// Path: onboarding.pages.0
class Translations$onboarding$pages$0$en {
	Translations$onboarding$pages$0$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Find Trusted Doctors'
	String get title => 'Find Trusted Doctors';

	/// en: 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.'
	String get description => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.';
}

// Path: onboarding.pages.1
class Translations$onboarding$pages$1$en {
	Translations$onboarding$pages$1$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Choose Best Doctors'
	String get title => 'Choose Best Doctors';

	/// en: 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.'
	String get description => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.';
}

// Path: onboarding.pages.2
class Translations$onboarding$pages$2$en {
	Translations$onboarding$pages$2$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Easy Appointments'
	String get title => 'Easy Appointments';

	/// en: 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.'
	String get description => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.';
}

// Path: roleSelection.roles
class Translations$roleSelection$roles$en {
	Translations$roleSelection$roles$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$roleSelection$roles$patient$en patient = Translations$roleSelection$roles$patient$en._(_root);
	late final Translations$roleSelection$roles$doctor$en doctor = Translations$roleSelection$roles$doctor$en._(_root);
}

// Path: auth.login
class Translations$auth$login$en {
	Translations$auth$login$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome back'
	String get title => 'Welcome back';

	/// en: 'You can search doctors, book appointments and manage your health'
	String get subtitle => 'You can search doctors, book appointments and manage your health';

	/// en: 'Forgot password'
	String get forgotPassword => 'Forgot password';

	/// en: 'Reset Password'
	String get forgotPasswordTitle => 'Reset Password';

	/// en: 'Enter your email to receive a password reset link'
	String get forgotPasswordSubtitle => 'Enter your email to receive a password reset link';

	/// en: 'Send Reset Link'
	String get forgotPasswordSend => 'Send Reset Link';

	/// en: 'Reset link sent! Check your email'
	String get forgotPasswordSuccess => 'Reset link sent! Check your email';

	/// en: 'Don't have an account? '
	String get noAccount => 'Don\'t have an account? ';

	/// en: 'Join us'
	String get joinUs => 'Join us';

	/// en: 'Login'
	String get submitBtn => 'Login';

	/// en: 'Logging in...'
	String get loggingIn => 'Logging in...';
}

// Path: auth.register
class Translations$auth$register$en {
	Translations$auth$register$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Join us to start searching'
	String get title => 'Join us to start searching';

	/// en: 'You can search doctors, book appointments and manage your health'
	String get subtitle => 'You can search doctors, book appointments and manage your health';

	/// en: 'I agree with the '
	String get termsPrefix => 'I agree with the ';

	/// en: 'Terms of Service'
	String get terms => 'Terms of Service';

	/// en: ' and '
	String get termsAnd => ' and ';

	/// en: 'Privacy Policy'
	String get privacy => 'Privacy Policy';

	/// en: 'Please accept the terms'
	String get acceptTermsError => 'Please accept the terms';

	/// en: 'Have an account? '
	String get haveAccount => 'Have an account? ';

	/// en: 'Log in'
	String get loginLink => 'Log in';

	/// en: 'Sign up'
	String get submitBtn => 'Sign up';

	/// en: 'Specialty (e.g. Cardiology)'
	String get specialtyHint => 'Specialty (e.g. Cardiology)';

	/// en: 'Short bio about yourself'
	String get bioHint => 'Short bio about yourself';

	/// en: 'Years of experience'
	String get experienceHint => 'Years of experience';

	/// en: 'Creating account...'
	String get creatingAccount => 'Creating account...';

	/// en: 'Dr. Name'
	String get doctorNameHint => 'Dr. Name';
}

// Path: roleSelection.roles.patient
class Translations$roleSelection$roles$patient$en {
	Translations$roleSelection$roles$patient$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Patient'
	String get title => 'Patient';

	/// en: 'Find doctors, book appointments, and manage your medical records.'
	String get description => 'Find doctors, book appointments,\nand manage your medical records.';
}

// Path: roleSelection.roles.doctor
class Translations$roleSelection$roles$doctor$en {
	Translations$roleSelection$roles$doctor$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Doctor'
	String get title => 'Doctor';

	/// en: 'Manage appointments, patients, and your professional profile.'
	String get description => 'Manage appointments, patients,\nand your professional profile.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'common.appName' => 'Doctor Hunt',
			'common.email' => 'Email',
			'common.password' => 'Password',
			'common.google' => 'Google',
			'common.facebook' => 'Facebook',
			'common.continueBtn' => 'Continue',
			'common.skip' => 'Skip',
			'common.next' => 'Next',
			'common.getStarted' => 'Get Started',
			'common.name' => 'Name',
			'common.bookNow' => 'Book Now',
			'common.nextAvailable' => 'Next Available',
			'common.search' => 'Search',
			'common.phone' => 'Phone',
			'common.confirmPassword' => 'Confirm Password',
			'common.logout' => 'Logout',
			'common.ok' => 'OK',
			'common.cancel' => 'Cancel',
			'common.undo' => 'Undo',
			'common.notice' => 'Notice',
			'common.confirm' => 'Confirm',
			'common.loading' => 'Loading...',
			'common.errorGeneric' => 'An error occurred. Please try again',
			'common.validation.enterEmail' => 'Enter your email',
			'common.validation.validEmail' => 'Enter a valid email',
			'common.validation.enterPassword' => 'Enter your password',
			'common.validation.minPassword' => 'Min 6 characters',
			'common.validation.enterName' => 'Enter your name',
			'common.validation.enterPhone' => 'Enter your phone number',
			'common.validation.passwordsDoNotMatch' => 'Passwords do not match',
			'common.validation.enterConfirmPassword' => 'Please confirm your password',
			'common.validation.selectRole' => 'Please select a role',
			'onboarding.pages.0.title' => 'Find Trusted Doctors',
			'onboarding.pages.0.description' => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.',
			'onboarding.pages.1.title' => 'Choose Best Doctors',
			'onboarding.pages.1.description' => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.',
			'onboarding.pages.2.title' => 'Easy Appointments',
			'onboarding.pages.2.description' => 'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of it over 2000 years old.',
			'roleSelection.title' => 'Choose your role',
			'roleSelection.subtitle' => 'The selected role determines the experience and available features.',
			'roleSelection.roles.patient.title' => 'Patient',
			'roleSelection.roles.patient.description' => 'Find doctors, book appointments,\nand manage your medical records.',
			'roleSelection.roles.doctor.title' => 'Doctor',
			'roleSelection.roles.doctor.description' => 'Manage appointments, patients,\nand your professional profile.',
			'roleSelection.errorNoRole' => 'Please select a role',
			'auth.login.title' => 'Welcome back',
			'auth.login.subtitle' => 'You can search doctors, book appointments and manage your health',
			'auth.login.forgotPassword' => 'Forgot password',
			'auth.login.forgotPasswordTitle' => 'Reset Password',
			'auth.login.forgotPasswordSubtitle' => 'Enter your email to receive a password reset link',
			'auth.login.forgotPasswordSend' => 'Send Reset Link',
			'auth.login.forgotPasswordSuccess' => 'Reset link sent! Check your email',
			'auth.login.noAccount' => 'Don\'t have an account? ',
			'auth.login.joinUs' => 'Join us',
			'auth.login.submitBtn' => 'Login',
			'auth.login.loggingIn' => 'Logging in...',
			'auth.register.title' => 'Join us to start searching',
			'auth.register.subtitle' => 'You can search doctors, book appointments and manage your health',
			'auth.register.termsPrefix' => 'I agree with the ',
			'auth.register.terms' => 'Terms of Service',
			'auth.register.termsAnd' => ' and ',
			'auth.register.privacy' => 'Privacy Policy',
			'auth.register.acceptTermsError' => 'Please accept the terms',
			'auth.register.haveAccount' => 'Have an account? ',
			'auth.register.loginLink' => 'Log in',
			'auth.register.submitBtn' => 'Sign up',
			'auth.register.specialtyHint' => 'Specialty (e.g. Cardiology)',
			'auth.register.bioHint' => 'Short bio about yourself',
			'auth.register.experienceHint' => 'Years of experience',
			'auth.register.creatingAccount' => 'Creating account...',
			'auth.register.doctorNameHint' => 'Dr. Name',
			'home.liveDoctors' => 'Live Doctors',
			'home.popularDoctor' => 'Popular Doctor',
			'home.featureDoctor' => 'Feature Doctor',
			'home.favouriteDoctors' => 'Favourite Doctors',
			'home.seeAll' => 'See all',
			'home.hiHandwerker' => 'Hi Handwerker!',
			'home.findYourDoctor' => 'Find Your Doctor',
			'home.searchHint' => 'Search.....',
			'home.live' => 'LIVE',
			'home.doctorsFromFirestore' => 'Our Doctors',
			'home.seededSuccess' => 'Seeded doctors to database!',
			'home.mapBookingsPlaceholder' => 'Map / Bookings Screen',
			'home.chatPlaceholder' => 'Chat Screen',
			'home.failedToLoadDoctors' => 'Failed to load doctors',
			'home.noDoctorsAvailable' => 'No doctors available',
			'home.noDoctorsAvailableYet' => 'No doctors available yet',
			'findDoctors.title' => 'Find Doctors',
			'findDoctors.searchHint' => 'Dentist',
			'findDoctors.searchHintExtra' => 'Search doctors, specialties...',
			'findDoctors.recentSearches' => 'Recent Searches',
			'findDoctors.noDoctorsFound' => 'No doctors found',
			'findDoctors.tryDifferentSearchTerm' => 'Try a different search term',
			'findDoctors.yearsExperience' => ({required Object count}) => '${count} Years experience',
			'findDoctors.patientStories' => ({required Object count}) => '${count} Patient Stories',
			'findDoctors.timeTomorrow' => ({required Object time}) => '${time} tomorrow',
			'findDoctors.tenYearsExperience' => '10 years experience',
			'doctorDetails.title' => 'Doctor Details',
			'doctorDetails.specialist' => 'Specialist Cardiologist',
			'doctorDetails.perHour' => ({required Object price}) => '${price}/hr',
			'doctorDetails.running' => 'Running',
			'doctorDetails.ongoing' => 'Ongoing',
			'doctorDetails.patient' => 'Patient',
			'doctorDetails.patients' => 'Patients',
			'doctorDetails.services' => 'Services',
			'doctorDetails.service1' => 'Patient care should be the number one priority.',
			'doctorDetails.service2' => 'If you run your practice you know how frustrating.',
			'doctorDetails.service3' => 'That\'s why some of appointment reminder system.',
			'doctorDetails.doctorInfo' => 'Doctor Info',
			'doctorDetails.removedFromFavorites' => ({required Object doctorName}) => '${doctorName} removed from favorites',
			'favorite.pleaseLogin' => 'Please log in to view favorites',
			'favorite.noFavoriteDoctors' => 'No favorite doctors yet',
			'favorite.tapHeartHint' => 'Tap the heart icon on any doctor to add them here',
			'favorite.doctorRemoved' => ({required Object doctorName}) => '${doctorName} removed from favorites',
			'appointment.successTitle' => 'Thank You !',
			'appointment.successSubtitle' => 'Your Appointment Successful',
			'appointment.successMessage' => ({required Object doctorName, required Object date, required Object time}) => 'You booked an appointment with ${doctorName} on ${date}, at ${time}',
			'appointment.doneBtn' => 'Done',
			'appointment.editBtn' => 'Edit your appointment',
			'updateProfile.title' => 'Complete Registration',
			'updateProfile.bioLabel' => 'Bio',
			'updateProfile.bioHint' => 'Enter general medical information like your academic education and previous experiences...',
			'updateProfile.clinicAddressLabel' => 'Clinic Address',
			'updateProfile.clinicAddressHint' => '123 Main St, Downtown, City',
			'updateProfile.workHoursFrom' => 'Work Hours From',
			'updateProfile.to' => 'To',
			'updateProfile.phone1Label' => 'Phone Number 1',
			'updateProfile.phone2Label' => 'Phone Number 2 (Optional)',
			'updateProfile.phoneHint' => '+20xxxxxxxxxx',
			'updateProfile.selectImageError' => 'Please select a profile image',
			'updateProfile.completeRegistration' => 'Complete Registration',
			'updateProfile.required' => 'Required',
			'updateProfile.specialization' => 'Specialization',
			'updateProfile.chooseSpecialization' => 'Choose specialization',
			'selectTime.title' => 'Select Time',
			'selectTime.today' => ({required Object date}) => 'Today, ${date}',
			'selectTime.tomorrow' => ({required Object date}) => 'Tomorrow, ${date}',
			'selectTime.noSlotsAvailable' => 'No slots available',
			'selectTime.slotsAvailable' => ({required Object count}) => '${count} slots available',
			'selectTime.afternoonSlots' => ({required Object count}) => 'Afternoon ${count} slots',
			'selectTime.eveningSlots' => ({required Object count}) => 'Evening ${count} slots',
			'selectTime.proceed' => 'Proceed',
			'selectTime.nextAvailability' => 'Next availability on Wed, 24 Feb',
			'selectTime.or' => 'OR',
			'selectTime.contactClinic' => 'Contact Clinic',
			'dashboard.title' => 'Doctor Dashboard',
			'dashboard.profile' => 'My Profile',
			'dashboard.appointments' => 'Appointments',
			'dashboard.myPatients' => 'My Patients',
			'dashboard.availability' => 'Availability',
			'dashboard.settings' => 'Settings',
			'dashboard.updateProfile' => 'Update Profile',
			'dashboard.updateProfileSuccess' => 'Profile updated successfully',
			'dashboard.totalPatients' => 'Total Patients',
			'dashboard.completedConsultations' => 'Completed Consultations',
			'dashboard.rating' => 'Rating',
			'dashboard.available' => 'Available',
			'dashboard.unavailable' => 'Unavailable',
			'dashboard.doctorInfo' => 'Doctor Info',
			_ => null,
		};
	}
}
