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
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

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
	late final Translations$admin$en admin = Translations$admin$en._(_root);
	late final Translations$patientProfile$en patientProfile = Translations$patientProfile$en._(_root);
	late final Translations$patientSettings$en patientSettings = Translations$patientSettings$en._(_root);
	late final Translations$privacyPolicy$en privacyPolicy = Translations$privacyPolicy$en._(_root);
	late final Translations$helpCenter$en helpCenter = Translations$helpCenter$en._(_root);
	late final Translations$logoutDialog$en logoutDialog = Translations$logoutDialog$en._(_root);
	late final Translations$menu$en menu = Translations$menu$en._(_root);
	late final Translations$appointments$en appointments = Translations$appointments$en._(_root);
	late final Translations$changePassword$en changePassword = Translations$changePassword$en._(_root);
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

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Delete'
	String get delete => 'Delete';

	/// en: 'Tap back again to exit'
	String get tapBackAgainToExit => 'Tap back again to exit';

	/// en: 'Loading...'
	String get loading => 'Loading...';

	/// en: 'An error occurred. Please try again'
	String get errorGeneric => 'An error occurred. Please try again';

	late final Translations$common$validation$en validation = Translations$common$validation$en._(_root);

	/// en: 'Not provided'
	String get notProvided => 'Not provided';
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

	/// en: 'Password reset email sent'
	String get resetEmailSent => 'Password reset email sent';

	/// en: 'Registration successful'
	String get registrationSuccessful => 'Registration successful';

	late final Translations$auth$errors$en errors = Translations$auth$errors$en._(_root);
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

	/// en: 'Thats why some of appointment reminder system.'
	String get service3 => 'Thats why some of appointment reminder system.';

	/// en: 'Doctor Info'
	String get doctorInfo => 'Doctor Info';

	/// en: 'Rating'
	String get reviews => 'Rating';

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

	/// en: '$doctorName added to favorites'
	String doctorAdded({required Object doctorName}) => '${doctorName} added to favorites';
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

	/// en: 'Next availability on $date'
	String nextAvailabilityOn({required Object date}) => 'Next availability on ${date}';

	/// en: 'No upcoming availability'
	String get noUpcomingDates => 'No upcoming availability';

	/// en: 'Clinic location: $location'
	String clinicLocationLabel({required Object location}) => 'Clinic location: ${location}';

	/// en: 'OR'
	String get or => 'OR';

	/// en: 'Contact Clinic'
	String get contactClinic => 'Contact Clinic';
}

// Path: admin
class Translations$admin$en {
	Translations$admin$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$admin$chooseRole$en chooseRole = Translations$admin$chooseRole$en._(_root);
	late final Translations$admin$login$en login = Translations$admin$login$en._(_root);
	late final Translations$admin$doctors$en doctors = Translations$admin$doctors$en._(_root);
	late final Translations$admin$createDoctor$en createDoctor = Translations$admin$createDoctor$en._(_root);
	late final Translations$admin$editDoctor$en editDoctor = Translations$admin$editDoctor$en._(_root);
	late final Translations$admin$doctorDetails$en doctorDetails = Translations$admin$doctorDetails$en._(_root);
	late final Translations$admin$availability$en availability = Translations$admin$availability$en._(_root);
	late final Translations$admin$editProfile$en editProfile = Translations$admin$editProfile$en._(_root);
	late final Translations$admin$appointments$en appointments = Translations$admin$appointments$en._(_root);
	late final Translations$admin$settings$en settings = Translations$admin$settings$en._(_root);
}

// Path: patientProfile
class Translations$patientProfile$en {
	Translations$patientProfile$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Profile'
	String get title => 'Profile';

	/// en: 'Personal information'
	String get personalInfo => 'Personal information';

	/// en: 'Contact Number'
	String get contactNumber => 'Contact Number';

	/// en: 'Profile updated successfully'
	String get profileUpdated => 'Profile updated successfully';

	/// en: 'No profile data found'
	String get noProfileData => 'No profile data found';
}

// Path: patientSettings
class Translations$patientSettings$en {
	Translations$patientSettings$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Account settings'
	String get accountSettings => 'Account settings';

	/// en: 'Change Password'
	String get changePassword => 'Change Password';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'Privacy Policy'
	String get privacyPolicy => 'Privacy Policy';

	/// en: 'More options'
	String get moreOptions => 'More options';

	/// en: 'Languages'
	String get languages => 'Languages';

	/// en: 'Select language'
	String get selectLanguage => 'Select language';

	/// en: 'English'
	String get languageEnglish => 'English';

	/// en: 'Build version'
	String get buildVersion => 'Build version';
}

// Path: privacyPolicy
class Translations$privacyPolicy$en {
	Translations$privacyPolicy$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Privacy policy'
	String get title => 'Privacy policy';

	/// en: 'Doctor Hunt Apps Privacy Policy'
	String get heading => 'Doctor Hunt Apps Privacy Policy';
}

