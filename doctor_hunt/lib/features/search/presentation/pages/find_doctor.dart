import '../../../../core/widgets/custom_text_form_field.dart';

import '../../../../core/data/dummy_doctors.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../doctors/models/doctor_model.dart';
import '../../../doctors/presentation/widgets/doctor_card.dart';
import '../../../../core/widgets/app_background.dart';
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

  List<Doctor> get _allDoctors => DummyDoctors.all;

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
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
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
                    Text(
                      t.findDoctors.title,
                      style: context.bold20.textPrimary,
                    ),
                  ],
                ),
              ),
              Gap(20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                          child: Icon(
                            Icons.close_rounded,
                            color: AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.success,
                          size: 16,
                        ),
                        controller: _searchController,
                        onChange: (v) => setState(() => _searchQuery = v),
                        textInputAction: TextInputAction.search,
                        hintText: t.home.searchHint,
                      ),
                    ),
                  ],
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
