class Doctor {
  final String name;
  final String specialty;
  final int yearsExperience;
  final double ratingPercentage;
  final int patientStories;
  final String nextAvailableTime;
  final String imagePath;
  final bool isFavorite;
  final double hourlyRate;
  final int running;
  final int ongoing;
  final int patients;
  final List<String> services;

  const Doctor({
    required this.name,
    required this.specialty,
    required this.yearsExperience,
    required this.ratingPercentage,
    required this.patientStories,
    required this.nextAvailableTime,
    required this.imagePath,
    this.isFavorite = false,
    this.hourlyRate = 0,
    this.running = 0,
    this.ongoing = 0,
    this.patients = 0,
    this.services = const [],
  });

  Doctor copyWith({
    String? name,
    String? specialty,
    int? yearsExperience,
    double? ratingPercentage,
    int? patientStories,
    String? nextAvailableTime,
    String? imagePath,
    bool? isFavorite,
    double? hourlyRate,
    int? running,
    int? ongoing,
    int? patients,
    List<String>? services,
  }) {
    return Doctor(
      name: name ?? this.name,
      specialty: specialty ?? this.specialty,
      yearsExperience: yearsExperience ?? this.yearsExperience,
      ratingPercentage: ratingPercentage ?? this.ratingPercentage,
      patientStories: patientStories ?? this.patientStories,
      nextAvailableTime: nextAvailableTime ?? this.nextAvailableTime,
      imagePath: imagePath ?? this.imagePath,
      isFavorite: isFavorite ?? this.isFavorite,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      running: running ?? this.running,
      ongoing: ongoing ?? this.ongoing,
      patients: patients ?? this.patients,
      services: services ?? this.services,
    );
  }
}
