/// Role of a user in the app.
///
/// Single source of truth — replaces the legacy `UserTypeEnum`, which only
/// modelled doctor/patient and drifted from the Firestore collections.
enum UserRole { doctor, patient, admin }
