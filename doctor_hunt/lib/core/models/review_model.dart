import 'package:cloud_firestore/cloud_firestore.dart';

/// A single patient review for a doctor, as stored in the `reviews`
/// collection. Kept read-only in the patient app (created through
/// `AppointmentService.submitReview`).
class ReviewModel {
  final String id;
  final String appointmentId;
  final String doctorId;
  final String patientId;
  final String? patientName;
  final double rating;
  final String comment;
  final DateTime? createdAt;

  const ReviewModel({
    required this.id,
    required this.appointmentId,
    required this.doctorId,
    required this.patientId,
    this.patientName,
    required this.rating,
    this.comment = '',
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json, [String? id]) {
    final createdVal = json['createdAt'];
    DateTime? parsedCreatedAt;
    if (createdVal is Timestamp) {
      parsedCreatedAt = createdVal.toDate();
    } else if (createdVal is String) {
      parsedCreatedAt = DateTime.tryParse(createdVal);
    }

    return ReviewModel(
      id: id ?? json['id']?.toString() ?? '',
      appointmentId: json['appointmentId']?.toString() ?? '',
      doctorId: json['doctorId']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      patientName: json['patientName']?.toString(),
      rating: (json['rating'] is num)
          ? (json['rating'] as num).toDouble()
          : double.tryParse(json['rating']?.toString() ?? '') ?? 0.0,
      comment: json['comment']?.toString() ?? '',
      createdAt: parsedCreatedAt,
    );
  }
}