// Path: helpCenter
class Translations$helpCenter$en {
	Translations$helpCenter$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Help center'
	String get title => 'Help center';

	/// en: 'I have an issue with'
	String get issueHeader => 'I have an issue with';

	/// en: 'Selected: $issue'
	String selectedIssue({required Object issue}) => 'Selected: ${issue}';
}

// Path: logoutDialog
class Translations$logoutDialog$en {
	Translations$logoutDialog$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Log Out'
	String get title => 'Log Out';

	/// en: 'Are you sure you want to logout?'
	String get confirmMessage => 'Are you sure you want to logout?';
}

// Path: menu
class Translations$menu$en {
	Translations$menu$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Favourites'
	String get favourites => 'Favourites';

	/// en: 'My Appointments'
	String get myAppointments => 'My Appointments';

	/// en: 'Profile'
	String get profile => 'Profile';

	/// en: 'Settings'
	String get settings => 'Settings';

	/// en: 'Logout'
	String get logout => 'Logout';
}

// Path: appointments
class Translations$appointments$en {
	Translations$appointments$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Appointments'
	String get title => 'Appointments';

	/// en: 'Upcoming'
	String get upcoming => 'Upcoming';

	/// en: 'Completed'
	String get completed => 'Completed';

	/// en: 'Cancelled'
	String get cancelled => 'Cancelled';

	/// en: 'Patient'
	String get patient => 'Patient';

	/// en: 'Appointment date'
	String get appointmentDate => 'Appointment date';

	/// en: 'Appointment time'
	String get appointmentTime => 'Appointment time';

	/// en: 'Consultation fee'
	String get consultationFee => 'Consultation fee';

	/// en: 'View Details'
	String get viewDetails => 'View Details';

	/// en: 'Cancel Appointment'
	String get cancelAppointment => 'Cancel Appointment';

	/// en: 'Rate Doctor'
	String get rateDoctor => 'Rate Doctor';

	/// en: 'Tap to rate your visit'
	String get tapToRate => 'Tap to rate your visit';

	/// en: 'No upcoming appointments'
	String get noUpcoming => 'No upcoming appointments';

	/// en: 'No completed appointments'
	String get noCompleted => 'No completed appointments';

	/// en: 'No cancelled appointments'
	String get noCancelled => 'No cancelled appointments';

	/// en: 'Cancel Appointment'
	String get cancelConfirmTitle => 'Cancel Appointment';

	/// en: 'Are you sure you want to cancel this appointment?'
	String get cancelConfirmMessage => 'Are you sure you want to cancel this appointment?';

	/// en: 'Appointment cancelled'
	String get cancelSuccess => 'Appointment cancelled';

	/// en: 'Failed to cancel appointment'
	String get cancelFailed => 'Failed to cancel appointment';

	/// en: 'Thank you for your review!'
	String get reviewSuccess => 'Thank you for your review!';

	/// en: 'Failed to submit review'
	String get reviewFailed => 'Failed to submit review';

	/// en: 'Book an appointment with a doctor to see it here.'
	String get noUpcomingSubtitle => 'Book an appointment with a doctor to see it here.';

	/// en: 'Your completed appointments will appear here.'
	String get noCompletedSubtitle => 'Your completed appointments will appear here.';

	/// en: 'Your cancelled appointments will appear here.'
	String get noCancelledSubtitle => 'Your cancelled appointments will appear here.';
}

// Path: changePassword
class Translations$changePassword$en {
	Translations$changePassword$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Change Password'
	String get title => 'Change Password';

	/// en: 'Current Password'
	String get currentPassword => 'Current Password';

	/// en: 'New Password'
	String get newPassword => 'New Password';

	/// en: 'Confirm New Password'
	String get confirmNewPassword => 'Confirm New Password';

	/// en: 'Update Password'
	String get updatePassword => 'Update Password';

	/// en: 'Updating...'
	String get updating => 'Updating...';

	/// en: 'Password updated successfully'
	String get success => 'Password updated successfully';

	/// en: 'Failed to update password'
	String get failed => 'Failed to update password';

	/// en: 'Please enter your current password'
	String get currentPasswordRequired => 'Please enter your current password';
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

	/// en: 'Please enter $field'
	String fieldRequired({required Object field}) => 'Please enter ${field}';

	/// en: 'Please enter a valid number'
	String get invalidNumber => 'Please enter a valid number';

	/// en: 'Enter a valid phone number'
	String get validPhone => 'Enter a valid phone number';
}

// Path: onboarding.pages.0
class Translations$onboarding$pages$0$en {
	Translations$onboarding$pages$0$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Find Trusted Doctors'
	String get title => 'Find Trusted Doctors';

	/// en: 'Contrary to popular belief, Lorem Ipsum is not simply random text.'
	String get description => 'Contrary to popular belief, Lorem Ipsum is not simply random text.';
}

// Path: onboarding.pages.1
class Translations$onboarding$pages$1$en {
	Translations$onboarding$pages$1$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Choose Best Doctors'
	String get title => 'Choose Best Doctors';

