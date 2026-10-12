import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../core/widgets/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/theme/style_atoms.dart';
import '../../../../i18n/strings.g.dart';
import '../../../auth/data/models/patient_model.dart';
import '../../../auth/presentation/cubit/patient_profile_cubit.dart';
import '../../../auth/presentation/cubit/patient_profile_state.dart';
import '../../../auth/presentation/widgets/logout_dialog.dart';
import 'patient_profile_view.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _ageCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _bioCtrl;
  int? _selectedGender;
  String? _localImagePath;
  bool _isPopulated = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    _ageCtrl = TextEditingController();
    _cityCtrl = TextEditingController();
    _bioCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _ageCtrl.dispose();
    _cityCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  void _populateControllers(PatientModel p) {
    _nameCtrl.text = p.name ?? '';
    _phoneCtrl.text = p.phone ?? '';
    _ageCtrl.text = p.age ?? '';
    _cityCtrl.text = p.city ?? '';
    _bioCtrl.text = p.bio ?? '';
    _selectedGender = p.gender;
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
    );
    if (picked != null) setState(() => _localImagePath = picked.path);
  }

  Future<void> _handleLogout(BuildContext context) async {
    FocusScope.of(context).unfocus();
    final confirmed = await LogoutDialog.show(context);
    if (confirmed == true) {
      if (!context.mounted) return;
      await context.read<PatientProfileCubit>().logout();
      if (context.mounted) context.go(AppRoutes.role);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientProfileCubit()..loadProfile(),
      child: BlocConsumer<PatientProfileCubit, PatientProfileState>(
        listener: (context, state) {
          if (state is PatientProfileLoaded && !_isPopulated) {
            _populateControllers(state.patient);
            _isPopulated = true;
          }
          if (state is PatientProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          PatientModel? patient;
          final isLoading =
              state is PatientProfileLoading || state is PatientProfileInitial;
          final isSaving = state is PatientProfileSaving;

          if (state is PatientProfileLoaded) {
            patient = state.patient;
            if (!_isPopulated) {
              _populateControllers(patient);
              _isPopulated = true;
            }
          } else if (state is PatientProfileSaving) {
            patient = state.patient;
          }

          return Scaffold(
            backgroundColor: AppColors.background,
            body: isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  )
                : CustomScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    slivers: [
                      _buildHeader(context, patient),
                      SliverToBoxAdapter(
                        child: patient != null
                            ? PatientProfileView(
                                patient: patient,
                                isSaving: isSaving,
                                nameCtrl: _nameCtrl,
                                phoneCtrl: _phoneCtrl,
                                ageCtrl: _ageCtrl,
                                cityCtrl: _cityCtrl,
                                bioCtrl: _bioCtrl,
                                selectedGender: _selectedGender,
                                localImagePath: _localImagePath,
                                onGenderChanged: (v) =>
                                    setState(() => _selectedGender = v),
                                onSave: () async {
                                  if (patient == null) return;
                                  await context
                                      .read<PatientProfileCubit>()
                                      .updateProfile(
                                        currentPatient: patient,
                                        name: _nameCtrl.text,
                                        phone: _phoneCtrl.text,
                                        age: _ageCtrl.text,
                                        city: _cityCtrl.text,
                                        bio: _bioCtrl.text,
                                        gender: _selectedGender,
                                        localImagePath: _localImagePath,
                                      );
                                  setState(() {
                                    _localImagePath = null;
                                  });
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Profile updated successfully',
                                        ),
                                        backgroundColor: AppColors.success,
                                      ),
                                    );
                                  }
                                },
                                onLogoutTap: () => _handleLogout(context),
                              )
                            : const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(32),
                                  child: Text('No profile data found'),
                                ),
                              ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, PatientModel? patient) {
    final imageUrl = patient?.image;
    final hasImage = imageUrl != null && imageUrl.isNotEmpty;
    final canPop = Navigator.canPop(context);

    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        padding: const EdgeInsets.only(
          top: 48,
          left: 20,
          right: 20,
          bottom: 24,
        ),
        child: Column(
          children: [
            // Top Navigation & Action Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (canPop)
                  const CustomBackButton()
                else
                  const SizedBox(width: 40),
                Text(
                  t.patientProfile.title,
                  style: context.bold18.copyWith(color: Colors.white),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.settings_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () => context.push(AppRoutes.patientSettings),
                ),
              ],
            ),
            const Gap(16),

            // Setup Profile Header Subtitle
            Text(
              t.patientProfile.setupProfile,
              style: context.bold18.copyWith(color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const Gap(20),

            // Profile Avatar with Camera Edit Badge
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: _localImagePath != null
                          ? Image.file(
                              File(_localImagePath!),
                              fit: BoxFit.cover,
                            )
                          : hasImage
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (_, _) => const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              errorWidget: (_, _, _) => const Icon(
                                Icons.person_rounded,
                                size: 50,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(
                              Icons.person_rounded,
                              size: 50,
                              color: Colors.white,
                            ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 16,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Gap(8),
          ],
        ),
      ),
    );
  }
}
