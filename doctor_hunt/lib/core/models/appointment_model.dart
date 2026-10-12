import 'package:cloud_firestore/cloud_firestore.dart';

/// Strictly enforced 3-state lifecycle for appointments:
/// - upcoming
/// - completed
/// - cancelled
enum AppointmentStatus {
  upcoming,
  completed,
  cancelled;

  static AppointmentStatus fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'completed':
        return AppointmentStatus.completed;
      case 'cancelled':
      case 'canceled':
        return AppointmentStatus.cancelled;
      case 'upcoming':
      default:
        return AppointmentStatus.upcoming;
    }
  }

  String toValue() => name;
}

class AppointmentModel {
  final String id;
  final String patientId;
  final String patientName;
  final String patientEmail;
  final String? patientPhone;
  final String doctorId;
  final String doctorName;
  final String? doctorSpecialty;
  final String? doctorImageUrl;
  final double doctorFee;
  final String clinicLocation;
  final DateTime date;
  final String timeSlot;
  final AppointmentStatus status;
  final DateTime? createdAt;
  final bool hasReviewed;
  final double? reviewRating;
  final String? reviewComment;

  const AppointmentModel({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.patientEmail,
    this.patientPhone,
    required this.doctorId,
    required this.doctorName,
    this.doctorSpecialty,
    this.doctorImageUrl,
    this.doctorFee = 0.0,
    required this.clinicLocation,
    required this.date,
    required this.timeSlot,
    this.status = AppointmentStatus.upcoming,
    this.createdAt,
    this.hasReviewed = false,
    this.reviewRating,
    this.reviewComment,
  });

  /// True strictly if consultation concluded and not yet reviewed.
  bool get canReview => status == AppointmentStatus.completed && !hasReviewed;

  /// True strictly if appointment is upcoming.
  bool get canCancel => status == AppointmentStatus.upcoming;

  factory AppointmentModel.fromJson(Map<String, dynamic> json, [String? id]) {
    final dateVal = json['date'];
    DateTime parsedDate;
    if (dateVal is Timestamp) {
      parsedDate = dateVal.toDate();
    } else if (dateVal is String) {
      parsedDate = DateTime.tryParse(dateVal) ?? DateTime.now();
    } else {
      parsedDate = DateTime.now();
    }

    final createdVal = json['createdAt'];
    DateTime? parsedCreatedAt;
    if (createdVal is Timestamp) {
      parsedCreatedAt = createdVal.toDate();
    } else if (createdVal is String) {
      parsedCreatedAt = DateTime.tryParse(createdVal);
    }

    return AppointmentModel(
      id: id ?? json['id']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? json['patientID']?.toString() ?? '',
      patientName: json['patientName']?.toString() ?? 'Patient',
      patientEmail: json['patientEmail']?.toString() ?? '',
      patientPhone: json['patientPhone']?.toString(),
      doctorId: json['doctorId']?.toString() ?? json['doctorID']?.toString() ?? '',
      doctorName: json['doctorName']?.toString() ?? 'Doctor',
      doctorSpecialty: json['doctorSpecialty']?.toString() ?? json['specialization']?.toString(),
      doctorImageUrl: json['doctorImageUrl']?.toString() ?? json['imageUrl']?.toString(),
      doctorFee: (json['doctorFee'] is num)
          ? (json['doctorFee'] as num).toDouble()
          : double.tryParse(json['doctorFee']?.toString() ?? '0') ?? 0.0,
      clinicLocation: json['clinicLocation']?.toString() ?? 'Central Clinic',
      date: parsedDate,
      timeSlot: json['timeSlot']?.toString() ?? '',
      status: AppointmentStatus.fromString(json['status']?.toString()),
      createdAt: parsedCreatedAt,
      hasReviewed: json['hasReviewed'] == true,
      reviewRating: (json['reviewRating'] is num)
          ? (json['reviewRating'] as num).toDouble()
          : double.tryParse(json['reviewRating']?.toString() ?? ''),
      reviewComment: json['reviewComment']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'patientEmail': patientEmail,
      'patientPhone': patientPhone,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'doctorSpecialty': doctorSpecialty,
      'doctorImageUrl': doctorImageUrl,
      'doctorFee': doctorFee,
      'clinicLocation': clinicLocation,
      'date': Timestamp.fromDate(date),
      'timeSlot': timeSlot,
      'status': status.toValue(),
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'hasReviewed': hasReviewed,
      if (reviewRating != null) 'reviewRating': reviewRating,
      if (reviewComment != null) 'reviewComment': reviewComment,
    };
  }

  AppointmentModel copyWith({
    String? id,
    String? patientId,
    String? patientName,
    String? patientEmail,
    String? patientPhone,
    String? doctorId,
    String? doctorName,
    String? doctorSpecialty,
    String? doctorImageUrl,
    double? doctorFee,
    String? clinicLocation,
    DateTime? date,
    String? timeSlot,
    AppointmentStatus? status,
    DateTime? createdAt,
    bool? hasReviewed,
    double? reviewRating,
    String? reviewComment,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      patientName: patientName ?? this.patientName,
      patientEmail: patientEmail ?? this.patientEmail,
      patientPhone: patientPhone ?? this.patientPhone,
      doctorId: doctorId ?? this.doctorId,
      doctorName: doctorName ?? this.doctorName,
      doctorSpecialty: doctorSpecialty ?? this.doctorSpecialty,
      doctorImageUrl: doctorImageUrl ?? this.doctorImageUrl,
      doctorFee: doctorFee ?? this.doctorFee,
      clinicLocation: clinicLocation ?? this.clinicLocation,
      date: date ?? this.date,
      timeSlot: timeSlot ?? this.timeSlot,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      hasReviewed: hasReviewed ?? this.hasReviewed,
      reviewRating: reviewRating ?? this.reviewRating,
      reviewComment: reviewComment ?? this.reviewComment,
    );
  }
}
