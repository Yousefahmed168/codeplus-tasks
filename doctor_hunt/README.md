<p align="center">
  <img src="assets/images/app_logo.png" alt="Doctor Hunt logo" width="120">
</p>

<h1 align="center">Doctor Hunt</h1>

<p align="center">
  A Flutter clinic appointment-booking app with a patient side and a single clinic-admin panel.<br>
  Patients find a doctor, book a slot, manage the booking and rate the doctor.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-Mobile_App-02569B?logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/flutter__bloc-State_Management-8A2BE2" alt="flutter_bloc">
  <img src="https://img.shields.io/badge/Firebase-Auth_+_Firestore-FFCA28?logo=firebase" alt="Firebase">
  <img src="https://img.shields.io/badge/go__router-Navigation-00A8E8" alt="go_router">
  <img src="https://img.shields.io/badge/slang-Localization-2E7D32" alt="slang">
</p>

---

## Demo

<p align="center">
  <video src="docs/demo.mp4" width="300" controls muted playsinline></video>
</p>

<p align="center">
  ▶ <a href="docs/demo.mp4"><b>Watch the app demo</b></a>
</p>

---

## Overview

- **What it does** — Patients browse or search doctors, filter by specialty, save favorites, open a full doctor profile, pick a free slot on a 7-day calendar, and confirm a booking. They then manage everything from My Appointments and rate the doctor once the visit is completed.
- **The problem it solves** — It replaces phone-call scheduling with a self-service mobile flow, and removes the "which doctor is available when?" guesswork by keeping every doctor's weekly schedule and slot length in one place.
- **Main user workflow** — Log in / register → discover doctors (categories, popular list, search, favorites) → doctor details → select time → review & confirm → appointment confirmed (visible in My Appointments, cancelable, ratable).
- **Who manages the data** — Doctors are created and maintained entirely by the **clinic admin**. There is no doctor app, no doctor login and no doctor self-registration. The app has exactly one clinic location, edited by the admin and shown everywhere a location appears.

## Roles

| Role | What they can do |
| --- | --- |
| **Patient** | Auth, discovery, search, favorites, booking, appointments, ratings, profile |
| **Clinic admin** | Manage doctors, availability, appointments, clinic location, own profile |

## Features

### Patient

- **Doctor discovery** — home screen with specialty categories, popular doctors, featured doctors and the next appointment card
- **Doctor search** — live search by doctor name or specialty with a clear/reset action
- **Specialty filtering** — filter doctors by any of the supported specialties
- **Doctor details** — rating, reviews, specialty, consultation fee and the central clinic location
- **Favorites** — save and remove favorite doctors (heart action on cards and details)
- **Slot booking** — a 7-day calendar built from each doctor's weekly working days, working hours and slot length; past slots for today are hidden automatically
- **Review & confirm** — a read-only summary of doctor, date, time, fee and location before the booking is created
- **My Appointments** — grouped into Upcoming, Completed and Cancelled; cancel an upcoming visit and rate a completed one

### Admin

- **Admin login** — separate entry point; the account must exist in the `admins` collection
- **Doctors list** — every doctor, including deactivated ones
- **Create doctor** — photo, name, specialty and consultation fee
- **Edit doctor** — update the profile and photo
- **Activate / deactivate** — doctors are never deleted; deactivated doctors disappear from the patient app
- **Doctor availability** — weekly working days, start/end time and slot duration
- **Appointments** — All / Upcoming / Completed / Cancelled tabs, with embedded patient contact details; mark completed or cancel
- **Clinic profile** — edit the single central clinic location (and admin name / e-mail), plus change password

## Specialties

Doctors are classified using this fixed list, defined once in `lib/core/constants/specializations.dart` and reused by the admin forms and the patient filters:

## Booking Flow

```text
Doctor
  ↓
Doctor Details
  ↓
Select Time        (dates from the doctor's working days, slots from start/end time + slot duration,
  ↓                 past slots for today removed client-side)
Review & Confirm   (read-only summary of doctor, date, time, fee and clinic location)
  ↓
Confirm Booking    (creates the appointment with status "upcoming")
  ↓
Appointment Confirmed
```

- **Cancellation** — sets the appointment status to `cancelled`; the visit stays visible under the Cancelled tab.
- **Ratings** — only appointments in `completed` status can be rated, and only once; the doctor's average rating and review count are recalculated afterwards.
- **Statuses are limited to** `upcoming`, `completed`, `cancelled` — there are no other states.


## Project Structure