	/// en: 'Contrary to popular belief, Lorem Ipsum is not simply random text.'
	String get description => 'Contrary to popular belief, Lorem Ipsum is not simply random text.';
}

// Path: onboarding.pages.2
class Translations$onboarding$pages$2$en {
	Translations$onboarding$pages$2$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Easy Appointments'
	String get title => 'Easy Appointments';

	/// en: 'Contrary to popular belief, Lorem Ipsum is not simply random text.'
	String get description => 'Contrary to popular belief, Lorem Ipsum is not simply random text.';
}

// Path: roleSelection.roles
class Translations$roleSelection$roles$en {
	Translations$roleSelection$roles$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$roleSelection$roles$patient$en patient = Translations$roleSelection$roles$patient$en._(_root);
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

	/// en: 'Forgot password'
	String get forgotPasswordTitle => 'Forgot password';

	/// en: 'Enter your email and we will send you a link to reset your password.'
	String get forgotPasswordSubtitle => 'Enter your email and we will send you a link to reset your password.';

	/// en: 'Send Reset Link'
	String get forgotPasswordSend => 'Send Reset Link';

	/// en: 'Sending...'
	String get forgotPasswordSending => 'Sending...';

	/// en: 'Reset link sent! Check your email'
	String get forgotPasswordSuccess => 'Reset link sent! Check your email';

	/// en: 'Unable to send the reset email. Please try again.'
	String get forgotPasswordError => 'Unable to send the reset email. Please try again.';

	/// en: 'Dont have an account? '
	String get noAccount => 'Dont have an account? ';

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

	/// en: 'Creating account...'
	String get creatingAccount => 'Creating account...';
}

// Path: auth.errors
class Translations$auth$errors$en {
	Translations$auth$errors$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No account found with this email.'
	String get noAccountFound => 'No account found with this email.';

	/// en: 'You cannot log in here. Please use the admin login screen.'
	String get useAdminLogin => 'You cannot log in here. Please use the admin login screen.';

	/// en: 'User not found after login'
	String get userNotFound => 'User not found after login';
}

// Path: admin.chooseRole
class Translations$admin$chooseRole$en {
	Translations$admin$chooseRole$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Admin'
	String get title => 'Admin';

	/// en: 'Manage doctors and app settings'
	String get description => 'Manage doctors and app settings';
}

// Path: admin.login
class Translations$admin$login$en {
	Translations$admin$login$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Welcome Back!'
	String get title => 'Welcome Back!';

	/// en: 'Login to your admin account'
	String get subtitle => 'Login to your admin account';

	/// en: 'Remember me'
	String get rememberMe => 'Remember me';

	/// en: 'Login'
	String get loginBtn => 'Login';

	/// en: 'Secure admin access only'
	String get secureAccess => 'Secure admin access only';

	/// en: 'Access denied. You are not an admin.'
	String get accessDenied => 'Access denied. You are not an admin.';
}

// Path: admin.doctors
class Translations$admin$doctors$en {
	Translations$admin$doctors$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Doctors'
	String get title => 'Doctors';

	/// en: 'Add Doctor'
	String get addDoctor => 'Add Doctor';

	/// en: 'Search doctors...'
	String get searchHint => 'Search doctors...';

	/// en: 'Total Doctors'
	String get totalDoctors => 'Total Doctors';

	/// en: 'Active'
	String get active => 'Active';

	/// en: 'No doctors found'
	String get noDoctorsFound => 'No doctors found';

	/// en: 'Delete Doctor'
	String get deleteTitle => 'Delete Doctor';

	/// en: 'Are you sure you want to remove Dr. @name?'
	String get deleteConfirm => 'Are you sure you want to remove Dr. @name?';

	/// en: 'Dr. @name deleted'
	String get deleted => 'Dr. @name deleted';
}

// Path: admin.createDoctor
class Translations$admin$createDoctor$en {
	Translations$admin$createDoctor$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Create Doctor'
	String get title => 'Create Doctor';

	/// en: 'Doctor Name'
	String get nameLabel => 'Doctor Name';

	/// en: 'e.g. Dr. Ahmed Ali'
	String get nameHint => 'e.g. Dr. Ahmed Ali';

	/// en: 'doctor@email.com'
	String get emailHint => 'doctor@email.com';

	/// en: '+20xxxxxxxxxx'
	String get phoneHint => '+20xxxxxxxxxx';

	/// en: 'Specialty'
	String get specialtyLabel => 'Specialty';

	/// en: 'Select specialty'
	String get specialtyHint => 'Select specialty';

	/// en: 'Consultation Fee'
	String get feeLabel => 'Consultation Fee';

	/// en: 'e.g. \$28.00'
	String get feeHint => 'e.g. \$28.00';

	/// en: 'Doctor Status'
	String get statusLabel => 'Doctor Status';

	/// en: 'Active & Available'
	String get statusSubtitle => 'Active & Available';

	/// en: 'Bio'
	String get bioLabel => 'Bio';

