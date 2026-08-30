import 'doctor.dart';

/// Firestore data model for a doctor document.
///
/// Fields match the Firestore document structure. Use [toDoctor] to convert
/// to the UI-facing [Doctor] model used by widgets.
class DoctorModel {
  String? uid;
  String? name;
  String? imageUrl;
  String? specialization;
  double? rating;
  String? email;
  String? phone1;
  String? phone2;
  String? bio;
  String? openHour;
  String? closeHour;
  String? address;

  DoctorModel({
    this.name,
    this.imageUrl,
    this.specialization,
    this.rating,
    this.email,
    this.phone1,
    this.phone2,
    this.bio,
    this.openHour,
    this.closeHour,
    this.address,
    this.uid,
  });

  DoctorModel.fromJson(Map<String, dynamic> json) {
    name = json['name']?.toString();
    imageUrl = json['image']?.toString();
    specialization = json['specialization']?.toString();
    rating = _parseRating(json['rating']);
    email = json['email']?.toString();
    phone1 = json['phone1']?.toString();
    phone2 = json['phone2']?.toString();
    bio = json['bio']?.toString();
    openHour = json['openHour']?.toString();
    closeHour = json['closeHour']?.toString();
    address = json['address']?.toString();
    uid = json['uid']?.toString();
  }

  /// Safely parse rating which may be stored as int or double in Firestore.
  static double? _parseRating(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['image'] = imageUrl;
    data['specialization'] = specialization;
    data['rating'] = rating;
    data['email'] = email;
    data['phone1'] = phone1;
    data['phone2'] = phone2;
    data['bio'] = bio;
    data['openHour'] = openHour;
    data['closeHour'] = closeHour;
    data['address'] = address;
    data['uid'] = uid;
    return data;
  }

  Map<String, dynamic> toUpdateData() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (imageUrl != null) data['image'] = imageUrl;
    if (specialization != null) data['specialization'] = specialization;
    if (rating != null) data['rating'] = rating;
    if (email != null) data['email'] = email;
    if (phone1 != null) data['phone1'] = phone1;
    if (phone2 != null) data['phone2'] = phone2;
    if (bio != null) data['bio'] = bio;
    if (openHour != null) data['openHour'] = openHour;
    if (closeHour != null) data['closeHour'] = closeHour;
    if (address != null) data['address'] = address;
    return data;
  }

  /// Converts this Firestore model to the UI-facing [Doctor] model.
  ///
  /// Pass [isFavorite] to reflect the current patient's favorite state.
  Doctor toDoctor({bool isFavorite = false}) {
    return Doctor(
      name: name ?? 'Unknown',
      specialty: specialization ?? 'General',
      yearsExperience: 0,
      ratingPercentage: (rating ?? 0) * 20, // Convert 0-5 to 0-100%
      patientStories: 0,
      nextAvailableTime: openHour ?? 'N/A',
      imagePath: (imageUrl != null && imageUrl!.isNotEmpty)
          ? imageUrl!
          : 'assets/images/doctor.png',
      isFavorite: isFavorite,
      hourlyRate: 0,
      running: 0,
      ongoing: 0,
      patients: 0,
      services: const [],
    );
  }
}