```text
doctor_hunt/
├── android/                    # Android platform code
├── assets/                     # Onboarding images, doctor placeholders, icons
├── lib/
│   ├── core/
│   │   ├── constants/          # Assets, icon aliases, medical specializations
│   │   ├── di/                 # get_it service locator
│   │   ├── enums/              # User roles
│   │   ├── errors/             # Error types
│   │   ├── models/             # Doctor, PatientModel, AppointmentModel, ReviewModel, BookingDraft
│   │   ├── routes/             # app_routes.dart (router + route constants)
│   │   ├── services/           # auth, user, admin, appointment, favorite, cloudinary (+ local/)
│   │   ├── theme/              # AppColors, text styles
│   │   ├── utils/              # StringUtils, SnackBarHelper, ...
│   │   └── widgets/            # Shared widgets
│   ├── features/
│   │   ├── admin/presentation/{cubit,pages,widgets}
│   │   ├── appointments/{view_models,views}
│   │   ├── auth/{data,presentation}
│   │   ├── doctors/presentation/{cubit,pages,widgets}
│   │   ├── home/presentation/{cubit,pages,widgets}
│   │   ├── onboarding/  role/  splash/
│   │   ├── patient_profile/presentation/{cubit,pages,widgets}
│   │   └── search/presentation/pages
│   ├── i18n/                   # strings.i18n.json + generated strings*.g.dart
│   ├── firebase_options.dart   # Generated Firebase config
│   └── main.dart               # Entry point: Firebase init, DI, router
├── test/                       # Unit and widget tests
└── pubspec.yaml
```

## Setup & Installation

**Prerequisites:** Flutter SDK (Dart ≥ 3.10) with a connected device or emulator, and access to the Firebase project.

```bash
flutter pub get

# Regenerate translations after editing lib/i18n/strings.i18n.json
dart run slang

flutter run
```

Quality gates:

```bash
flutter analyze   # must stay clean
flutter test      # 14 unit tests
```

Firebase is already configured for the development project (see [Firebase](#firebase)), so a plain `flutter run` works out of the box.

## Firebase

### Services used

- **Firebase Authentication** — e-mail / password accounts (register, sign in, password reset, sign out)
- **Cloud Firestore** — all structured app data
- **Cloudinary** — hosts doctor photos and patient avatars; Firestore stores only the resulting URLs

### Firestore collections

| Path | Contents |
| --- | --- |
| `patients/{uid}` | Patient profile: `name`, `email`, `phone`, `dob` (`yyyy-MM-dd`), `gender` (`0` Male / `1` Female), `image` |
| `patients/{uid}/favorites/{doctorId}` | Favorite doctors for that patient |
| `doctors/{doctorId}` | Doctor profile: `name`, `image`, `specialization`, `consultationFee`, `workingDays[]`, `startTime`, `endTime`, `slotDuration`, `rating`, `reviewsCount`, `isActive` |
| `admins/{uid}` | Clinic-admin accounts |
| `clinic_info/central_clinic` | The single clinic location: `location` |
| `appointments/{autoId}` | Bookings: patient and doctor snapshots, `date`, `timeSlot`, `status`, `hasReviewed`, `reviewRating`, `reviewComment` |
| `reviews/{autoId}` | Ratings: `appointmentId`, `doctorId`, `patientId`, `patientName`, `rating`, `comment` |

### Data notes

- `workingDays` stores canonical English day names (`Monday`…`Sunday`) and times are stored as `hh:mm AM/PM`; the admin UI localizes them for display only.
- Deactivated doctors (`isActive: false`) are filtered out of every patient-facing list but stay visible in the admin panel.
- Firestore **security rules are not stored in this repository** — deploy and scope your own rules before any real deployment. There is also no Firebase Emulator Suite configuration.

## Development Notes

- **Conventions** (see `AGENTS.md`): all user-facing strings go through slang (`t.feature.key`), colors come only from `AppColors`, icons only from `MyIcons`, spacing uses the `.w` / `.h` / `verticalSpace` extensions, shimmer is preferred over spinners, and navigation uses `context.push` / `context.pop`.
- **References to the locked MVP**: no doctor app or doctor login, no doctor self-registration, no doctor-specific locations, no chat, payments, medical records, diagnostic tests, medicines or health packages. Google sign-in is still present on the auth screens even though it is outside the locked scope.

## Known Limitations

Tracked from the latest QA review — known and currently unfixed:

- **Double booking is possible** — `AppointmentService.createAppointment` does not check for an existing appointment on the same doctor, date and slot.
- **No authorization boundary on `/admin/*`** — the router has no guard, `AdminAppointmentsCubit` only checks that a user is signed in, and `AdminService.isAdmin` is never called. Admin surfaces rely on Firestore rules alone.
- **Rating recalculation runs client-side from the patient session**, writing to `doctors/{doctorId}`; under strict rules this silently fails.
- **Review submission is not transactional** (review create + appointment update + rating recalculation).
- **Several screens call services directly** instead of going through a cubit, which contradicts the project conventions.
- **Test coverage is limited** — the services, most cubits, routing and the i18n catalogue are not covered, and there are no integration tests.

## Testing

```text
test/
├── auth_cubit_test.dart
├── appointments_cubit_test.dart
├── patient_profile_view_test.dart
└── fakes/fake_services.dart
```

14 unit/widget tests, all green. There is no `integration_test/` directory yet.

## License

This repository currently has no explicit license. Contact the author if you want to use the code.

## Author

**Yousefahmed168** — [github.com/Yousefahmed168/codeplus-tasks](https://github.com/Yousefahmed168/codeplus-tasks)