	/// en: 'Brief description about the doctor...'
	String get bioHint => 'Brief description about the doctor...';

	/// en: 'Clinic Address'
	String get addressLabel => 'Clinic Address';

	/// en: '123 Main St, Downtown, City'
	String get addressHint => '123 Main St, Downtown, City';

	/// en: 'Doctor Image'
	String get imageLabel => 'Doctor Image';

	/// en: 'Upload doctor image'
	String get imageUpload => 'Upload doctor image';

	/// en: 'Tap to pick an image'
	String get imageTapHint => 'Tap to pick an image';

	/// en: 'Add photo'
	String get addPhoto => 'Add photo';

	/// en: 'Tap photo to change'
	String get tapPhotoToChange => 'Tap photo to change';

	/// en: 'Create Doctor'
	String get createBtn => 'Create Doctor';

	/// en: 'Creating...'
	String get creatingBtn => 'Creating...';

	/// en: 'Doctor created successfully'
	String get success => 'Doctor created successfully';

	/// en: 'Failed to create doctor'
	String get failed => 'Failed to create doctor';
}

// Path: admin.editDoctor
class Translations$admin$editDoctor$en {
	Translations$admin$editDoctor$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Edit Doctor'
	String get title => 'Edit Doctor';

	/// en: 'Save Changes'
	String get updateBtn => 'Save Changes';

	/// en: 'Saving...'
	String get updatingBtn => 'Saving...';

	/// en: 'Delete Doctor'
	String get deleteBtn => 'Delete Doctor';

	/// en: 'Doctor deleted successfully'
	String get deletedSuccess => 'Doctor deleted successfully';

	/// en: 'Doctor updated successfully'
	String get success => 'Doctor updated successfully';

	/// en: 'Failed to update doctor'
	String get failed => 'Failed to update doctor';
}

// Path: admin.doctorDetails
class Translations$admin$doctorDetails$en {
	Translations$admin$doctorDetails$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Doctor Details'
	String get title => 'Doctor Details';

	/// en: 'Doctor Info'
	String get doctorInfo => 'Doctor Info';

	/// en: 'Specialty'
	String get specialty => 'Specialty';

	/// en: 'Account Status'
	String get accountStatus => 'Account Status';

	/// en: 'Active'
	String get active => 'Active';

	/// en: 'Inactive'
	String get inactive => 'Inactive';

	/// en: 'Edit Doctor'
	String get editDoctor => 'Edit Doctor';

	/// en: 'Delete Doctor'
	String get deleteDoctor => 'Delete Doctor';
}

// Path: admin.availability
class Translations$admin$availability$en {
	Translations$admin$availability$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Doctor Availability'
	String get title => 'Doctor Availability';

	/// en: 'Working Days'
	String get workingDays => 'Working Days';

	/// en: 'Working Hours'
	String get workingHours => 'Working Hours';

	/// en: 'START TIME'
	String get startTime => 'START TIME';

	/// en: 'END TIME'
	String get endTime => 'END TIME';

	/// en: '$count days enabled'
	String daysEnabled({required Object count}) => '${count} days enabled';

	/// en: 'Availability updated successfully'
	String get updated => 'Availability updated successfully';

	/// en: 'Failed to update availability'
	String get failed => 'Failed to update availability';
}

// Path: admin.editProfile
class Translations$admin$editProfile$en {
	Translations$admin$editProfile$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Edit Profile'
	String get title => 'Edit Profile';

	/// en: 'Tap photo to change'
	String get tapPhotoToChange => 'Tap photo to change';

	/// en: 'FULL NAME'
	String get fullName => 'FULL NAME';

	/// en: 'EMAIL ADDRESS'
	String get emailAddress => 'EMAIL ADDRESS';

	/// en: 'Save Changes'
	String get saveChanges => 'Save Changes';

	/// en: 'Saving...'
	String get saving => 'Saving...';

	/// en: 'Email change requires re-authentication'
	String get reauthRequired => 'Email change requires re-authentication';

	/// en: 'Profile updated successfully'
	String get success => 'Profile updated successfully';

	/// en: 'Failed to update profile'
	String get failed => 'Failed to update profile';
}

// Path: admin.appointments
class Translations$admin$appointments$en {
	Translations$admin$appointments$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Appointments'
	String get title => 'Appointments';

	/// en: 'Appointment Details'
	String get detailsTitle => 'Appointment Details';

	/// en: 'Appointment not found.'
	String get notFound => 'Appointment not found.';

	/// en: 'Mark as Completed'
	String get markCompleted => 'Mark as Completed';

	/// en: 'Cancel Appointment'
	String get cancelAppointment => 'Cancel Appointment';

	/// en: 'View Details'
	String get viewDetails => 'View Details';

	/// en: 'Patient'
	String get patient => 'Patient';

	/// en: 'Doctor'
	String get doctor => 'Doctor';

	/// en: 'Appointment'
	String get appointment => 'Appointment';

	/// en: 'Upcoming'
	String get upcoming => 'Upcoming';

