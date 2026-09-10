/// Unified model for a doctor document and UI representation.
///
/// Fields match the Firestore document structure. UI-specific properties
/// such as [isFavorite] are kept local and not serialized to Firestore.
class Doctor {
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

  // UI specific fields with default mock values
  int yearsExperience;
  int patientStories;
  bool isFavorite;
  double hourlyRate;
  int running;
  int ongoing;
  int patients;
  List<String> services;

  double get ratingPercentage => (rating ?? 0.0) * 20.0;
  String get nextAvailableTime => openHour ?? 'N/A';

  Doctor({
    this.uid,
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
    this.yearsExperience = 0,
    this.patientStories = 0,
    this.isFavorite = false,
    this.hourlyRate = 0,
    this.running = 0,
    this.ongoing = 0,
    this.patients = 0,
    this.services = const [],
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      uid: json['uid']?.toString(),
      name: json['name']?.toString(),
      imageUrl: json['image']?.toString(),
      specialization: json['specialization']?.toString(),
      rating: _parseRating(json['rating']),
      email: json['email']?.toString(),
      phone1: json['phone1']?.toString(),
      phone2: json['phone2']?.toString(),
      bio: json['bio']?.toString(),
      openHour: json['openHour']?.toString(),
      closeHour: json['closeHour']?.toString(),
      address: json['address']?.toString(),
      // Mock UI properties could be loaded from json if they exist
      yearsExperience: json['yearsExperience'] ?? 0,
      patientStories: json['patientStories'] ?? 0,
      hourlyRate: json['hourlyRate'] != null ? double.tryParse(json['hourlyRate'].toString()) ?? 0 : 0,
      running: json['running'] ?? 0,
      ongoing: json['ongoing'] ?? 0,
      patients: json['patients'] ?? 0,
      services: json['services'] != null ? List<String>.from(json['services']) : [],
    );
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
    data['uid'] = uid;
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
    data['yearsExperience'] = yearsExperience;
    data['patientStories'] = patientStories;
    data['hourlyRate'] = hourlyRate;
    data['running'] = running;
    data['ongoing'] = ongoing;
    data['patients'] = patients;
    data['services'] = services;
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
    
    // Also include UI specific fields if they are updated
    data['yearsExperience'] = yearsExperience;
    data['patientStories'] = patientStories;
    data['hourlyRate'] = hourlyRate;
    data['running'] = running;
    data['ongoing'] = ongoing;
    data['patients'] = patients;
    data['services'] = services;
    return data;
  }

  Doctor copyWith({
    String? uid,
    String? name,
    String? imageUrl,
    String? specialization,
    double? rating,
    String? email,
    String? phone1,
    String? phone2,
    String? bio,
    String? openHour,
    String? closeHour,
    String? address,
    int? yearsExperience,
    int? patientStories,
    bool? isFavorite,
    double? hourlyRate,
    int? running,
    int? ongoing,
    int? patients,
    List<String>? services,
  }) {
    return Doctor(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      specialization: specialization ?? this.specialization,
      rating: rating ?? this.rating,
      email: email ?? this.email,
      phone1: phone1 ?? this.phone1,
      phone2: phone2 ?? this.phone2,
      bio: bio ?? this.bio,
      openHour: openHour ?? this.openHour,
      closeHour: closeHour ?? this.closeHour,
      address: address ?? this.address,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      patientStories: patientStories ?? this.patientStories,
      isFavorite: isFavorite ?? this.isFavorite,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      running: running ?? this.running,
      ongoing: ongoing ?? this.ongoing,
      patients: patients ?? this.patients,
      services: services ?? this.services,
    );
  }
}
