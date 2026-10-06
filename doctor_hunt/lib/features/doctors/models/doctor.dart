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

  // UI specific fields with default mock values
  bool isFavorite;
  double consultationFee;
  List<String> workingDays;
  String startTime;
  String endTime;
  int slotDuration;
  bool isActive; // Added for status toggle

  double get ratingPercentage => (rating ?? 0.0) * 20.0;

  Doctor({
    this.uid,
    this.name,
    this.imageUrl,
    this.specialization,
    this.rating,
    this.isFavorite = false,
    this.consultationFee = 0.0,
    this.workingDays = const ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
    this.startTime = '09:00 AM',
    this.endTime = '05:00 PM',
    this.slotDuration = 30,
    this.isActive = true,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      uid: json['uid']?.toString(),
      name: json['name']?.toString(),
      imageUrl: json['image']?.toString(),
      specialization: json['specialization']?.toString(),
      rating: _parseRating(json['rating']),
     
      isFavorite: json['isFavorite'] ?? false,
      consultationFee: json['consultationFee'] != null ? double.tryParse(json['consultationFee'].toString()) ?? 0.0 : 0.0,
      workingDays: json['workingDays'] != null ? List<String>.from(json['workingDays']) : ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      startTime: json['startTime'] ?? '09:00 AM',
      endTime: json['endTime'] ?? '05:00 PM',
      slotDuration: json['slotDuration'] ?? 30,
      isActive: json['isActive'] ?? true,
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
    data['isFavorite'] = isFavorite;
    data['consultationFee'] = consultationFee;
    data['workingDays'] = workingDays;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['slotDuration'] = slotDuration;
    data['isActive'] = isActive;
    return data;
  }

  Map<String, dynamic> toUpdateData() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (imageUrl != null) data['image'] = imageUrl;
    if (specialization != null) data['specialization'] = specialization;
    if (rating != null) data['rating'] = rating;
    
    data['isFavorite'] = isFavorite;
    data['consultationFee'] = consultationFee;
    data['workingDays'] = workingDays;
    data['startTime'] = startTime;
    data['endTime'] = endTime;
    data['slotDuration'] = slotDuration;
    data['isActive'] = isActive;
    return data;
  }

  Doctor copyWith({
    String? uid,
    String? name,
    String? imageUrl,
    String? specialization,
    double? rating,
    bool? isFavorite,
    double? consultationFee,
    List<String>? workingDays,
    String? startTime,
    String? endTime,
    int? slotDuration,
    bool? isActive,
  }) {
    return Doctor(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      specialization: specialization ?? this.specialization,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
      consultationFee: consultationFee ?? this.consultationFee,
      workingDays: workingDays ?? this.workingDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      slotDuration: slotDuration ?? this.slotDuration,
      isActive: isActive ?? this.isActive,
    );
  }
}