	/// en: 'Completed'
	String get completed => 'Completed';

	/// en: 'Cancelled'
	String get cancelled => 'Cancelled';

	/// en: 'Date'
	String get date => 'Date';

	/// en: 'Time'
	String get time => 'Time';

	/// en: 'Fee'
	String get fee => 'Fee';

	/// en: 'Consultation fee'
	String get consultationFee => 'Consultation fee';

	/// en: 'Clinic location'
	String get clinicLocation => 'Clinic location';

	/// en: 'Complete Appointment'
	String get completeConfirmTitle => 'Complete Appointment';

	/// en: 'Are you sure you want to mark this appointment as completed?'
	String get completeConfirmMessage => 'Are you sure you want to mark this appointment as completed?';

	/// en: 'Cancel Appointment'
	String get cancelConfirmTitle => 'Cancel Appointment';

	/// en: 'Are you sure you want to cancel this appointment?'
	String get cancelConfirmMessage => 'Are you sure you want to cancel this appointment?';

	/// en: 'Appointment marked as completed'
	String get completeSuccess => 'Appointment marked as completed';

	/// en: 'Appointment cancelled successfully'
	String get cancelSuccess => 'Appointment cancelled successfully';

	/// en: 'No upcoming appointments'
	String get noUpcoming => 'No upcoming appointments';

	/// en: 'No completed appointments'
	String get noCompleted => 'No completed appointments';

	/// en: 'No cancelled appointments'
	String get noCancelled => 'No cancelled appointments';
}

// Path: admin.settings
class Translations$admin$settings$en {
	Translations$admin$settings$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'App Settings'
	String get appSettings => 'App Settings';

	/// en: 'Push Notifications'
	String get pushNotif => 'Push Notifications';

	/// en: 'Enable push notifications for all users'
	String get pushNotifDesc => 'Enable push notifications for all users';

	/// en: 'Email Notifications'
	String get emailNotif => 'Email Notifications';

	/// en: 'Send email notifications for important events'
	String get emailNotifDesc => 'Send email notifications for important events';

	/// en: 'Doctor Management'
	String get doctorManagement => 'Doctor Management';

	/// en: 'Auto-Approve Doctors'
	String get autoApprove => 'Auto-Approve Doctors';

	/// en: 'Automatically approve new doctor registrations'
	String get autoApproveDesc => 'Automatically approve new doctor registrations';

	/// en: 'System'
	String get system => 'System';

	/// en: 'Maintenance Mode'
	String get maintenance => 'Maintenance Mode';

	/// en: 'Put the app in maintenance mode for all users'
	String get maintenanceDesc => 'Put the app in maintenance mode for all users';

	/// en: 'Dark Mode'
	String get darkMode => 'Dark Mode';

	/// en: 'Enable dark mode for admin interface'
	String get darkModeDesc => 'Enable dark mode for admin interface';

	/// en: 'Account'
	String get account => 'Account';

	/// en: 'Admin Profile'
	String get adminProfile => 'Admin Profile';

	/// en: 'Edit admin details & permissions'
	String get adminProfileDesc => 'Edit admin details & permissions';

	/// en: 'Change Password'
	String get changePassword => 'Change Password';

	/// en: 'Update admin security credentials'
	String get changePasswordDesc => 'Update admin security credentials';

	/// en: 'Notification Preferences'
	String get notificationPreferences => 'Notification Preferences';

	/// en: 'Manage notification settings'
	String get notificationPreferencesDesc => 'Manage notification settings';

	/// en: 'App Information'
	String get appInformation => 'App Information';

	/// en: 'App version'
	String get appVersion => 'App version';

	/// en: 'Help & Support'
	String get helpSupport => 'Help & Support';

	/// en: 'Get help with the admin panel'
	String get helpSupportDesc => 'Get help with the admin panel';

	/// en: 'About'
	String get about => 'About';

	/// en: 'App version and information'
	String get aboutDesc => 'App version and information';
}

// Path: roleSelection.roles.patient
class Translations$roleSelection$roles$patient$en {
	Translations$roleSelection$roles$patient$en._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Patient'
	String get title => 'Patient';

