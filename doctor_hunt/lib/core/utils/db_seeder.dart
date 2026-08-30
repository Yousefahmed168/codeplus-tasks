import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../services/auth_service.dart';

class DbSeeder {
  static Future<void> seedDoctors() async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection(AuthService.doctorsCollection);

    final mockDoctors = [
      {
        'name': 'Dr. Marcus Horizon',
        'specialization': 'Cardiologist',
        'rating': 4.7,
        'email': 'marcus@example.com',
        'phone1': '+1234567890',
        'bio': 'Experienced cardiologist with 10+ years of practice.',
      },
      {
        'name': 'Dr. Alysa Hana',
        'specialization': 'Pediatrician',
        'rating': 4.9,
        'email': 'alysa@example.com',
        'phone1': '+1987654321',
        'bio': 'Specialist in pediatric care and child development.',
      },
      {
        'name': 'Dr. Maria Elena',
        'specialization': 'Dermatologist',
        'rating': 4.5,
        'email': 'maria@example.com',
        'phone1': '+1122334455',
        'bio': 'Expert in skin conditions and aesthetic treatments.',
      },
      {
        'name': 'Dr. Stefi Jessi',
        'specialization': 'Orthopedist',
        'rating': 4.8,
        'email': 'stefi@example.com',
        'phone1': '+1555666777',
        'bio': 'Focuses on musculoskeletal system issues.',
      }
    ];

    try {
      for (var doctor in mockDoctors) {
        await collection.add(doctor);
      }
      debugPrint('Successfully seeded ${mockDoctors.length} doctors.');
    } catch (e) {
      debugPrint('Failed to seed doctors: $e');
    }
  }
}
