import '../../features/doctors/models/doctor_model.dart';
import '../utils/app_images.dart';

/// Single source-of-truth for dummy doctor data used across the app.
///
/// Usage:
///   DummyDoctors.all          — full list
///   DummyDoctors.first        — first doctor (convenience alias)
///   DummyDoctors.all[index]   — pick by index
abstract class DummyDoctors {
  DummyDoctors._();

  static final List<Doctor> all = const [
    Doctor(
      name: 'Dr. Crick',
      specialty: 'Cardiologist',
      yearsExperience: 5,
      ratingPercentage: 4.8,
      patientStories: 120,
      nextAvailableTime: '10:00 AM',
      imagePath: AppImages.doctor,
      isFavorite: false,
      hourlyRate: 25.00,
      running: 100,
      ongoing: 500,
      patients: 700,
      services: [
        'Patient care should be the number one priority.',
        'If you run your practice you know how frustrating.',
        "That's why some of appointment reminder system.",
      ],
    ),
    Doctor(
      name: 'Dr. Fillerup Grab',
      specialty: 'Medicine Specialist',
      yearsExperience: 12,
      ratingPercentage: 4.5,
      patientStories: 200,
      nextAvailableTime: '3:00 PM',
      imagePath: AppImages.doctor1,
      isFavorite: false,
      hourlyRate: 35.00,
      running: 80,
      ongoing: 320,
      patients: 530,
      services: [
        'Patient care should be the number one priority.',
        'If you run your practice you know how frustrating.',
        "That's why some of appointment reminder system.",
      ],
    ),
    Doctor(
      name: 'Dr. Blessing',
      specialty: 'Dentist Specialist',
      yearsExperience: 9,
      ratingPercentage: 4.0,
      patientStories: 78,
      nextAvailableTime: '12:00 PM',
      imagePath: AppImages.doctor2,
      isFavorite: true,
      hourlyRate: 22.00,
      running: 60,
      ongoing: 210,
      patients: 410,
      services: [
        'Patient care should be the number one priority.',
        'If you run your practice you know how frustrating.',
        "That's why some of appointment reminder system.",
      ],
    ),
    Doctor(
      name: 'Dr. Shruti Kedia',
      specialty: 'Tooths Dentist',
      yearsExperience: 7,
      ratingPercentage: 4.3,
      patientStories: 69,
      nextAvailableTime: '10:00 AM',
      imagePath: AppImages.doctor1,
      isFavorite: true,
      hourlyRate: 20.00,
      running: 45,
      ongoing: 180,
      patients: 300,
      services: [
        'Patient care should be the number one priority.',
        'If you run your practice you know how frustrating.',
        "That's why some of appointment reminder system.",
      ],
    ),
    Doctor(
      name: 'Dr. Crownover',
      specialty: 'Tooths Dentist',
      yearsExperience: 5,
      ratingPercentage: 3.0,
      patientStories: 86,
      nextAvailableTime: '11:00 AM',
      imagePath: AppImages.doctor3,
      isFavorite: true,
      hourlyRate: 18.00,
      running: 30,
      ongoing: 140,
      patients: 250,
      services: [
        'Patient care should be the number one priority.',
        'If you run your practice you know how frustrating.',
        "That's why some of appointment reminder system.",
      ],
    ),
    Doctor(
      name: 'Dr. Lachinet',
      specialty: 'Specialist Cardiologist',
      yearsExperience: 10,
      ratingPercentage: 4.7,
      patientStories: 150,
      nextAvailableTime: '9:00 AM',
      imagePath: AppImages.doctor3,
      isFavorite: false,
      hourlyRate: 29.00,
      running: 90,
      ongoing: 400,
      patients: 620,
      services: [
        'Patient care should be the number one priority.',
        'If you run your practice you know how frustrating.',
        "That's why some of appointment reminder system.",
      ],
    ),
  ];

  /// Convenience shorthand - first doctor in the list.
  static Doctor get first => all.first;
}