	/// en: 'Find doctors, book appointments, and manage your visits.'
	String get description => 'Find doctors, book appointments, and manage your visits.';
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
			'common.edit' => 'Edit',
			'common.delete' => 'Delete',
			'common.tapBackAgainToExit' => 'Tap back again to exit',
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
			'common.validation.fieldRequired' => ({required Object field}) => 'Please enter ${field}',
			'common.validation.invalidNumber' => 'Please enter a valid number',
			'common.validation.validPhone' => 'Enter a valid phone number',
			'common.notProvided' => 'Not provided',
			'onboarding.pages.0.title' => 'Find Trusted Doctors',
			'onboarding.pages.0.description' => 'Contrary to popular belief, Lorem Ipsum is not simply random text.',
			'onboarding.pages.1.title' => 'Choose Best Doctors',
			'onboarding.pages.1.description' => 'Contrary to popular belief, Lorem Ipsum is not simply random text.',
			'onboarding.pages.2.title' => 'Easy Appointments',
			'onboarding.pages.2.description' => 'Contrary to popular belief, Lorem Ipsum is not simply random text.',
			'roleSelection.title' => 'Choose your role',
			'roleSelection.subtitle' => 'The selected role determines the experience and available features.',
			'roleSelection.roles.patient.title' => 'Patient',
			'roleSelection.roles.patient.description' => 'Find doctors, book appointments, and manage your visits.',
			'roleSelection.errorNoRole' => 'Please select a role',
			'auth.login.title' => 'Welcome back',
			'auth.login.subtitle' => 'You can search doctors, book appointments and manage your health',
			'auth.login.forgotPassword' => 'Forgot password',
			'auth.login.forgotPasswordTitle' => 'Forgot password',
			'auth.login.forgotPasswordSubtitle' => 'Enter your email and we will send you a link to reset your password.',
			'auth.login.forgotPasswordSend' => 'Send Reset Link',
			'auth.login.forgotPasswordSending' => 'Sending...',
			'auth.login.forgotPasswordSuccess' => 'Reset link sent! Check your email',
			'auth.login.forgotPasswordError' => 'Unable to send the reset email. Please try again.',
			'auth.login.noAccount' => 'Dont have an account? ',
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
			'auth.register.creatingAccount' => 'Creating account...',
			'auth.resetEmailSent' => 'Password reset email sent',
			'auth.registrationSuccessful' => 'Registration successful',
			'auth.errors.noAccountFound' => 'No account found with this email.',
			'auth.errors.useAdminLogin' => 'You cannot log in here. Please use the admin login screen.',
			'auth.errors.userNotFound' => 'User not found after login',
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
			'doctorDetails.service3' => 'Thats why some of appointment reminder system.',
			'doctorDetails.doctorInfo' => 'Doctor Info',
			'doctorDetails.reviews' => 'Rating',
			'doctorDetails.removedFromFavorites' => ({required Object doctorName}) => '${doctorName} removed from favorites',
			'favorite.pleaseLogin' => 'Please log in to view favorites',
			'favorite.noFavoriteDoctors' => 'No favorite doctors yet',
			'favorite.tapHeartHint' => 'Tap the heart icon on any doctor to add them here',
			'favorite.doctorRemoved' => ({required Object doctorName}) => '${doctorName} removed from favorites',
			'favorite.doctorAdded' => ({required Object doctorName}) => '${doctorName} added to favorites',
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
			'selectTime.nextAvailabilityOn' => ({required Object date}) => 'Next availability on ${date}',
			'selectTime.noUpcomingDates' => 'No upcoming availability',
			'selectTime.clinicLocationLabel' => ({required Object location}) => 'Clinic location: ${location}',
			'selectTime.or' => 'OR',
			'selectTime.contactClinic' => 'Contact Clinic',
			'admin.chooseRole.title' => 'Admin',
			'admin.chooseRole.description' => 'Manage doctors and app settings',
			'admin.login.title' => 'Welcome Back!',
			'admin.login.subtitle' => 'Login to your admin account',
			'admin.login.rememberMe' => 'Remember me',
			'admin.login.loginBtn' => 'Login',
			'admin.login.secureAccess' => 'Secure admin access only',
			'admin.login.accessDenied' => 'Access denied. You are not an admin.',
			'admin.doctors.title' => 'Doctors',
			'admin.doctors.addDoctor' => 'Add Doctor',
			'admin.doctors.searchHint' => 'Search doctors...',
			'admin.doctors.totalDoctors' => 'Total Doctors',
			'admin.doctors.active' => 'Active',
			'admin.doctors.noDoctorsFound' => 'No doctors found',
			'admin.doctors.deleteTitle' => 'Delete Doctor',
			'admin.doctors.deleteConfirm' => 'Are you sure you want to remove Dr. @name?',
			'admin.doctors.deleted' => 'Dr. @name deleted',
			'admin.createDoctor.title' => 'Create Doctor',
			'admin.createDoctor.nameLabel' => 'Doctor Name',
			'admin.createDoctor.nameHint' => 'e.g. Dr. Ahmed Ali',
			'admin.createDoctor.emailHint' => 'doctor@email.com',
			'admin.createDoctor.phoneHint' => '+20xxxxxxxxxx',
			'admin.createDoctor.specialtyLabel' => 'Specialty',
			'admin.createDoctor.specialtyHint' => 'Select specialty',
			'admin.createDoctor.feeLabel' => 'Consultation Fee',
			'admin.createDoctor.feeHint' => 'e.g. \$28.00',
			'admin.createDoctor.statusLabel' => 'Doctor Status',
			'admin.createDoctor.statusSubtitle' => 'Active & Available',
			'admin.createDoctor.bioLabel' => 'Bio',
			'admin.createDoctor.bioHint' => 'Brief description about the doctor...',
			'admin.createDoctor.addressLabel' => 'Clinic Address',
			'admin.createDoctor.addressHint' => '123 Main St, Downtown, City',
			'admin.createDoctor.imageLabel' => 'Doctor Image',
			'admin.createDoctor.imageUpload' => 'Upload doctor image',
			'admin.createDoctor.imageTapHint' => 'Tap to pick an image',
			'admin.createDoctor.addPhoto' => 'Add photo',
			'admin.createDoctor.tapPhotoToChange' => 'Tap photo to change',
			'admin.createDoctor.createBtn' => 'Create Doctor',
			'admin.createDoctor.creatingBtn' => 'Creating...',
			'admin.createDoctor.success' => 'Doctor created successfully',
			'admin.createDoctor.failed' => 'Failed to create doctor',
			'admin.editDoctor.title' => 'Edit Doctor',
			'admin.editDoctor.updateBtn' => 'Save Changes',
			'admin.editDoctor.updatingBtn' => 'Saving...',
			'admin.editDoctor.deleteBtn' => 'Delete Doctor',
			'admin.editDoctor.deletedSuccess' => 'Doctor deleted successfully',
			'admin.editDoctor.success' => 'Doctor updated successfully',
			'admin.editDoctor.failed' => 'Failed to update doctor',
			'admin.doctorDetails.title' => 'Doctor Details',
			'admin.doctorDetails.doctorInfo' => 'Doctor Info',
			'admin.doctorDetails.specialty' => 'Specialty',
			'admin.doctorDetails.accountStatus' => 'Account Status',
			'admin.doctorDetails.active' => 'Active',
			'admin.doctorDetails.inactive' => 'Inactive',
			'admin.doctorDetails.editDoctor' => 'Edit Doctor',
			'admin.doctorDetails.deleteDoctor' => 'Delete Doctor',
			'admin.availability.title' => 'Doctor Availability',
			'admin.availability.workingDays' => 'Working Days',
			'admin.availability.workingHours' => 'Working Hours',
			'admin.availability.startTime' => 'START TIME',
			'admin.availability.endTime' => 'END TIME',
			'admin.availability.daysEnabled' => ({required Object count}) => '${count} days enabled',
			'admin.availability.updated' => 'Availability updated successfully',
			'admin.availability.failed' => 'Failed to update availability',
			'admin.editProfile.title' => 'Edit Profile',
			'admin.editProfile.tapPhotoToChange' => 'Tap photo to change',
			'admin.editProfile.fullName' => 'FULL NAME',
			'admin.editProfile.emailAddress' => 'EMAIL ADDRESS',
			'admin.editProfile.saveChanges' => 'Save Changes',
			'admin.editProfile.saving' => 'Saving...',
			'admin.editProfile.reauthRequired' => 'Email change requires re-authentication',
			'admin.editProfile.success' => 'Profile updated successfully',
			'admin.editProfile.failed' => 'Failed to update profile',
			'admin.appointments.title' => 'Appointments',
			'admin.appointments.detailsTitle' => 'Appointment Details',
			'admin.appointments.notFound' => 'Appointment not found.',
			'admin.appointments.markCompleted' => 'Mark as Completed',
			'admin.appointments.cancelAppointment' => 'Cancel Appointment',
			'admin.appointments.viewDetails' => 'View Details',
			'admin.appointments.patient' => 'Patient',
			'admin.appointments.doctor' => 'Doctor',
			'admin.appointments.appointment' => 'Appointment',
			'admin.appointments.upcoming' => 'Upcoming',
			'admin.appointments.completed' => 'Completed',
			'admin.appointments.cancelled' => 'Cancelled',
			'admin.appointments.date' => 'Date',
			'admin.appointments.time' => 'Time',
			'admin.appointments.fee' => 'Fee',
			'admin.appointments.consultationFee' => 'Consultation fee',
			'admin.appointments.clinicLocation' => 'Clinic location',
			'admin.appointments.completeConfirmTitle' => 'Complete Appointment',
			'admin.appointments.completeConfirmMessage' => 'Are you sure you want to mark this appointment as completed?',
			'admin.appointments.cancelConfirmTitle' => 'Cancel Appointment',
			'admin.appointments.cancelConfirmMessage' => 'Are you sure you want to cancel this appointment?',
			'admin.appointments.completeSuccess' => 'Appointment marked as completed',
			'admin.appointments.cancelSuccess' => 'Appointment cancelled successfully',
			'admin.appointments.noUpcoming' => 'No upcoming appointments',
			'admin.appointments.noCompleted' => 'No completed appointments',
			'admin.appointments.noCancelled' => 'No cancelled appointments',
			'admin.settings.title' => 'Settings',
			'admin.settings.appSettings' => 'App Settings',
			'admin.settings.pushNotif' => 'Push Notifications',
			'admin.settings.pushNotifDesc' => 'Enable push notifications for all users',
			'admin.settings.emailNotif' => 'Email Notifications',
			'admin.settings.emailNotifDesc' => 'Send email notifications for important events',
			'admin.settings.doctorManagement' => 'Doctor Management',
			'admin.settings.autoApprove' => 'Auto-Approve Doctors',
			'admin.settings.autoApproveDesc' => 'Automatically approve new doctor registrations',
			'admin.settings.system' => 'System',
			'admin.settings.maintenance' => 'Maintenance Mode',
			'admin.settings.maintenanceDesc' => 'Put the app in maintenance mode for all users',
			'admin.settings.darkMode' => 'Dark Mode',
			'admin.settings.darkModeDesc' => 'Enable dark mode for admin interface',
			'admin.settings.account' => 'Account',
			'admin.settings.adminProfile' => 'Admin Profile',
			'admin.settings.adminProfileDesc' => 'Edit admin details & permissions',
			'admin.settings.changePassword' => 'Change Password',
			'admin.settings.changePasswordDesc' => 'Update admin security credentials',
			'admin.settings.notificationPreferences' => 'Notification Preferences',
			'admin.settings.notificationPreferencesDesc' => 'Manage notification settings',
			'admin.settings.appInformation' => 'App Information',
			'admin.settings.appVersion' => 'App version',
			'admin.settings.helpSupport' => 'Help & Support',
			'admin.settings.helpSupportDesc' => 'Get help with the admin panel',
			'admin.settings.about' => 'About',
			'admin.settings.aboutDesc' => 'App version and information',
			'patientProfile.title' => 'Profile',
			'patientProfile.personalInfo' => 'Personal information',
			'patientProfile.contactNumber' => 'Contact Number',
			'patientProfile.profileUpdated' => 'Profile updated successfully',
			'patientProfile.noProfileData' => 'No profile data found',
			'patientSettings.title' => 'Settings',
			'patientSettings.accountSettings' => 'Account settings',
			'patientSettings.changePassword' => 'Change Password',
			'patientSettings.notifications' => 'Notifications',
			'patientSettings.privacyPolicy' => 'Privacy Policy',
			'patientSettings.moreOptions' => 'More options',
			'patientSettings.languages' => 'Languages',
			'patientSettings.selectLanguage' => 'Select language',
			'patientSettings.languageEnglish' => 'English',
			'patientSettings.buildVersion' => 'Build version',
			'privacyPolicy.title' => 'Privacy policy',
			'privacyPolicy.heading' => 'Doctor Hunt Apps Privacy Policy',
			'helpCenter.title' => 'Help center',
			'helpCenter.issueHeader' => 'I have an issue with',
			'helpCenter.selectedIssue' => ({required Object issue}) => 'Selected: ${issue}',
			'logoutDialog.title' => 'Log Out',
			'logoutDialog.confirmMessage' => 'Are you sure you want to logout?',
			'menu.home' => 'Home',
			'menu.favourites' => 'Favourites',
			'menu.myAppointments' => 'My Appointments',
			'menu.profile' => 'Profile',
			'menu.settings' => 'Settings',
			'menu.logout' => 'Logout',
			'appointments.title' => 'Appointments',
			'appointments.upcoming' => 'Upcoming',
			'appointments.completed' => 'Completed',
			'appointments.cancelled' => 'Cancelled',
			'appointments.patient' => 'Patient',
			'appointments.appointmentDate' => 'Appointment date',
			'appointments.appointmentTime' => 'Appointment time',
			'appointments.consultationFee' => 'Consultation fee',
			'appointments.viewDetails' => 'View Details',
			'appointments.cancelAppointment' => 'Cancel Appointment',
			'appointments.rateDoctor' => 'Rate Doctor',
			'appointments.tapToRate' => 'Tap to rate your visit',
			'appointments.noUpcoming' => 'No upcoming appointments',
			'appointments.noCompleted' => 'No completed appointments',
			'appointments.noCancelled' => 'No cancelled appointments',
			'appointments.cancelConfirmTitle' => 'Cancel Appointment',
			'appointments.cancelConfirmMessage' => 'Are you sure you want to cancel this appointment?',
			'appointments.cancelSuccess' => 'Appointment cancelled',
			'appointments.cancelFailed' => 'Failed to cancel appointment',
			'appointments.reviewSuccess' => 'Thank you for your review!',
			'appointments.reviewFailed' => 'Failed to submit review',
			'appointments.noUpcomingSubtitle' => 'Book an appointment with a doctor to see it here.',
			'appointments.noCompletedSubtitle' => 'Your completed appointments will appear here.',
			'appointments.noCancelledSubtitle' => 'Your cancelled appointments will appear here.',
			'changePassword.title' => 'Change Password',
			'changePassword.currentPassword' => 'Current Password',
			'changePassword.newPassword' => 'New Password',
			'changePassword.confirmNewPassword' => 'Confirm New Password',
			'changePassword.updatePassword' => 'Update Password',
			'changePassword.updating' => 'Updating...',
			'changePassword.success' => 'Password updated successfully',
			'changePassword.failed' => 'Failed to update password',
			'changePassword.currentPasswordRequired' => 'Please enter your current password',
			_ => null,
		};
	}
}
