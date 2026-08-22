import 'package:doctor_hunt/core/constants/assets.dart';
import 'package:doctor_hunt/core/routes/app_routes.dart';
import 'package:doctor_hunt/core/theme/colors.dart';
import 'package:doctor_hunt/core/theme/style_atoms.dart';
import 'package:doctor_hunt/features/doctors/models/doctor_model.dart';
import 'package:doctor_hunt/features/doctors/presentation/widgets/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import '../../../../i18n/strings.g.dart';

class FindDoctorScreen extends StatefulWidget {
  const FindDoctorScreen({super.key});

  @override
  State<FindDoctorScreen> createState() => _FindDoctorScreenState();
}

class _FindDoctorScreenState extends State<FindDoctorScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String _searchQuery = "";

  final List<String> _recentSearches = [
    'Dentist',
    'Cardiologist',
    'Pediatrician',
    'Dermatologist',
  ];

  final List<Doctor> _allDoctors = const [
    Doctor(
      name: 'Dr. Shruti Kedia',
      specialty: 'Tooths Dentist',
      yearsExperience: 7,
      ratingPercentage: 87,
      patientStories: 69,
      nextAvailableTime: '10:00 AM',
      imagePath: Assets.resourceImagesDoctor1,
      isFavorite: true,
    ),
    Doctor(
      name: 'Dr. Watamaniuk',
      specialty: 'Tooths Dentist',
      yearsExperience: 9,
      ratingPercentage: 74,
      patientStories: 78,
      nextAvailableTime: '12:00 AM',
      imagePath: Assets.resourceImagesDoctor2,
    ),
    Doctor(
      name: 'Dr. Crownover',
      specialty: 'Tooths Dentist',
      yearsExperience: 5,
      ratingPercentage: 59,
      patientStories: 86,
      nextAvailableTime: '11:00 AM',
      imagePath: Assets.resourceImagesDoctor3,
      isFavorite: true,
    ),
    Doctor(
      name: 'Dr. Balestra',
      specialty: 'Tooths Dentist',
      yearsExperience: 6,
      ratingPercentage: 72,
      patientStories: 53,
      nextAvailableTime: '2:00 PM',
      imagePath: Assets.resourceImagesDoctor,
    ),
    Doctor(
      name: 'Dr. Pediatrician',
      specialty: 'Specialist Cardiologist',
      yearsExperience: 10,
      ratingPercentage: 95,
      patientStories: 120,
      nextAvailableTime: '9:00 AM',
      imagePath: Assets.resourceImagesDoctor1,
      hourlyRate: 28.00,
    ),
    Doctor(
      name: 'Dr. Fillerup Grab',
      specialty: 'Medicine Specialist',
      yearsExperience: 12,
      ratingPercentage: 91,
      patientStories: 200,
      nextAvailableTime: '3:00 PM',
      imagePath: Assets.resourceImagesDoctor2,
      hourlyRate: 35.00,
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  List<Doctor> get _filteredDoctors {
    if (_searchQuery.isEmpty) return [];
    return _allDoctors
        .where(
          (d) =>
              d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              d.specialty.toLowerCase().contains(_searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Gap(16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      } else {
                        context.go(AppRoutes.home);
                      }
                    },
                    child: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Gap(12),
                  Text(t.findDoctors.title, style: context.bold20.textPrimary),
                ],
              ),
            ),
            Gap(20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border, width: 1.5),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 22,
                      color: AppColors.textHint,
                    ),
                    Gap(10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        focusNode: _focusNode,
                        onChanged: (v) => setState(() => _searchQuery = v),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: t.findDoctors.searchHintExtra,
                          hintStyle: context.regular14.textHint,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: context.regular14.textPrimary,
                      ),
                    ),
                    if (_searchQuery.isNotEmpty)
                      GestureDetector(
                        onTap: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                        child: const Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: AppColors.textHint,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Gap(24),
            Expanded(
              child: _searchQuery.isEmpty
                  ? _buildRecentSearches()
                  : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.findDoctors.recentSearches, style: context.bold16.textPrimary),
          Gap(16),
          ...List.generate(_recentSearches.length, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GestureDetector(
                onTap: () {
                  _searchController.text = _recentSearches[i];
                  setState(() => _searchQuery = _recentSearches[i]);
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.history_rounded,
                      size: 20,
                      color: AppColors.textHint,
                    ),
                    Gap(12),
                    Text(
                      _recentSearches[i],
                      style: context.regular14.textSecondary,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    final results = _filteredDoctors;
    if (results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off_rounded,
              size: 64,
              color: AppColors.textHint.withValues(alpha: 0.5),
            ),
            Gap(16),
            Text(
              t.findDoctors.noDoctorsFound,
              style: context.bold16.textSecondary,
            ),
            Gap(8),
            Text(
              t.findDoctors.tryDifferentSearchTerm,
              style: context.regular14.textHint,
            ),
          ],
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: results.length,
      separatorBuilder: (_, _) => Gap(16),
      itemBuilder: (context, index) {
        final doctor = results[index];
        return DoctorCard(
          doctor: doctor,
          onTap: () => context.push(AppRoutes.doctorDetails, extra: doctor),
          onBookNow: () {},
          onFavoriteToggle: () {},
        );
      },
    );
  }
}
